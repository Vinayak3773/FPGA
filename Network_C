#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdbool.h>

#define NUM_HIDDEN 250
#define NUM_OUTPUT 5
#define TIMESTEPS 1000
#define DT 1.0  // time step (ms)
#define THRESHOLD 30.0

typedef struct {
    double v;
    double w;
    bool spike;
} AdExNeuron;

// AdEx parameters
const double C = 3.0;
const double gL = 1.5;
const double EL = -65.0;
const double Vr = -75.0;
const double Vth = -55.0;
const double Delta_T = 2.0;
const double tau_w = 20.0;
const double a = 4.0;
const double b = -10.0;

// Initialize neuron
void init_neuron(AdExNeuron *n) {
    n->v = EL;
    n->w = 0.0;
    n->spike = false;
}

// AdEx model update
void update_neuron(AdExNeuron *n, double I) {
    double v_next = n->v + DT * (1.0 / C) *
                    (-gL * (n->v - EL) + gL * Delta_T * exp((n->v - Vth) / Delta_T) - n->w + I);
    double w_next = n->w + DT * (1.0 / tau_w) * (a * (n->v - EL) - n->w);

    if (v_next >= THRESHOLD) {
        n->spike = true;
        n->v = Vr;
        n->w += b;
    } else {
        n->spike = false;
        n->v = v_next;
        n->w = w_next;
    }
}

int main() {
    AdExNeuron hidden_layer[NUM_HIDDEN];
    AdExNeuron output_layer[NUM_OUTPUT];

    int weights_hidden[NUM_HIDDEN];
    int weights_output[NUM_OUTPUT][NUM_HIDDEN];
    double I_hidden[NUM_HIDDEN];
    double I_output[NUM_OUTPUT];
    double I_external = 20.0;

    FILE *f_hidden_in = fopen("hidden_layer_input.txt", "w");
    FILE *f_hidden_out = fopen("hidden_layer_output.txt", "w");
    FILE *f_net_out = fopen("network_output.txt", "w");

    // Initialize neurons
    for (int i = 0; i < NUM_HIDDEN; i++) init_neuron(&hidden_layer[i]);
    for (int i = 0; i < NUM_OUTPUT; i++) init_neuron(&output_layer[i]);

    // Initialize hidden weights (shuffled)
    int base_weights[8] = {3, 5, 1, 7, 2, 4, 6, 0};
    for (int i = 0; i < NUM_HIDDEN; i++) {
        weights_hidden[i] = base_weights[i % 8];
    }

    // Initialize output weights (shuffled per neuron)
    for (int o = 0; o < NUM_OUTPUT; o++) {
        for (int i = 0; i < NUM_HIDDEN; i++) {
            weights_output[o][i] = base_weights[(i + o) % 8];
        }
    }

    // Simulation loop
    for (int t = 0; t < TIMESTEPS; t++) {
        // Hidden layer
        for (int i = 0; i < NUM_HIDDEN; i++) {
            I_hidden[i] = I_external * weights_hidden[i];
            fprintf(f_hidden_in, "%d\t%d\t%.2f\t%d\t%.2f\n", t, i, I_external, weights_hidden[i], I_hidden[i]);
            update_neuron(&hidden_layer[i], I_hidden[i]);
            fprintf(f_hidden_out, "%d\t%d\t%d\t%.2f\n", t, i, hidden_layer[i].spike, hidden_layer[i].v);
        }

        // Output layer
        for (int o = 0; o < NUM_OUTPUT; o++) {
            double sum = 0;
            for (int i = 0; i < NUM_HIDDEN; i++) {
                sum += (hidden_layer[i].spike ? 1 : 0) * weights_output[o][i];
            }
            I_output[o] = sum / 6.0;
            update_neuron(&output_layer[o], I_output[o]);
        }

        // Log network output
        fprintf(f_net_out, "%d\t%.2f", t, I_external);
        for (int o = 0; o < NUM_OUTPUT; o++) {
            fprintf(f_net_out, "\t%d", output_layer[o].spike);
        }
        fprintf(f_net_out, "\n");
    }

    fclose(f_hidden_in);
    fclose(f_hidden_out);
    fclose(f_net_out);

    return 0;
}
