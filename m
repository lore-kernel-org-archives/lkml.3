Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaLaPOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:14:08 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43143 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaLaPOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:14:05 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] sound: pci: asihpi: hpifunc.c:  Remove some unused functions
Date: Wed, 31 Dec 2014 16:17:02 +0100
Message-Id: <1420039022-10018-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
hpi_stream_response_to_legacy() hpi_outstream_host_buffer_free()
hpi_outstream_host_buffer_get_info() hpi_outstream_host_buffer_allocate()
hpi_outstream_set_time_scale() hpi_outstream_ancillary_read()
hpi_outstream_ancillary_get_info() hpi_outstream_ancillary_reset()
hpi_outstream_set_punch_in_out() hpi_outstream_set_velocity()
hpi_outstream_set_format() hpi_outstream_sinegen() hpi_outstream_wait_start()
hpi_stream_estimate_buffer_size() hpi_vox_get_threshold() hpi_vox_set_threshold()
hpi_volume_query_auto_fade_profile() hpi_volume_auto_fade()
hpi_adapter_enumerate_property() hpi_volume_query_channels() hpi_pad_get_rdsPI()
hpi_pad_get_program_type() hpi_pad_get_comment() hpi_pad_get_title()
hpi_pad_get_artist() hpi_pad_get_channel_name() hpi_tuner_get_rds()
hpi_tuner_set_hd_radio_signal_blend() hpi_tuner_get_hd_radio_signal_blend()
hpi_tuner_get_hd_radio_signal_quality() hpi_tuner_get_mode() hpi_tuner_set_mode()
hpi_tuner_get_status() hpi_tuner_get_hd_radio_sdk_version()
hpi_tuner_get_hd_radio_dsp_version() hpi_tuner_get_program()
hpi_tuner_set_program() hpi_tuner_query_program() hpi_tuner_get_deemphasis()
hpi_tuner_set_deemphasis() hpi_tuner_query_deemphasis()
hpi_tuner_get_raw_rf_level() hpi_tuner_get_rf_level()
hpi_silence_detector_get_threshold() hpi_silence_detector_set_threshold()
hpi_silence_detector_get_delay() hpi_silence_detector_set_delay()
hpi_silence_detector_get_event_enable() hpi_silence_detector_set_event_enable()
hpi_silence_detector_get_enable() hpi_silence_detector_set_enable()
hpi_silence_detector_get_state() hpi_tone_detector_get_threshold()
hpi_tone_detector_set_threshold() hpi_tone_detector_get_event_enable()
hpi_tone_detector_set_event_enable() hpi_tone_detector_get_enable()
hpi_volume_auto_fade_profile() hpi_tone_detector_set_enable()
hpi_tone_detector_get_state() hpi_tone_detector_get_frequency()
hpi_sample_clock_get_local_rate_lock() hpi_sample_clock_set_local_rate_lock()
hpi_sample_clock_get_auto() hpi_sample_clock_set_auto()
hpi_parametric_eq_get_coeffs() hpi_parametric_eq_set_band()
hpi_parametric_eq_get_band() hpi_parametric_eq_set_state()
hpi_parametric_eq_get_info() hpi_adapter_get_module_by_index()
hpi_microphone_get_phantom_power() hpi_microphone_set_phantom_power()
hpi_meter_get_peak_ballistics() hpi_meter_set_peak_ballistics()
hpi_meter_get_rms_ballistics() hpi_meter_set_rms_ballistics() hpi_meter_get_rms()
hpi_compander_get_ratio() hpi_compander_set_ratio() hpi_compander_get_threshold()
hpi_compander_set_threshold() hpi_compander_get_decay_time_constant()
hpi_compander_set_decay_time_constant() hpi_compander_get_attack_time_constant()
hpi_compander_set_attack_time_constant() hpi_compander_get_makeup_gain()
hpi_compander_set_makeup_gain() hpi_compander_get_enable()
hpi_compander_set_enable() hpi_adapter_get_mode() hpi_cobranet_get_macaddress()
hpi_cobranet_set_static_ip_address() hpi_cobranet_get_static_ip_address()
hpi_cobranet_set_ip_address() hpi_cobranet_get_ip_address()
hpi_cobranet_hmi_get_status() hpi_adapter_set_mode() hpi_bitstream_get_activity()
hpi_bitstream_set_data_polarity() hpi_bitstream_set_clock_edge()
hpi_aesebu_transmitter_query_format() hpi_aesebu_transmitter_get_channel_status()
hpi_aesebu_transmitter_set_channel_status() hpi_aesebu_transmitter_set_user_data()
hpi_aesebu_transmitter_set_sample_rate() hpi_aesebu_receiver_get_channel_status()
hpi_aesebu_receiver_get_user_data() hpi_aesebu_receiver_get_sample_rate()
hpi_adapter_close() hpi_aesebu_receiver_query_format() hpi_adapter_open()
hpi_mixer_store() hpi_mixer_close() hpi_subsys_get_adapter()
hpi_instream_host_buffer_get_info() hpi_subsys_get_num_adapters()
hpi_instream_host_buffer_allocate() hpi_instream_ancillary_write()
hpi_instream_ancillary_get_info() hpi_instream_ancillary_reset()
hpi_adapter_set_mode_ex()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 sound/pci/asihpi/hpi.h          |  304 -------
 sound/pci/asihpi/hpi_internal.h |    7 -
 sound/pci/asihpi/hpifunc.c      | 1693 ++++-----------------------------------
 3 files changed, 136 insertions(+), 1868 deletions(-)

diff --git a/sound/pci/asihpi/hpi.h b/sound/pci/asihpi/hpi.h
index 2088724..fa9c607 100644
--- a/sound/pci/asihpi/hpi.h
+++ b/sound/pci/asihpi/hpi.h
@@ -1152,13 +1152,6 @@ struct hpi_async_event {
 #pragma pack(pop)
 #endif
 
-/*****************/
-/* HPI FUNCTIONS */
-/*****************/
-
-/* Stream */
-u16 hpi_stream_estimate_buffer_size(struct hpi_format *pF,
-	u32 host_polling_rate_in_milli_seconds, u32 *recommended_buffer_size);
 
 /*************/
 /* SubSystem */
@@ -1166,34 +1159,14 @@ u16 hpi_stream_estimate_buffer_size(struct hpi_format *pF,
 
 u16 hpi_subsys_get_version_ex(u32 *pversion_ex);
 
-u16 hpi_subsys_get_num_adapters(int *pn_num_adapters);
-
-u16 hpi_subsys_get_adapter(int iterator, u32 *padapter_index,
-	u16 *pw_adapter_type);
-
 /***********/
 /* Adapter */
 /***********/
 
-u16 hpi_adapter_open(u16 adapter_index);
-
-u16 hpi_adapter_close(u16 adapter_index);
-
 u16 hpi_adapter_get_info(u16 adapter_index, u16 *pw_num_outstreams,
 	u16 *pw_num_instreams, u16 *pw_version, u32 *pserial_number,
 	u16 *pw_adapter_type);
 
-u16 hpi_adapter_get_module_by_index(u16 adapter_index, u16 module_index,
-	u16 *pw_num_outputs, u16 *pw_num_inputs, u16 *pw_version,
-	u32 *pserial_number, u16 *pw_module_type, u32 *ph_module);
-
-u16 hpi_adapter_set_mode(u16 adapter_index, u32 adapter_mode);
-
-u16 hpi_adapter_set_mode_ex(u16 adapter_index, u32 adapter_mode,
-	u16 query_or_set);
-
-u16 hpi_adapter_get_mode(u16 adapter_index, u32 *padapter_mode);
-
 u16 hpi_adapter_get_assert2(u16 adapter_index, u16 *p_assert_count,
 	char *psz_assert, u32 *p_param1, u32 *p_param2,
 	u32 *p_dsp_string_addr, u16 *p_processor_id);
@@ -1213,8 +1186,6 @@ u16 hpi_adapter_set_property(u16 adapter_index, u16 property, u16 paramter1,
 u16 hpi_adapter_get_property(u16 adapter_index, u16 property,
 	u16 *pw_paramter1, u16 *pw_paramter2);
 
-u16 hpi_adapter_enumerate_property(u16 adapter_index, u16 index,
-	u16 what_to_enumerate, u16 property_index, u32 *psetting);
 /*************/
 /* OutStream */
 /*************/
@@ -1232,38 +1203,12 @@ u16 hpi_outstream_write_buf(u32 h_outstream, const u8 *pb_write_buf,
 
 u16 hpi_outstream_start(u32 h_outstream);
 
-u16 hpi_outstream_wait_start(u32 h_outstream);
-
 u16 hpi_outstream_stop(u32 h_outstream);
 
-u16 hpi_outstream_sinegen(u32 h_outstream);
-
 u16 hpi_outstream_reset(u32 h_outstream);
 
 u16 hpi_outstream_query_format(u32 h_outstream, struct hpi_format *p_format);
 
-u16 hpi_outstream_set_format(u32 h_outstream, struct hpi_format *p_format);
-
-u16 hpi_outstream_set_punch_in_out(u32 h_outstream, u32 punch_in_sample,
-	u32 punch_out_sample);
-
-u16 hpi_outstream_set_velocity(u32 h_outstream, short velocity);
-
-u16 hpi_outstream_ancillary_reset(u32 h_outstream, u16 mode);
-
-u16 hpi_outstream_ancillary_get_info(u32 h_outstream, u32 *pframes_available);
-
-u16 hpi_outstream_ancillary_read(u32 h_outstream,
-	struct hpi_anc_frame *p_anc_frame_buffer,
-	u32 anc_frame_buffer_size_in_bytes,
-	u32 number_of_ancillary_frames_to_read);
-
-u16 hpi_outstream_set_time_scale(u32 h_outstream, u32 time_scaleX10000);
-
-u16 hpi_outstream_host_buffer_allocate(u32 h_outstream, u32 size_in_bytes);
-
-u16 hpi_outstream_host_buffer_free(u32 h_outstream);
-
 u16 hpi_outstream_group_add(u32 h_outstream, u32 h_stream);
 
 u16 hpi_outstream_group_get_map(u32 h_outstream, u32 *poutstream_map,
@@ -1299,18 +1244,6 @@ u16 hpi_instream_get_info_ex(u32 h_instream, u16 *pw_state, u32 *pbuffer_size,
 	u32 *pdata_recorded, u32 *psamples_recorded,
 	u32 *pauxiliary_data_recorded);
 
-u16 hpi_instream_ancillary_reset(u32 h_instream, u16 bytes_per_frame,
-	u16 mode, u16 alignment, u16 idle_bit);
-
-u16 hpi_instream_ancillary_get_info(u32 h_instream, u32 *pframe_space);
-
-u16 hpi_instream_ancillary_write(u32 h_instream,
-	const struct hpi_anc_frame *p_anc_frame_buffer,
-	u32 anc_frame_buffer_size_in_bytes,
-	u32 number_of_ancillary_frames_to_write);
-
-u16 hpi_instream_host_buffer_allocate(u32 h_instream, u32 size_in_bytes);
-
 u16 hpi_instream_host_buffer_free(u32 h_instream);
 
 u16 hpi_instream_group_add(u32 h_instream, u32 h_stream);
@@ -1325,8 +1258,6 @@ u16 hpi_instream_group_reset(u32 h_instream);
 /*********/
 u16 hpi_mixer_open(u16 adapter_index, u32 *ph_mixer);
 
-u16 hpi_mixer_close(u32 h_mixer);
-
 u16 hpi_mixer_get_control(u32 h_mixer, u16 src_node_type,
 	u16 src_node_type_index, u16 dst_node_type, u16 dst_node_type_index,
 	u16 control_type, u32 *ph_control);
@@ -1335,8 +1266,6 @@ u16 hpi_mixer_get_control_by_index(u32 h_mixer, u16 control_index,
 	u16 *pw_src_node_type, u16 *pw_src_node_index, u16 *pw_dst_node_type,
 	u16 *pw_dst_node_index, u16 *pw_control_type, u32 *ph_control);
 
-u16 hpi_mixer_store(u32 h_mixer, enum HPI_MIXER_STORE_COMMAND command,
-	u16 index);
 /************/
 /* Controls */
 /************/
@@ -1358,18 +1287,6 @@ u16 hpi_volume_get_mute(u32 h_control, u32 *mute);
 u16 hpi_volume_query_range(u32 h_control, short *min_gain_01dB,
 	short *max_gain_01dB, short *step_gain_01dB);
 
-u16 hpi_volume_query_channels(const u32 h_control, u32 *p_channels);
-
-u16 hpi_volume_auto_fade(u32 h_control,
-	short an_stop_gain0_01dB[HPI_MAX_CHANNELS], u32 duration_ms);
-
-u16 hpi_volume_auto_fade_profile(u32 h_control,
-	short an_stop_gain0_01dB[HPI_MAX_CHANNELS], u32 duration_ms,
-	u16 profile);
-
-u16 hpi_volume_query_auto_fade_profile(const u32 h_control, const u32 i,
-	u16 *profile);
-
 /*****************/
 /* Level control */
 /*****************/
@@ -1392,17 +1309,6 @@ u16 hpi_meter_get_peak(u32 h_control,
 	short an_peak0_01dB_out[HPI_MAX_CHANNELS]
 	);
 
-u16 hpi_meter_get_rms(u32 h_control, short an_peak0_01dB_out[HPI_MAX_CHANNELS]
-	);
-
-u16 hpi_meter_set_peak_ballistics(u32 h_control, u16 attack, u16 decay);
-
-u16 hpi_meter_set_rms_ballistics(u32 h_control, u16 attack, u16 decay);
-
-u16 hpi_meter_get_peak_ballistics(u32 h_control, u16 *attack, u16 *decay);
-
-u16 hpi_meter_get_rms_ballistics(u32 h_control, u16 *attack, u16 *decay);
-
 /************************/
 /* ChannelMode control */
 /************************/
@@ -1429,106 +1335,31 @@ u16 hpi_tuner_set_frequency(u32 h_control, u32 freq_ink_hz);
 
 u16 hpi_tuner_get_frequency(u32 h_control, u32 *pw_freq_ink_hz);
 
-u16 hpi_tuner_get_rf_level(u32 h_control, short *pw_level);
-
-u16 hpi_tuner_get_raw_rf_level(u32 h_control, short *pw_level);
-
 u16 hpi_tuner_query_gain(const u32 h_tuner, const u32 index, u16 *pw_gain);
 
 u16 hpi_tuner_set_gain(u32 h_control, short gain);
 
 u16 hpi_tuner_get_gain(u32 h_control, short *pn_gain);
 
-u16 hpi_tuner_get_status(u32 h_control, u16 *pw_status_mask, u16 *pw_status);
-
-u16 hpi_tuner_set_mode(u32 h_control, u32 mode, u32 value);
-
-u16 hpi_tuner_get_mode(u32 h_control, u32 mode, u32 *pn_value);
-
-u16 hpi_tuner_get_rds(u32 h_control, char *p_rds_data);
-
-u16 hpi_tuner_query_deemphasis(const u32 h_tuner, const u32 index,
-	const u16 band, u32 *pdeemphasis);
-
-u16 hpi_tuner_set_deemphasis(u32 h_control, u32 deemphasis);
-u16 hpi_tuner_get_deemphasis(u32 h_control, u32 *pdeemphasis);
-
-u16 hpi_tuner_query_program(const u32 h_tuner, u32 *pbitmap_program);
-
-u16 hpi_tuner_set_program(u32 h_control, u32 program);
-
-u16 hpi_tuner_get_program(u32 h_control, u32 *pprogram);
-
-u16 hpi_tuner_get_hd_radio_dsp_version(u32 h_control, char *psz_dsp_version,
-	const u32 string_size);
-
-u16 hpi_tuner_get_hd_radio_sdk_version(u32 h_control, char *psz_sdk_version,
-	const u32 string_size);
-
-u16 hpi_tuner_get_hd_radio_signal_quality(u32 h_control, u32 *pquality);
-
-u16 hpi_tuner_get_hd_radio_signal_blend(u32 h_control, u32 *pblend);
-
-u16 hpi_tuner_set_hd_radio_signal_blend(u32 h_control, const u32 blend);
-
 /***************/
 /* PAD control */
 /***************/
 
-u16 hpi_pad_get_channel_name(u32 h_control, char *psz_string,
-	const u32 string_length);
-
-u16 hpi_pad_get_artist(u32 h_control, char *psz_string,
-	const u32 string_length);
-
-u16 hpi_pad_get_title(u32 h_control, char *psz_string,
-	const u32 string_length);
-
-u16 hpi_pad_get_comment(u32 h_control, char *psz_string,
-	const u32 string_length);
-
-u16 hpi_pad_get_program_type(u32 h_control, u32 *ppTY);
-
-u16 hpi_pad_get_rdsPI(u32 h_control, u32 *ppI);
-
 u16 hpi_pad_get_program_type_string(u32 h_control, const u32 data_type,
 	const u32 pTY, char *psz_string, const u32 string_length);
 
 /****************************/
 /* AES/EBU Receiver control */
 /****************************/
-u16 hpi_aesebu_receiver_query_format(const u32 h_aes_rx, const u32 index,
-	u16 *pw_format);
-
 u16 hpi_aesebu_receiver_set_format(u32 h_control, u16 source);
 
 u16 hpi_aesebu_receiver_get_format(u32 h_control, u16 *pw_source);
 
-u16 hpi_aesebu_receiver_get_sample_rate(u32 h_control, u32 *psample_rate);
-
-u16 hpi_aesebu_receiver_get_user_data(u32 h_control, u16 index, u16 *pw_data);
-
-u16 hpi_aesebu_receiver_get_channel_status(u32 h_control, u16 index,
-	u16 *pw_data);
-
 u16 hpi_aesebu_receiver_get_error_status(u32 h_control, u16 *pw_error_data);
 
 /*******************************/
 /* AES/EBU Transmitter control */
 /*******************************/
-u16 hpi_aesebu_transmitter_set_sample_rate(u32 h_control, u32 sample_rate);
-
-u16 hpi_aesebu_transmitter_set_user_data(u32 h_control, u16 index, u16 data);
-
-u16 hpi_aesebu_transmitter_set_channel_status(u32 h_control, u16 index,
-	u16 data);
-
-u16 hpi_aesebu_transmitter_get_channel_status(u32 h_control, u16 index,
-	u16 *pw_data);
-
-u16 hpi_aesebu_transmitter_query_format(const u32 h_aes_tx, const u32 index,
-	u16 *pw_format);
-
 u16 hpi_aesebu_transmitter_set_format(u32 h_control, u16 output_format);
 
 u16 hpi_aesebu_transmitter_get_format(u32 h_control, u16 *pw_output_format);
@@ -1545,22 +1376,6 @@ u16 hpi_multiplexer_get_source(u32 h_control, u16 *source_node_type,
 u16 hpi_multiplexer_query_source(u32 h_control, u16 index,
 	u16 *source_node_type, u16 *source_node_index);
 
-/***************/
-/* Vox control */
-/***************/
-u16 hpi_vox_set_threshold(u32 h_control, short an_gain0_01dB);
-
-u16 hpi_vox_get_threshold(u32 h_control, short *an_gain0_01dB);
-
-/*********************/
-/* Bitstream control */
-/*********************/
-u16 hpi_bitstream_set_clock_edge(u32 h_control, u16 edge_type);
-
-u16 hpi_bitstream_set_data_polarity(u32 h_control, u16 polarity);
-
-u16 hpi_bitstream_get_activity(u32 h_control, u16 *pw_clk_activity,
-	u16 *pw_data_activity);
 
 /***********************/
 /* SampleClock control */
@@ -1589,72 +1404,6 @@ u16 hpi_sample_clock_set_local_rate(u32 h_control, u32 sample_rate);
 
 u16 hpi_sample_clock_get_local_rate(u32 h_control, u32 *psample_rate);
 
-u16 hpi_sample_clock_set_auto(u32 h_control, u32 enable);
-
-u16 hpi_sample_clock_get_auto(u32 h_control, u32 *penable);
-
-u16 hpi_sample_clock_set_local_rate_lock(u32 h_control, u32 lock);
-
-u16 hpi_sample_clock_get_local_rate_lock(u32 h_control, u32 *plock);
-
-/***********************/
-/* Microphone control */
-/***********************/
-u16 hpi_microphone_set_phantom_power(u32 h_control, u16 on_off);
-
-u16 hpi_microphone_get_phantom_power(u32 h_control, u16 *pw_on_off);
-
-/********************************/
-/* Parametric Equalizer control */
-/********************************/
-u16 hpi_parametric_eq_get_info(u32 h_control, u16 *pw_number_of_bands,
-	u16 *pw_enabled);
-
-u16 hpi_parametric_eq_set_state(u32 h_control, u16 on_off);
-
-u16 hpi_parametric_eq_set_band(u32 h_control, u16 index, u16 type,
-	u32 frequency_hz, short q100, short gain0_01dB);
-
-u16 hpi_parametric_eq_get_band(u32 h_control, u16 index, u16 *pn_type,
-	u32 *pfrequency_hz, short *pnQ100, short *pn_gain0_01dB);
-
-u16 hpi_parametric_eq_get_coeffs(u32 h_control, u16 index, short coeffs[5]
-	);
-
-/*******************************/
-/* Compressor Expander control */
-/*******************************/
-
-u16 hpi_compander_set_enable(u32 h_control, u32 on);
-
-u16 hpi_compander_get_enable(u32 h_control, u32 *pon);
-
-u16 hpi_compander_set_makeup_gain(u32 h_control, short makeup_gain0_01dB);
-
-u16 hpi_compander_get_makeup_gain(u32 h_control, short *pn_makeup_gain0_01dB);
-
-u16 hpi_compander_set_attack_time_constant(u32 h_control, u32 index,
-	u32 attack);
-
-u16 hpi_compander_get_attack_time_constant(u32 h_control, u32 index,
-	u32 *pw_attack);
-
-u16 hpi_compander_set_decay_time_constant(u32 h_control, u32 index,
-	u32 decay);
-
-u16 hpi_compander_get_decay_time_constant(u32 h_control, u32 index,
-	u32 *pw_decay);
-
-u16 hpi_compander_set_threshold(u32 h_control, u32 index,
-	short threshold0_01dB);
-
-u16 hpi_compander_get_threshold(u32 h_control, u32 index,
-	short *pn_threshold0_01dB);
-
-u16 hpi_compander_set_ratio(u32 h_control, u32 index, u32 ratio100);
-
-u16 hpi_compander_get_ratio(u32 h_control, u32 index, u32 *pw_ratio100);
-
 /********************/
 /* Cobranet control */
 /********************/
@@ -1664,59 +1413,6 @@ u16 hpi_cobranet_hmi_write(u32 h_control, u32 hmi_address, u32 byte_count,
 u16 hpi_cobranet_hmi_read(u32 h_control, u32 hmi_address, u32 max_byte_count,
 	u32 *pbyte_count, u8 *pb_data);
 
-u16 hpi_cobranet_hmi_get_status(u32 h_control, u32 *pstatus,
-	u32 *preadable_size, u32 *pwriteable_size);
-
-u16 hpi_cobranet_get_ip_address(u32 h_control, u32 *pdw_ip_address);
-
-u16 hpi_cobranet_set_ip_address(u32 h_control, u32 dw_ip_address);
-
-u16 hpi_cobranet_get_static_ip_address(u32 h_control, u32 *pdw_ip_address);
-
-u16 hpi_cobranet_set_static_ip_address(u32 h_control, u32 dw_ip_address);
-
-u16 hpi_cobranet_get_macaddress(u32 h_control, u32 *p_mac_msbs,
-	u32 *p_mac_lsbs);
-
-/*************************/
-/* Tone Detector control */
-/*************************/
-u16 hpi_tone_detector_get_state(u32 hC, u32 *state);
-
-u16 hpi_tone_detector_set_enable(u32 hC, u32 enable);
-
-u16 hpi_tone_detector_get_enable(u32 hC, u32 *enable);
-
-u16 hpi_tone_detector_set_event_enable(u32 hC, u32 event_enable);
-
-u16 hpi_tone_detector_get_event_enable(u32 hC, u32 *event_enable);
-
-u16 hpi_tone_detector_set_threshold(u32 hC, int threshold);
-
-u16 hpi_tone_detector_get_threshold(u32 hC, int *threshold);
-
-u16 hpi_tone_detector_get_frequency(u32 hC, u32 index, u32 *frequency);
-
-/****************************/
-/* Silence Detector control */
-/****************************/
-u16 hpi_silence_detector_get_state(u32 hC, u32 *state);
-
-u16 hpi_silence_detector_set_enable(u32 hC, u32 enable);
-
-u16 hpi_silence_detector_get_enable(u32 hC, u32 *enable);
-
-u16 hpi_silence_detector_set_event_enable(u32 hC, u32 event_enable);
-
-u16 hpi_silence_detector_get_event_enable(u32 hC, u32 *event_enable);
-
-u16 hpi_silence_detector_set_delay(u32 hC, u32 delay);
-
-u16 hpi_silence_detector_get_delay(u32 hC, u32 *delay);
-
-u16 hpi_silence_detector_set_threshold(u32 hC, int threshold);
-
-u16 hpi_silence_detector_get_threshold(u32 hC, int *threshold);
 /*********************/
 /* Utility functions */
 /*********************/
diff --git a/sound/pci/asihpi/hpi_internal.h b/sound/pci/asihpi/hpi_internal.h
index bc86cb7..7c11994 100644
--- a/sound/pci/asihpi/hpi_internal.h
+++ b/sound/pci/asihpi/hpi_internal.h
@@ -1404,12 +1404,6 @@ void hpi_send_recv(struct hpi_message *phm, struct hpi_response *phr);
 u16 hpi_subsys_create_adapter(const struct hpi_resource *p_resource,
 	u16 *pw_adapter_index);
 
-u16 hpi_outstream_host_buffer_get_info(u32 h_outstream, u8 **pp_buffer,
-	struct hpi_hostbuffer_status **pp_status);
-
-u16 hpi_instream_host_buffer_get_info(u32 h_instream, u8 **pp_buffer,
-	struct hpi_hostbuffer_status **pp_status);
-
 u16 hpi_adapter_restart(u16 adapter_index);
 
 /*
@@ -1421,7 +1415,6 @@ compatibility.
 
 void hpi_format_to_msg(struct hpi_msg_format *pMF,
 	const struct hpi_format *pF);
-void hpi_stream_response_to_legacy(struct hpi_stream_res *pSR);
 
 /*////////////////////////////////////////////////////////////////////////// */
 /* declarations for individual HPI entry points */
diff --git a/sound/pci/asihpi/hpifunc.c b/sound/pci/asihpi/hpifunc.c
index 510e56c..5d4d2f6 100644
--- a/sound/pci/asihpi/hpifunc.c
+++ b/sound/pci/asihpi/hpifunc.c
@@ -80,13 +80,6 @@ static void hpi_msg_to_format(struct hpi_format *pF,
 	pF->unused = 0;
 }
 
-void hpi_stream_response_to_legacy(struct hpi_stream_res *pSR)
-{
-	pSR->u.legacy_stream_info.auxiliary_data_available =
-		pSR->u.stream_info.auxiliary_data_available;
-	pSR->u.legacy_stream_info.state = pSR->u.stream_info.state;
-}
-
 static inline void hpi_send_recvV1(struct hpi_message_header *m,
 	struct hpi_response_header *r)
 {
@@ -105,93 +98,6 @@ u16 hpi_subsys_get_version_ex(u32 *pversion_ex)
 	return hr.error;
 }
 
-u16 hpi_subsys_get_num_adapters(int *pn_num_adapters)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_SUBSYSTEM,
-		HPI_SUBSYS_GET_NUM_ADAPTERS);
-	hpi_send_recv(&hm, &hr);
-	*pn_num_adapters = (int)hr.u.s.num_adapters;
-	return hr.error;
-}
-
-u16 hpi_subsys_get_adapter(int iterator, u32 *padapter_index,
-	u16 *pw_adapter_type)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_SUBSYSTEM,
-		HPI_SUBSYS_GET_ADAPTER);
-	hm.obj_index = (u16)iterator;
-	hpi_send_recv(&hm, &hr);
-	*padapter_index = (int)hr.u.s.adapter_index;
-	*pw_adapter_type = hr.u.s.adapter_type;
-
-	return hr.error;
-}
-
-u16 hpi_adapter_open(u16 adapter_index)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ADAPTER,
-		HPI_ADAPTER_OPEN);
-	hm.adapter_index = adapter_index;
-
-	hpi_send_recv(&hm, &hr);
-
-	return hr.error;
-
-}
-
-u16 hpi_adapter_close(u16 adapter_index)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ADAPTER,
-		HPI_ADAPTER_CLOSE);
-	hm.adapter_index = adapter_index;
-
-	hpi_send_recv(&hm, &hr);
-
-	return hr.error;
-}
-
-u16 hpi_adapter_set_mode(u16 adapter_index, u32 adapter_mode)
-{
-	return hpi_adapter_set_mode_ex(adapter_index, adapter_mode,
-		HPI_ADAPTER_MODE_SET);
-}
-
-u16 hpi_adapter_set_mode_ex(u16 adapter_index, u32 adapter_mode,
-	u16 query_or_set)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ADAPTER,
-		HPI_ADAPTER_SET_MODE);
-	hm.adapter_index = adapter_index;
-	hm.u.ax.mode.adapter_mode = adapter_mode;
-	hm.u.ax.mode.query_or_set = query_or_set;
-	hpi_send_recv(&hm, &hr);
-	return hr.error;
-}
-
-u16 hpi_adapter_get_mode(u16 adapter_index, u32 *padapter_mode)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ADAPTER,
-		HPI_ADAPTER_GET_MODE);
-	hm.adapter_index = adapter_index;
-	hpi_send_recv(&hm, &hr);
-	if (padapter_mode)
-		*padapter_mode = hr.u.ax.mode.adapter_mode;
-	return hr.error;
-}
-
 u16 hpi_adapter_get_info(u16 adapter_index, u16 *pw_num_outstreams,
 	u16 *pw_num_instreams, u16 *pw_version, u32 *pserial_number,
 	u16 *pw_adapter_type)
@@ -212,30 +118,6 @@ u16 hpi_adapter_get_info(u16 adapter_index, u16 *pw_num_outstreams,
 	return hr.error;
 }
 
-u16 hpi_adapter_get_module_by_index(u16 adapter_index, u16 module_index,
-	u16 *pw_num_outputs, u16 *pw_num_inputs, u16 *pw_version,
-	u32 *pserial_number, u16 *pw_module_type, u32 *ph_module)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ADAPTER,
-		HPI_ADAPTER_MODULE_INFO);
-	hm.adapter_index = adapter_index;
-	hm.u.ax.module_info.index = module_index;
-
-	hpi_send_recv(&hm, &hr);
-
-	*pw_module_type = hr.u.ax.info.adapter_type;
-	*pw_num_outputs = hr.u.ax.info.num_outstreams;
-	*pw_num_inputs = hr.u.ax.info.num_instreams;
-	*pw_version = hr.u.ax.info.version;
-	*pserial_number = hr.u.ax.info.serial_number;
-	*ph_module = 0;
-
-	return hr.error;
-}
-
 u16 hpi_adapter_set_property(u16 adapter_index, u16 property, u16 parameter1,
 	u16 parameter2)
 {
@@ -274,12 +156,6 @@ u16 hpi_adapter_get_property(u16 adapter_index, u16 property,
 	return hr.error;
 }
 
-u16 hpi_adapter_enumerate_property(u16 adapter_index, u16 index,
-	u16 what_to_enumerate, u16 property_index, u32 *psetting)
-{
-	return 0;
-}
-
 u16 hpi_format_create(struct hpi_format *p_format, u16 channels, u16 format,
 	u32 sample_rate, u32 bit_rate, u32 attributes)
 {
@@ -375,52 +251,6 @@ u16 hpi_format_create(struct hpi_format *p_format, u16 channels, u16 format,
 	return err;
 }
 
-u16 hpi_stream_estimate_buffer_size(struct hpi_format *p_format,
-	u32 host_polling_rate_in_milli_seconds, u32 *recommended_buffer_size)
-{
-
-	u32 bytes_per_second;
-	u32 size;
-	u16 channels;
-	struct hpi_format *pF = p_format;
-
-	channels = pF->channels;
-
-	switch (pF->format) {
-	case HPI_FORMAT_PCM16_BIGENDIAN:
-	case HPI_FORMAT_PCM16_SIGNED:
-		bytes_per_second = pF->sample_rate * 2L * channels;
-		break;
-	case HPI_FORMAT_PCM24_SIGNED:
-		bytes_per_second = pF->sample_rate * 3L * channels;
-		break;
-	case HPI_FORMAT_PCM32_SIGNED:
-	case HPI_FORMAT_PCM32_FLOAT:
-		bytes_per_second = pF->sample_rate * 4L * channels;
-		break;
-	case HPI_FORMAT_PCM8_UNSIGNED:
-		bytes_per_second = pF->sample_rate * 1L * channels;
-		break;
-	case HPI_FORMAT_MPEG_L1:
-	case HPI_FORMAT_MPEG_L2:
-	case HPI_FORMAT_MPEG_L3:
-		bytes_per_second = pF->bit_rate / 8L;
-		break;
-	case HPI_FORMAT_DOLBY_AC2:
-
-		bytes_per_second = 256000L / 8L;
-		break;
-	default:
-		return HPI_ERROR_INVALID_FORMAT;
-	}
-	size = (bytes_per_second * host_polling_rate_in_milli_seconds * 2) /
-		1000L;
-
-	*recommended_buffer_size =
-		roundup_pow_of_two(((size + 4095L) & ~4095L));
-	return 0;
-}
-
 u16 hpi_outstream_open(u16 adapter_index, u16 outstream_index,
 	u32 *ph_outstream)
 {
@@ -527,12 +357,12 @@ u16 hpi_outstream_start(u32 h_outstream)
 	return hr.error;
 }
 
-u16 hpi_outstream_wait_start(u32 h_outstream)
+u16 hpi_outstream_stop(u32 h_outstream)
 {
 	struct hpi_message hm;
 	struct hpi_response hr;
 	hpi_init_message_response(&hm, &hr, HPI_OBJ_OSTREAM,
-		HPI_OSTREAM_WAIT_START);
+		HPI_OSTREAM_STOP);
 	if (hpi_handle_indexes(h_outstream, &hm.adapter_index, &hm.obj_index))
 		return HPI_ERROR_INVALID_HANDLE;
 
@@ -541,12 +371,12 @@ u16 hpi_outstream_wait_start(u32 h_outstream)
 	return hr.error;
 }
 
-u16 hpi_outstream_stop(u32 h_outstream)
+u16 hpi_outstream_reset(u32 h_outstream)
 {
 	struct hpi_message hm;
 	struct hpi_response hr;
 	hpi_init_message_response(&hm, &hr, HPI_OBJ_OSTREAM,
-		HPI_OSTREAM_STOP);
+		HPI_OSTREAM_RESET);
 	if (hpi_handle_indexes(h_outstream, &hm.adapter_index, &hm.obj_index))
 		return HPI_ERROR_INVALID_HANDLE;
 
@@ -555,432 +385,231 @@ u16 hpi_outstream_stop(u32 h_outstream)
 	return hr.error;
 }
 
-u16 hpi_outstream_sinegen(u32 h_outstream)
+u16 hpi_outstream_query_format(u32 h_outstream, struct hpi_format *p_format)
 {
 	struct hpi_message hm;
 	struct hpi_response hr;
+
 	hpi_init_message_response(&hm, &hr, HPI_OBJ_OSTREAM,
-		HPI_OSTREAM_SINEGEN);
+		HPI_OSTREAM_QUERY_FORMAT);
 	if (hpi_handle_indexes(h_outstream, &hm.adapter_index, &hm.obj_index))
 		return HPI_ERROR_INVALID_HANDLE;
 
+	hpi_format_to_msg(&hm.u.d.u.data.format, p_format);
+
 	hpi_send_recv(&hm, &hr);
 
 	return hr.error;
 }
 
-u16 hpi_outstream_reset(u32 h_outstream)
+u16 hpi_outstream_group_add(u32 h_outstream, u32 h_stream)
 {
 	struct hpi_message hm;
 	struct hpi_response hr;
+	u16 adapter;
+	char c_obj_type;
+
 	hpi_init_message_response(&hm, &hr, HPI_OBJ_OSTREAM,
-		HPI_OSTREAM_RESET);
+		HPI_OSTREAM_GROUP_ADD);
+
 	if (hpi_handle_indexes(h_outstream, &hm.adapter_index, &hm.obj_index))
 		return HPI_ERROR_INVALID_HANDLE;
 
-	hpi_send_recv(&hm, &hr);
+	if (hpi_handle_indexes(h_stream, &adapter,
+			&hm.u.d.u.stream.stream_index))
+		return HPI_ERROR_INVALID_HANDLE;
+
+	c_obj_type = hpi_handle_object(h_stream);
+	switch (c_obj_type) {
+	case HPI_OBJ_OSTREAM:
+	case HPI_OBJ_ISTREAM:
+		hm.u.d.u.stream.object_type = c_obj_type;
+		break;
+	default:
+		return HPI_ERROR_INVALID_OBJ;
+	}
+	if (adapter != hm.adapter_index)
+		return HPI_ERROR_NO_INTERADAPTER_GROUPS;
 
+	hpi_send_recv(&hm, &hr);
 	return hr.error;
 }
 
-u16 hpi_outstream_query_format(u32 h_outstream, struct hpi_format *p_format)
+u16 hpi_outstream_group_get_map(u32 h_outstream, u32 *poutstream_map,
+	u32 *pinstream_map)
 {
 	struct hpi_message hm;
 	struct hpi_response hr;
 
 	hpi_init_message_response(&hm, &hr, HPI_OBJ_OSTREAM,
-		HPI_OSTREAM_QUERY_FORMAT);
+		HPI_OSTREAM_GROUP_GETMAP);
 	if (hpi_handle_indexes(h_outstream, &hm.adapter_index, &hm.obj_index))
 		return HPI_ERROR_INVALID_HANDLE;
-
-	hpi_format_to_msg(&hm.u.d.u.data.format, p_format);
-
 	hpi_send_recv(&hm, &hr);
 
+	if (poutstream_map)
+		*poutstream_map = hr.u.d.u.group_info.outstream_group_map;
+	if (pinstream_map)
+		*pinstream_map = hr.u.d.u.group_info.instream_group_map;
+
 	return hr.error;
 }
 
-u16 hpi_outstream_set_format(u32 h_outstream, struct hpi_format *p_format)
+u16 hpi_outstream_group_reset(u32 h_outstream)
 {
 	struct hpi_message hm;
 	struct hpi_response hr;
 
 	hpi_init_message_response(&hm, &hr, HPI_OBJ_OSTREAM,
-		HPI_OSTREAM_SET_FORMAT);
+		HPI_OSTREAM_GROUP_RESET);
 	if (hpi_handle_indexes(h_outstream, &hm.adapter_index, &hm.obj_index))
 		return HPI_ERROR_INVALID_HANDLE;
-
-	hpi_format_to_msg(&hm.u.d.u.data.format, p_format);
-
 	hpi_send_recv(&hm, &hr);
-
 	return hr.error;
 }
 
-u16 hpi_outstream_set_velocity(u32 h_outstream, short velocity)
+u16 hpi_instream_open(u16 adapter_index, u16 instream_index, u32 *ph_instream)
 {
 	struct hpi_message hm;
 	struct hpi_response hr;
 
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_OSTREAM,
-		HPI_OSTREAM_SET_VELOCITY);
-	if (hpi_handle_indexes(h_outstream, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.d.u.velocity = velocity;
+	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
+		HPI_ISTREAM_OPEN);
+	hm.adapter_index = adapter_index;
+	hm.obj_index = instream_index;
 
 	hpi_send_recv(&hm, &hr);
 
+	if (hr.error == 0)
+		*ph_instream =
+			hpi_indexes_to_handle(HPI_OBJ_ISTREAM, adapter_index,
+			instream_index);
+	else
+		*ph_instream = 0;
+
 	return hr.error;
 }
 
-u16 hpi_outstream_set_punch_in_out(u32 h_outstream, u32 punch_in_sample,
-	u32 punch_out_sample)
+u16 hpi_instream_close(u32 h_instream)
 {
 	struct hpi_message hm;
 	struct hpi_response hr;
 
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_OSTREAM,
-		HPI_OSTREAM_SET_PUNCHINOUT);
-	if (hpi_handle_indexes(h_outstream, &hm.adapter_index, &hm.obj_index))
+	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
+		HPI_ISTREAM_HOSTBUFFER_FREE);
+	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
 		return HPI_ERROR_INVALID_HANDLE;
+	hpi_send_recv(&hm, &hr);
 
-	hm.u.d.u.pio.punch_in_sample = punch_in_sample;
-	hm.u.d.u.pio.punch_out_sample = punch_out_sample;
+	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
+		HPI_ISTREAM_GROUP_RESET);
+	hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index);
+	hpi_send_recv(&hm, &hr);
 
+	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
+		HPI_ISTREAM_CLOSE);
+	hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index);
 	hpi_send_recv(&hm, &hr);
 
 	return hr.error;
 }
 
-u16 hpi_outstream_ancillary_reset(u32 h_outstream, u16 mode)
+u16 hpi_instream_query_format(u32 h_instream,
+	const struct hpi_format *p_format)
 {
 	struct hpi_message hm;
 	struct hpi_response hr;
 
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_OSTREAM,
-		HPI_OSTREAM_ANC_RESET);
-	if (hpi_handle_indexes(h_outstream, &hm.adapter_index, &hm.obj_index))
+	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
+		HPI_ISTREAM_QUERY_FORMAT);
+	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
 		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.d.u.data.format.channels = mode;
+	hpi_format_to_msg(&hm.u.d.u.data.format, p_format);
+
 	hpi_send_recv(&hm, &hr);
+
 	return hr.error;
 }
 
-u16 hpi_outstream_ancillary_get_info(u32 h_outstream, u32 *pframes_available)
+u16 hpi_instream_set_format(u32 h_instream, const struct hpi_format *p_format)
 {
 	struct hpi_message hm;
 	struct hpi_response hr;
 
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_OSTREAM,
-		HPI_OSTREAM_ANC_GET_INFO);
-	if (hpi_handle_indexes(h_outstream, &hm.adapter_index, &hm.obj_index))
+	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
+		HPI_ISTREAM_SET_FORMAT);
+	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
 		return HPI_ERROR_INVALID_HANDLE;
+	hpi_format_to_msg(&hm.u.d.u.data.format, p_format);
+
 	hpi_send_recv(&hm, &hr);
-	if (hr.error == 0) {
-		if (pframes_available)
-			*pframes_available =
-				hr.u.d.u.stream_info.data_available /
-				sizeof(struct hpi_anc_frame);
-	}
+
 	return hr.error;
 }
 
-u16 hpi_outstream_ancillary_read(u32 h_outstream,
-	struct hpi_anc_frame *p_anc_frame_buffer,
-	u32 anc_frame_buffer_size_in_bytes,
-	u32 number_of_ancillary_frames_to_read)
+u16 hpi_instream_read_buf(u32 h_instream, u8 *pb_data, u32 bytes_to_read)
 {
 	struct hpi_message hm;
 	struct hpi_response hr;
 
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_OSTREAM,
-		HPI_OSTREAM_ANC_READ);
-	if (hpi_handle_indexes(h_outstream, &hm.adapter_index, &hm.obj_index))
+	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
+		HPI_ISTREAM_READ);
+	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
 		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.d.u.data.pb_data = (u8 *)p_anc_frame_buffer;
-	hm.u.d.u.data.data_size =
-		number_of_ancillary_frames_to_read *
-		sizeof(struct hpi_anc_frame);
-	if (hm.u.d.u.data.data_size <= anc_frame_buffer_size_in_bytes)
-		hpi_send_recv(&hm, &hr);
-	else
-		hr.error = HPI_ERROR_INVALID_DATASIZE;
+	hm.u.d.u.data.data_size = bytes_to_read;
+	hm.u.d.u.data.pb_data = pb_data;
+
+	hpi_send_recv(&hm, &hr);
+
 	return hr.error;
 }
 
-u16 hpi_outstream_set_time_scale(u32 h_outstream, u32 time_scale)
+u16 hpi_instream_start(u32 h_instream)
 {
 	struct hpi_message hm;
 	struct hpi_response hr;
 
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_OSTREAM,
-		HPI_OSTREAM_SET_TIMESCALE);
-	if (hpi_handle_indexes(h_outstream, &hm.adapter_index, &hm.obj_index))
+	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
+		HPI_ISTREAM_START);
+	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
 		return HPI_ERROR_INVALID_HANDLE;
 
-	hm.u.d.u.time_scale = time_scale;
-
 	hpi_send_recv(&hm, &hr);
 
 	return hr.error;
 }
 
-u16 hpi_outstream_host_buffer_allocate(u32 h_outstream, u32 size_in_bytes)
+u16 hpi_instream_wait_start(u32 h_instream)
 {
 	struct hpi_message hm;
 	struct hpi_response hr;
 
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_OSTREAM,
-		HPI_OSTREAM_HOSTBUFFER_ALLOC);
-	if (hpi_handle_indexes(h_outstream, &hm.adapter_index, &hm.obj_index))
+	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
+		HPI_ISTREAM_WAIT_START);
+	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
 		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.d.u.data.data_size = size_in_bytes;
+
 	hpi_send_recv(&hm, &hr);
+
 	return hr.error;
 }
 
-u16 hpi_outstream_host_buffer_get_info(u32 h_outstream, u8 **pp_buffer,
-	struct hpi_hostbuffer_status **pp_status)
+u16 hpi_instream_stop(u32 h_instream)
 {
 	struct hpi_message hm;
 	struct hpi_response hr;
 
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_OSTREAM,
-		HPI_OSTREAM_HOSTBUFFER_GET_INFO);
-	if (hpi_handle_indexes(h_outstream, &hm.adapter_index, &hm.obj_index))
+	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
+		HPI_ISTREAM_STOP);
+	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
 		return HPI_ERROR_INVALID_HANDLE;
+
 	hpi_send_recv(&hm, &hr);
 
-	if (hr.error == 0) {
-		if (pp_buffer)
-			*pp_buffer = hr.u.d.u.hostbuffer_info.p_buffer;
-		if (pp_status)
-			*pp_status = hr.u.d.u.hostbuffer_info.p_status;
-	}
 	return hr.error;
 }
 
-u16 hpi_outstream_host_buffer_free(u32 h_outstream)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_OSTREAM,
-		HPI_OSTREAM_HOSTBUFFER_FREE);
-	if (hpi_handle_indexes(h_outstream, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hpi_send_recv(&hm, &hr);
-	return hr.error;
-}
-
-u16 hpi_outstream_group_add(u32 h_outstream, u32 h_stream)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-	u16 adapter;
-	char c_obj_type;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_OSTREAM,
-		HPI_OSTREAM_GROUP_ADD);
-
-	if (hpi_handle_indexes(h_outstream, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-
-	if (hpi_handle_indexes(h_stream, &adapter,
-			&hm.u.d.u.stream.stream_index))
-		return HPI_ERROR_INVALID_HANDLE;
-
-	c_obj_type = hpi_handle_object(h_stream);
-	switch (c_obj_type) {
-	case HPI_OBJ_OSTREAM:
-	case HPI_OBJ_ISTREAM:
-		hm.u.d.u.stream.object_type = c_obj_type;
-		break;
-	default:
-		return HPI_ERROR_INVALID_OBJ;
-	}
-	if (adapter != hm.adapter_index)
-		return HPI_ERROR_NO_INTERADAPTER_GROUPS;
-
-	hpi_send_recv(&hm, &hr);
-	return hr.error;
-}
-
-u16 hpi_outstream_group_get_map(u32 h_outstream, u32 *poutstream_map,
-	u32 *pinstream_map)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_OSTREAM,
-		HPI_OSTREAM_GROUP_GETMAP);
-	if (hpi_handle_indexes(h_outstream, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hpi_send_recv(&hm, &hr);
-
-	if (poutstream_map)
-		*poutstream_map = hr.u.d.u.group_info.outstream_group_map;
-	if (pinstream_map)
-		*pinstream_map = hr.u.d.u.group_info.instream_group_map;
-
-	return hr.error;
-}
-
-u16 hpi_outstream_group_reset(u32 h_outstream)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_OSTREAM,
-		HPI_OSTREAM_GROUP_RESET);
-	if (hpi_handle_indexes(h_outstream, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hpi_send_recv(&hm, &hr);
-	return hr.error;
-}
-
-u16 hpi_instream_open(u16 adapter_index, u16 instream_index, u32 *ph_instream)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
-		HPI_ISTREAM_OPEN);
-	hm.adapter_index = adapter_index;
-	hm.obj_index = instream_index;
-
-	hpi_send_recv(&hm, &hr);
-
-	if (hr.error == 0)
-		*ph_instream =
-			hpi_indexes_to_handle(HPI_OBJ_ISTREAM, adapter_index,
-			instream_index);
-	else
-		*ph_instream = 0;
-
-	return hr.error;
-}
-
-u16 hpi_instream_close(u32 h_instream)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
-		HPI_ISTREAM_HOSTBUFFER_FREE);
-	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hpi_send_recv(&hm, &hr);
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
-		HPI_ISTREAM_GROUP_RESET);
-	hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index);
-	hpi_send_recv(&hm, &hr);
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
-		HPI_ISTREAM_CLOSE);
-	hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index);
-	hpi_send_recv(&hm, &hr);
-
-	return hr.error;
-}
-
-u16 hpi_instream_query_format(u32 h_instream,
-	const struct hpi_format *p_format)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
-		HPI_ISTREAM_QUERY_FORMAT);
-	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hpi_format_to_msg(&hm.u.d.u.data.format, p_format);
-
-	hpi_send_recv(&hm, &hr);
-
-	return hr.error;
-}
-
-u16 hpi_instream_set_format(u32 h_instream, const struct hpi_format *p_format)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
-		HPI_ISTREAM_SET_FORMAT);
-	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hpi_format_to_msg(&hm.u.d.u.data.format, p_format);
-
-	hpi_send_recv(&hm, &hr);
-
-	return hr.error;
-}
-
-u16 hpi_instream_read_buf(u32 h_instream, u8 *pb_data, u32 bytes_to_read)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
-		HPI_ISTREAM_READ);
-	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.d.u.data.data_size = bytes_to_read;
-	hm.u.d.u.data.pb_data = pb_data;
-
-	hpi_send_recv(&hm, &hr);
-
-	return hr.error;
-}
-
-u16 hpi_instream_start(u32 h_instream)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
-		HPI_ISTREAM_START);
-	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-
-	hpi_send_recv(&hm, &hr);
-
-	return hr.error;
-}
-
-u16 hpi_instream_wait_start(u32 h_instream)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
-		HPI_ISTREAM_WAIT_START);
-	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-
-	hpi_send_recv(&hm, &hr);
-
-	return hr.error;
-}
-
-u16 hpi_instream_stop(u32 h_instream)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
-		HPI_ISTREAM_STOP);
-	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-
-	hpi_send_recv(&hm, &hr);
-
-	return hr.error;
-}
-
-u16 hpi_instream_reset(u32 h_instream)
+u16 hpi_instream_reset(u32 h_instream)
 {
 	struct hpi_message hm;
 	struct hpi_response hr;
@@ -1022,98 +651,6 @@ u16 hpi_instream_get_info_ex(u32 h_instream, u16 *pw_state, u32 *pbuffer_size,
 	return hr.error;
 }
 
-u16 hpi_instream_ancillary_reset(u32 h_instream, u16 bytes_per_frame,
-	u16 mode, u16 alignment, u16 idle_bit)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
-		HPI_ISTREAM_ANC_RESET);
-	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.d.u.data.format.attributes = bytes_per_frame;
-	hm.u.d.u.data.format.format = (mode << 8) | (alignment & 0xff);
-	hm.u.d.u.data.format.channels = idle_bit;
-	hpi_send_recv(&hm, &hr);
-	return hr.error;
-}
-
-u16 hpi_instream_ancillary_get_info(u32 h_instream, u32 *pframe_space)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
-		HPI_ISTREAM_ANC_GET_INFO);
-	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hpi_send_recv(&hm, &hr);
-	if (pframe_space)
-		*pframe_space =
-			(hr.u.d.u.stream_info.buffer_size -
-			hr.u.d.u.stream_info.data_available) /
-			sizeof(struct hpi_anc_frame);
-	return hr.error;
-}
-
-u16 hpi_instream_ancillary_write(u32 h_instream,
-	const struct hpi_anc_frame *p_anc_frame_buffer,
-	u32 anc_frame_buffer_size_in_bytes,
-	u32 number_of_ancillary_frames_to_write)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
-		HPI_ISTREAM_ANC_WRITE);
-	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.d.u.data.pb_data = (u8 *)p_anc_frame_buffer;
-	hm.u.d.u.data.data_size =
-		number_of_ancillary_frames_to_write *
-		sizeof(struct hpi_anc_frame);
-	if (hm.u.d.u.data.data_size <= anc_frame_buffer_size_in_bytes)
-		hpi_send_recv(&hm, &hr);
-	else
-		hr.error = HPI_ERROR_INVALID_DATASIZE;
-	return hr.error;
-}
-
-u16 hpi_instream_host_buffer_allocate(u32 h_instream, u32 size_in_bytes)
-{
-
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
-		HPI_ISTREAM_HOSTBUFFER_ALLOC);
-	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.d.u.data.data_size = size_in_bytes;
-	hpi_send_recv(&hm, &hr);
-	return hr.error;
-}
-
-u16 hpi_instream_host_buffer_get_info(u32 h_instream, u8 **pp_buffer,
-	struct hpi_hostbuffer_status **pp_status)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
-		HPI_ISTREAM_HOSTBUFFER_GET_INFO);
-	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hpi_send_recv(&hm, &hr);
-
-	if (hr.error == 0) {
-		if (pp_buffer)
-			*pp_buffer = hr.u.d.u.hostbuffer_info.p_buffer;
-		if (pp_status)
-			*pp_status = hr.u.d.u.hostbuffer_info.p_status;
-	}
-	return hr.error;
-}
-
 u16 hpi_instream_host_buffer_free(u32 h_instream)
 {
 
@@ -1215,19 +752,6 @@ u16 hpi_mixer_open(u16 adapter_index, u32 *ph_mixer)
 	return hr.error;
 }
 
-u16 hpi_mixer_close(u32 h_mixer)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_MIXER, HPI_MIXER_CLOSE);
-	if (hpi_handle_indexes(h_mixer, &hm.adapter_index, NULL))
-		return HPI_ERROR_INVALID_HANDLE;
-
-	hpi_send_recv(&hm, &hr);
-	return hr.error;
-}
-
 u16 hpi_mixer_get_control(u32 h_mixer, u16 src_node_type,
 	u16 src_node_type_index, u16 dst_node_type, u16 dst_node_type_index,
 	u16 control_type, u32 *ph_control)
@@ -1289,20 +813,6 @@ u16 hpi_mixer_get_control_by_index(u32 h_mixer, u16 control_index,
 	return hr.error;
 }
 
-u16 hpi_mixer_store(u32 h_mixer, enum HPI_MIXER_STORE_COMMAND command,
-	u16 index)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_MIXER, HPI_MIXER_STORE);
-	if (hpi_handle_indexes(h_mixer, &hm.adapter_index, NULL))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.mx.store.command = command;
-	hm.u.mx.store.index = index;
-	hpi_send_recv(&hm, &hr);
-	return hr.error;
-}
-
 static
 u16 hpi_control_param_set(const u32 h_control, const u16 attrib,
 	const u32 param1, const u32 param2)
@@ -1465,17 +975,6 @@ static u16 hpi_control_get_string(const u32 h_control, const u16 attribute,
 	return err;
 }
 
-u16 hpi_aesebu_receiver_query_format(const u32 h_aes_rx, const u32 index,
-	u16 *pw_format)
-{
-	u32 qr;
-	u16 err;
-
-	err = hpi_control_query(h_aes_rx, HPI_AESEBURX_FORMAT, index, 0, &qr);
-	*pw_format = (u16)qr;
-	return err;
-}
-
 u16 hpi_aesebu_receiver_set_format(u32 h_control, u16 format)
 {
 	return hpi_control_param_set(h_control, HPI_AESEBURX_FORMAT, format,
@@ -1494,49 +993,6 @@ u16 hpi_aesebu_receiver_get_format(u32 h_control, u16 *pw_format)
 	return err;
 }
 
-u16 hpi_aesebu_receiver_get_sample_rate(u32 h_control, u32 *psample_rate)
-{
-	return hpi_control_param1_get(h_control, HPI_AESEBURX_SAMPLERATE,
-		psample_rate);
-}
-
-u16 hpi_aesebu_receiver_get_user_data(u32 h_control, u16 index, u16 *pw_data)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_CONTROL,
-		HPI_CONTROL_GET_STATE);
-	if (hpi_handle_indexes(h_control, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.c.attribute = HPI_AESEBURX_USERDATA;
-	hm.u.c.param1 = index;
-
-	hpi_send_recv(&hm, &hr);
-
-	if (pw_data)
-		*pw_data = (u16)hr.u.c.param2;
-	return hr.error;
-}
-
-u16 hpi_aesebu_receiver_get_channel_status(u32 h_control, u16 index,
-	u16 *pw_data)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_CONTROL,
-		HPI_CONTROL_GET_STATE);
-	if (hpi_handle_indexes(h_control, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.c.attribute = HPI_AESEBURX_CHANNELSTATUS;
-	hm.u.c.param1 = index;
-
-	hpi_send_recv(&hm, &hr);
-
-	if (pw_data)
-		*pw_data = (u16)hr.u.c.param2;
-	return hr.error;
-}
-
 u16 hpi_aesebu_receiver_get_error_status(u32 h_control, u16 *pw_error_data)
 {
 	u32 error_data = 0;
@@ -1549,42 +1005,6 @@ u16 hpi_aesebu_receiver_get_error_status(u32 h_control, u16 *pw_error_data)
 	return err;
 }
 
-u16 hpi_aesebu_transmitter_set_sample_rate(u32 h_control, u32 sample_rate)
-{
-	return hpi_control_param_set(h_control, HPI_AESEBUTX_SAMPLERATE,
-		sample_rate, 0);
-}
-
-u16 hpi_aesebu_transmitter_set_user_data(u32 h_control, u16 index, u16 data)
-{
-	return hpi_control_param_set(h_control, HPI_AESEBUTX_USERDATA, index,
-		data);
-}
-
-u16 hpi_aesebu_transmitter_set_channel_status(u32 h_control, u16 index,
-	u16 data)
-{
-	return hpi_control_param_set(h_control, HPI_AESEBUTX_CHANNELSTATUS,
-		index, data);
-}
-
-u16 hpi_aesebu_transmitter_get_channel_status(u32 h_control, u16 index,
-	u16 *pw_data)
-{
-	return HPI_ERROR_INVALID_OPERATION;
-}
-
-u16 hpi_aesebu_transmitter_query_format(const u32 h_aes_tx, const u32 index,
-	u16 *pw_format)
-{
-	u32 qr;
-	u16 err;
-
-	err = hpi_control_query(h_aes_tx, HPI_AESEBUTX_FORMAT, index, 0, &qr);
-	*pw_format = (u16)qr;
-	return err;
-}
-
 u16 hpi_aesebu_transmitter_set_format(u32 h_control, u16 output_format)
 {
 	return hpi_control_param_set(h_control, HPI_AESEBUTX_FORMAT,
@@ -1598,39 +1018,9 @@ u16 hpi_aesebu_transmitter_get_format(u32 h_control, u16 *pw_output_format)
 
 	err = hpi_control_param1_get(h_control, HPI_AESEBUTX_FORMAT, &param);
 	if (!err && pw_output_format)
-		*pw_output_format = (u16)param;
-
-	return err;
-}
-
-u16 hpi_bitstream_set_clock_edge(u32 h_control, u16 edge_type)
-{
-	return hpi_control_param_set(h_control, HPI_BITSTREAM_CLOCK_EDGE,
-		edge_type, 0);
-}
-
-u16 hpi_bitstream_set_data_polarity(u32 h_control, u16 polarity)
-{
-	return hpi_control_param_set(h_control, HPI_BITSTREAM_DATA_POLARITY,
-		polarity, 0);
-}
-
-u16 hpi_bitstream_get_activity(u32 h_control, u16 *pw_clk_activity,
-	u16 *pw_data_activity)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_CONTROL,
-		HPI_CONTROL_GET_STATE);
-	if (hpi_handle_indexes(h_control, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.c.attribute = HPI_BITSTREAM_ACTIVITY;
-	hpi_send_recv(&hm, &hr);
-	if (pw_clk_activity)
-		*pw_clk_activity = (u16)hr.u.c.param1;
-	if (pw_data_activity)
-		*pw_data_activity = (u16)hr.u.c.param2;
-	return hr.error;
+		*pw_output_format = (u16)param;
+
+	return err;
 }
 
 u16 hpi_channel_mode_query_mode(const u32 h_mode, const u32 index,
@@ -1723,243 +1113,6 @@ u16 hpi_cobranet_hmi_read(u32 h_control, u32 hmi_address, u32 max_byte_count,
 	return hr.h.error;
 }
 
-u16 hpi_cobranet_hmi_get_status(u32 h_control, u32 *pstatus,
-	u32 *preadable_size, u32 *pwriteable_size)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_CONTROL,
-		HPI_CONTROL_GET_STATE);
-	if (hpi_handle_indexes(h_control, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-
-	hm.u.c.attribute = HPI_COBRANET_GET_STATUS;
-
-	hpi_send_recv(&hm, &hr);
-	if (!hr.error) {
-		if (pstatus)
-			*pstatus = hr.u.cu.cobranet.status.status;
-		if (preadable_size)
-			*preadable_size =
-				hr.u.cu.cobranet.status.readable_size;
-		if (pwriteable_size)
-			*pwriteable_size =
-				hr.u.cu.cobranet.status.writeable_size;
-	}
-	return hr.error;
-}
-
-u16 hpi_cobranet_get_ip_address(u32 h_control, u32 *pdw_ip_address)
-{
-	u32 byte_count;
-	u32 iP;
-	u16 err;
-
-	err = hpi_cobranet_hmi_read(h_control,
-		HPI_COBRANET_HMI_cobra_ip_mon_currentIP, 4, &byte_count,
-		(u8 *)&iP);
-
-	*pdw_ip_address =
-		((iP & 0xff000000) >> 8) | ((iP & 0x00ff0000) << 8) | ((iP &
-			0x0000ff00) >> 8) | ((iP & 0x000000ff) << 8);
-
-	if (err)
-		*pdw_ip_address = 0;
-
-	return err;
-
-}
-
-u16 hpi_cobranet_set_ip_address(u32 h_control, u32 dw_ip_address)
-{
-	u32 iP;
-	u16 err;
-
-	iP = ((dw_ip_address & 0xff000000) >> 8) | ((dw_ip_address &
-			0x00ff0000) << 8) | ((dw_ip_address & 0x0000ff00) >>
-		8) | ((dw_ip_address & 0x000000ff) << 8);
-
-	err = hpi_cobranet_hmi_write(h_control,
-		HPI_COBRANET_HMI_cobra_ip_mon_currentIP, 4, (u8 *)&iP);
-
-	return err;
-
-}
-
-u16 hpi_cobranet_get_static_ip_address(u32 h_control, u32 *pdw_ip_address)
-{
-	u32 byte_count;
-	u32 iP;
-	u16 err;
-	err = hpi_cobranet_hmi_read(h_control,
-		HPI_COBRANET_HMI_cobra_ip_mon_staticIP, 4, &byte_count,
-		(u8 *)&iP);
-
-	*pdw_ip_address =
-		((iP & 0xff000000) >> 8) | ((iP & 0x00ff0000) << 8) | ((iP &
-			0x0000ff00) >> 8) | ((iP & 0x000000ff) << 8);
-
-	if (err)
-		*pdw_ip_address = 0;
-
-	return err;
-
-}
-
-u16 hpi_cobranet_set_static_ip_address(u32 h_control, u32 dw_ip_address)
-{
-	u32 iP;
-	u16 err;
-
-	iP = ((dw_ip_address & 0xff000000) >> 8) | ((dw_ip_address &
-			0x00ff0000) << 8) | ((dw_ip_address & 0x0000ff00) >>
-		8) | ((dw_ip_address & 0x000000ff) << 8);
-
-	err = hpi_cobranet_hmi_write(h_control,
-		HPI_COBRANET_HMI_cobra_ip_mon_staticIP, 4, (u8 *)&iP);
-
-	return err;
-
-}
-
-u16 hpi_cobranet_get_macaddress(u32 h_control, u32 *p_mac_msbs,
-	u32 *p_mac_lsbs)
-{
-	u32 byte_count;
-	u16 err;
-	u32 mac;
-
-	err = hpi_cobranet_hmi_read(h_control,
-		HPI_COBRANET_HMI_cobra_if_phy_address, 4, &byte_count,
-		(u8 *)&mac);
-
-	if (!err) {
-		*p_mac_msbs =
-			((mac & 0xff000000) >> 8) | ((mac & 0x00ff0000) << 8)
-			| ((mac & 0x0000ff00) >> 8) | ((mac & 0x000000ff) <<
-			8);
-
-		err = hpi_cobranet_hmi_read(h_control,
-			HPI_COBRANET_HMI_cobra_if_phy_address + 1, 4,
-			&byte_count, (u8 *)&mac);
-	}
-
-	if (!err) {
-		*p_mac_lsbs =
-			((mac & 0xff000000) >> 8) | ((mac & 0x00ff0000) << 8)
-			| ((mac & 0x0000ff00) >> 8) | ((mac & 0x000000ff) <<
-			8);
-	} else {
-		*p_mac_msbs = 0;
-		*p_mac_lsbs = 0;
-	}
-
-	return err;
-}
-
-u16 hpi_compander_set_enable(u32 h_control, u32 enable)
-{
-	return hpi_control_param_set(h_control, HPI_GENERIC_ENABLE, enable,
-		0);
-}
-
-u16 hpi_compander_get_enable(u32 h_control, u32 *enable)
-{
-	return hpi_control_param1_get(h_control, HPI_GENERIC_ENABLE, enable);
-}
-
-u16 hpi_compander_set_makeup_gain(u32 h_control, short makeup_gain0_01dB)
-{
-	return hpi_control_log_set2(h_control, HPI_COMPANDER_MAKEUPGAIN,
-		makeup_gain0_01dB, 0);
-}
-
-u16 hpi_compander_get_makeup_gain(u32 h_control, short *makeup_gain0_01dB)
-{
-	return hpi_control_log_get2(h_control, HPI_COMPANDER_MAKEUPGAIN,
-		makeup_gain0_01dB, NULL);
-}
-
-u16 hpi_compander_set_attack_time_constant(u32 h_control, unsigned int index,
-	u32 attack)
-{
-	return hpi_control_param_set(h_control, HPI_COMPANDER_ATTACK, attack,
-		index);
-}
-
-u16 hpi_compander_get_attack_time_constant(u32 h_control, unsigned int index,
-	u32 *attack)
-{
-	return hpi_control_param_get(h_control, HPI_COMPANDER_ATTACK, 0,
-		index, attack, NULL);
-}
-
-u16 hpi_compander_set_decay_time_constant(u32 h_control, unsigned int index,
-	u32 decay)
-{
-	return hpi_control_param_set(h_control, HPI_COMPANDER_DECAY, decay,
-		index);
-}
-
-u16 hpi_compander_get_decay_time_constant(u32 h_control, unsigned int index,
-	u32 *decay)
-{
-	return hpi_control_param_get(h_control, HPI_COMPANDER_DECAY, 0, index,
-		decay, NULL);
-
-}
-
-u16 hpi_compander_set_threshold(u32 h_control, unsigned int index,
-	short threshold0_01dB)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_CONTROL,
-		HPI_CONTROL_SET_STATE);
-	if (hpi_handle_indexes(h_control, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.c.attribute = HPI_COMPANDER_THRESHOLD;
-	hm.u.c.param2 = index;
-	hm.u.c.an_log_value[0] = threshold0_01dB;
-
-	hpi_send_recv(&hm, &hr);
-
-	return hr.error;
-}
-
-u16 hpi_compander_get_threshold(u32 h_control, unsigned int index,
-	short *threshold0_01dB)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_CONTROL,
-		HPI_CONTROL_GET_STATE);
-	if (hpi_handle_indexes(h_control, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.c.attribute = HPI_COMPANDER_THRESHOLD;
-	hm.u.c.param2 = index;
-
-	hpi_send_recv(&hm, &hr);
-	*threshold0_01dB = hr.u.c.an_log_value[0];
-
-	return hr.error;
-}
-
-u16 hpi_compander_set_ratio(u32 h_control, u32 index, u32 ratio100)
-{
-	return hpi_control_param_set(h_control, HPI_COMPANDER_RATIO, ratio100,
-		index);
-}
-
-u16 hpi_compander_get_ratio(u32 h_control, u32 index, u32 *ratio100)
-{
-	return hpi_control_param_get(h_control, HPI_COMPANDER_RATIO, 0, index,
-		ratio100, NULL);
-}
-
 u16 hpi_level_query_range(u32 h_control, short *min_gain_01dB,
 	short *max_gain_01dB, short *step_gain_01dB)
 {
@@ -2030,233 +1183,48 @@ u16 hpi_meter_get_peak(u32 h_control, short an_peakdB[HPI_MAX_CHANNELS]
 	else
 		for (i = 0; i < HPI_MAX_CHANNELS; i++)
 			an_peakdB[i] = HPI_METER_MINIMUM;
-	return hr.error;
-}
-
-u16 hpi_meter_get_rms(u32 h_control, short an_rmsdB[HPI_MAX_CHANNELS]
-	)
-{
-	short i = 0;
-
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_CONTROL,
-		HPI_CONTROL_GET_STATE);
-	if (hpi_handle_indexes(h_control, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.c.attribute = HPI_METER_RMS;
-
-	hpi_send_recv(&hm, &hr);
-
-	if (!hr.error)
-		memcpy(an_rmsdB, hr.u.c.an_log_value,
-			sizeof(short) * HPI_MAX_CHANNELS);
-	else
-		for (i = 0; i < HPI_MAX_CHANNELS; i++)
-			an_rmsdB[i] = HPI_METER_MINIMUM;
-
-	return hr.error;
-}
-
-u16 hpi_meter_set_rms_ballistics(u32 h_control, u16 attack, u16 decay)
-{
-	return hpi_control_param_set(h_control, HPI_METER_RMS_BALLISTICS,
-		attack, decay);
-}
-
-u16 hpi_meter_get_rms_ballistics(u32 h_control, u16 *pn_attack, u16 *pn_decay)
-{
-	u32 attack;
-	u32 decay;
-	u16 error;
-
-	error = hpi_control_param2_get(h_control, HPI_METER_RMS_BALLISTICS,
-		&attack, &decay);
-
-	if (pn_attack)
-		*pn_attack = (unsigned short)attack;
-	if (pn_decay)
-		*pn_decay = (unsigned short)decay;
-
-	return error;
-}
-
-u16 hpi_meter_set_peak_ballistics(u32 h_control, u16 attack, u16 decay)
-{
-	return hpi_control_param_set(h_control, HPI_METER_PEAK_BALLISTICS,
-		attack, decay);
-}
-
-u16 hpi_meter_get_peak_ballistics(u32 h_control, u16 *pn_attack,
-	u16 *pn_decay)
-{
-	u32 attack;
-	u32 decay;
-	u16 error;
-
-	error = hpi_control_param2_get(h_control, HPI_METER_PEAK_BALLISTICS,
-		&attack, &decay);
-
-	if (pn_attack)
-		*pn_attack = (short)attack;
-	if (pn_decay)
-		*pn_decay = (short)decay;
-
-	return error;
-}
-
-u16 hpi_microphone_set_phantom_power(u32 h_control, u16 on_off)
-{
-	return hpi_control_param_set(h_control, HPI_MICROPHONE_PHANTOM_POWER,
-		(u32)on_off, 0);
-}
-
-u16 hpi_microphone_get_phantom_power(u32 h_control, u16 *pw_on_off)
-{
-	u16 error = 0;
-	u32 on_off = 0;
-	error = hpi_control_param1_get(h_control,
-		HPI_MICROPHONE_PHANTOM_POWER, &on_off);
-	if (pw_on_off)
-		*pw_on_off = (u16)on_off;
-	return error;
-}
-
-u16 hpi_multiplexer_set_source(u32 h_control, u16 source_node_type,
-	u16 source_node_index)
-{
-	return hpi_control_param_set(h_control, HPI_MULTIPLEXER_SOURCE,
-		source_node_type, source_node_index);
-}
-
-u16 hpi_multiplexer_get_source(u32 h_control, u16 *source_node_type,
-	u16 *source_node_index)
-{
-	u32 node, index;
-	u16 err = hpi_control_param2_get(h_control,
-		HPI_MULTIPLEXER_SOURCE, &node,
-		&index);
-	if (source_node_type)
-		*source_node_type = (u16)node;
-	if (source_node_index)
-		*source_node_index = (u16)index;
-	return err;
-}
-
-u16 hpi_multiplexer_query_source(u32 h_control, u16 index,
-	u16 *source_node_type, u16 *source_node_index)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_CONTROL,
-		HPI_CONTROL_GET_STATE);
-	if (hpi_handle_indexes(h_control, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.c.attribute = HPI_MULTIPLEXER_QUERYSOURCE;
-	hm.u.c.param1 = index;
-
-	hpi_send_recv(&hm, &hr);
-
-	if (source_node_type)
-		*source_node_type = (u16)hr.u.c.param1;
-	if (source_node_index)
-		*source_node_index = (u16)hr.u.c.param2;
-	return hr.error;
-}
-
-u16 hpi_parametric_eq_get_info(u32 h_control, u16 *pw_number_of_bands,
-	u16 *pw_on_off)
-{
-	u32 oB = 0;
-	u32 oO = 0;
-	u16 error = 0;
-
-	error = hpi_control_param2_get(h_control, HPI_EQUALIZER_NUM_FILTERS,
-		&oO, &oB);
-	if (pw_number_of_bands)
-		*pw_number_of_bands = (u16)oB;
-	if (pw_on_off)
-		*pw_on_off = (u16)oO;
-	return error;
-}
-
-u16 hpi_parametric_eq_set_state(u32 h_control, u16 on_off)
-{
-	return hpi_control_param_set(h_control, HPI_EQUALIZER_NUM_FILTERS,
-		on_off, 0);
-}
-
-u16 hpi_parametric_eq_get_band(u32 h_control, u16 index, u16 *pn_type,
-	u32 *pfrequency_hz, short *pnQ100, short *pn_gain0_01dB)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_CONTROL,
-		HPI_CONTROL_GET_STATE);
-	if (hpi_handle_indexes(h_control, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.c.attribute = HPI_EQUALIZER_FILTER;
-	hm.u.c.param2 = index;
-
-	hpi_send_recv(&hm, &hr);
-
-	if (pfrequency_hz)
-		*pfrequency_hz = hr.u.c.param1;
-	if (pn_type)
-		*pn_type = (u16)(hr.u.c.param2 >> 16);
-	if (pnQ100)
-		*pnQ100 = hr.u.c.an_log_value[1];
-	if (pn_gain0_01dB)
-		*pn_gain0_01dB = hr.u.c.an_log_value[0];
-
-	return hr.error;
-}
-
-u16 hpi_parametric_eq_set_band(u32 h_control, u16 index, u16 type,
-	u32 frequency_hz, short q100, short gain0_01dB)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_CONTROL,
-		HPI_CONTROL_SET_STATE);
-	if (hpi_handle_indexes(h_control, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-
-	hm.u.c.param1 = frequency_hz;
-	hm.u.c.param2 = (index & 0xFFFFL) + ((u32)type << 16);
-	hm.u.c.an_log_value[0] = gain0_01dB;
-	hm.u.c.an_log_value[1] = q100;
-	hm.u.c.attribute = HPI_EQUALIZER_FILTER;
+	return hr.error;
+}
 
-	hpi_send_recv(&hm, &hr);
+u16 hpi_multiplexer_set_source(u32 h_control, u16 source_node_type,
+	u16 source_node_index)
+{
+	return hpi_control_param_set(h_control, HPI_MULTIPLEXER_SOURCE,
+		source_node_type, source_node_index);
+}
 
-	return hr.error;
+u16 hpi_multiplexer_get_source(u32 h_control, u16 *source_node_type,
+	u16 *source_node_index)
+{
+	u32 node, index;
+	u16 err = hpi_control_param2_get(h_control,
+		HPI_MULTIPLEXER_SOURCE, &node,
+		&index);
+	if (source_node_type)
+		*source_node_type = (u16)node;
+	if (source_node_index)
+		*source_node_index = (u16)index;
+	return err;
 }
 
-u16 hpi_parametric_eq_get_coeffs(u32 h_control, u16 index, short coeffs[5]
-	)
+u16 hpi_multiplexer_query_source(u32 h_control, u16 index,
+	u16 *source_node_type, u16 *source_node_index)
 {
 	struct hpi_message hm;
 	struct hpi_response hr;
-
 	hpi_init_message_response(&hm, &hr, HPI_OBJ_CONTROL,
 		HPI_CONTROL_GET_STATE);
 	if (hpi_handle_indexes(h_control, &hm.adapter_index, &hm.obj_index))
 		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.c.attribute = HPI_EQUALIZER_COEFFICIENTS;
-	hm.u.c.param2 = index;
+	hm.u.c.attribute = HPI_MULTIPLEXER_QUERYSOURCE;
+	hm.u.c.param1 = index;
 
 	hpi_send_recv(&hm, &hr);
 
-	coeffs[0] = (short)hr.u.c.an_log_value[0];
-	coeffs[1] = (short)hr.u.c.an_log_value[1];
-	coeffs[2] = (short)hr.u.c.param1;
-	coeffs[3] = (short)(hr.u.c.param1 >> 16);
-	coeffs[4] = (short)hr.u.c.param2;
-
+	if (source_node_type)
+		*source_node_type = (u16)hr.u.c.param1;
+	if (source_node_index)
+		*source_node_index = (u16)hr.u.c.param2;
 	return hr.error;
 }
 
@@ -2360,130 +1328,6 @@ u16 hpi_sample_clock_get_sample_rate(u32 h_control, u32 *psample_rate)
 	return err;
 }
 
-u16 hpi_sample_clock_set_auto(u32 h_control, u32 enable)
-{
-	return hpi_control_param_set(h_control, HPI_SAMPLECLOCK_AUTO, enable,
-		0);
-}
-
-u16 hpi_sample_clock_get_auto(u32 h_control, u32 *penable)
-{
-	return hpi_control_param1_get(h_control, HPI_SAMPLECLOCK_AUTO,
-		penable);
-}
-
-u16 hpi_sample_clock_set_local_rate_lock(u32 h_control, u32 lock)
-{
-	return hpi_control_param_set(h_control, HPI_SAMPLECLOCK_LOCAL_LOCK,
-		lock, 0);
-}
-
-u16 hpi_sample_clock_get_local_rate_lock(u32 h_control, u32 *plock)
-{
-	return hpi_control_param1_get(h_control, HPI_SAMPLECLOCK_LOCAL_LOCK,
-		plock);
-}
-
-u16 hpi_tone_detector_get_frequency(u32 h_control, u32 index, u32 *frequency)
-{
-	return hpi_control_param_get(h_control, HPI_TONEDETECTOR_FREQUENCY,
-		index, 0, frequency, NULL);
-}
-
-u16 hpi_tone_detector_get_state(u32 h_control, u32 *state)
-{
-	return hpi_control_param1_get(h_control, HPI_TONEDETECTOR_STATE,
-		state);
-}
-
-u16 hpi_tone_detector_set_enable(u32 h_control, u32 enable)
-{
-	return hpi_control_param_set(h_control, HPI_GENERIC_ENABLE, enable,
-		0);
-}
-
-u16 hpi_tone_detector_get_enable(u32 h_control, u32 *enable)
-{
-	return hpi_control_param1_get(h_control, HPI_GENERIC_ENABLE, enable);
-}
-
-u16 hpi_tone_detector_set_event_enable(u32 h_control, u32 event_enable)
-{
-	return hpi_control_param_set(h_control, HPI_GENERIC_EVENT_ENABLE,
-		(u32)event_enable, 0);
-}
-
-u16 hpi_tone_detector_get_event_enable(u32 h_control, u32 *event_enable)
-{
-	return hpi_control_param1_get(h_control, HPI_GENERIC_EVENT_ENABLE,
-		event_enable);
-}
-
-u16 hpi_tone_detector_set_threshold(u32 h_control, int threshold)
-{
-	return hpi_control_param_set(h_control, HPI_TONEDETECTOR_THRESHOLD,
-		(u32)threshold, 0);
-}
-
-u16 hpi_tone_detector_get_threshold(u32 h_control, int *threshold)
-{
-	return hpi_control_param1_get(h_control, HPI_TONEDETECTOR_THRESHOLD,
-		(u32 *)threshold);
-}
-
-u16 hpi_silence_detector_get_state(u32 h_control, u32 *state)
-{
-	return hpi_control_param1_get(h_control, HPI_SILENCEDETECTOR_STATE,
-		state);
-}
-
-u16 hpi_silence_detector_set_enable(u32 h_control, u32 enable)
-{
-	return hpi_control_param_set(h_control, HPI_GENERIC_ENABLE, enable,
-		0);
-}
-
-u16 hpi_silence_detector_get_enable(u32 h_control, u32 *enable)
-{
-	return hpi_control_param1_get(h_control, HPI_GENERIC_ENABLE, enable);
-}
-
-u16 hpi_silence_detector_set_event_enable(u32 h_control, u32 event_enable)
-{
-	return hpi_control_param_set(h_control, HPI_GENERIC_EVENT_ENABLE,
-		event_enable, 0);
-}
-
-u16 hpi_silence_detector_get_event_enable(u32 h_control, u32 *event_enable)
-{
-	return hpi_control_param1_get(h_control, HPI_GENERIC_EVENT_ENABLE,
-		event_enable);
-}
-
-u16 hpi_silence_detector_set_delay(u32 h_control, u32 delay)
-{
-	return hpi_control_param_set(h_control, HPI_SILENCEDETECTOR_DELAY,
-		delay, 0);
-}
-
-u16 hpi_silence_detector_get_delay(u32 h_control, u32 *delay)
-{
-	return hpi_control_param1_get(h_control, HPI_SILENCEDETECTOR_DELAY,
-		delay);
-}
-
-u16 hpi_silence_detector_set_threshold(u32 h_control, int threshold)
-{
-	return hpi_control_param_set(h_control, HPI_SILENCEDETECTOR_THRESHOLD,
-		threshold, 0);
-}
-
-u16 hpi_silence_detector_get_threshold(u32 h_control, int *threshold)
-{
-	return hpi_control_param1_get(h_control,
-		HPI_SILENCEDETECTOR_THRESHOLD, (u32 *)threshold);
-}
-
 u16 hpi_tuner_query_band(const u32 h_tuner, const u32 index, u16 *pw_band)
 {
 	u32 qr;
@@ -2554,196 +1398,6 @@ u16 hpi_tuner_get_gain(u32 h_control, short *pn_gain)
 	return error;
 }
 
-u16 hpi_tuner_get_rf_level(u32 h_control, short *pw_level)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_CONTROL,
-		HPI_CONTROL_GET_STATE);
-	if (hpi_handle_indexes(h_control, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.cu.attribute = HPI_TUNER_LEVEL_AVG;
-	hpi_send_recv(&hm, &hr);
-	if (pw_level)
-		*pw_level = hr.u.cu.tuner.s_level;
-	return hr.error;
-}
-
-u16 hpi_tuner_get_raw_rf_level(u32 h_control, short *pw_level)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_CONTROL,
-		HPI_CONTROL_GET_STATE);
-	if (hpi_handle_indexes(h_control, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.cu.attribute = HPI_TUNER_LEVEL_RAW;
-	hpi_send_recv(&hm, &hr);
-	if (pw_level)
-		*pw_level = hr.u.cu.tuner.s_level;
-	return hr.error;
-}
-
-u16 hpi_tuner_query_deemphasis(const u32 h_tuner, const u32 index,
-	const u16 band, u32 *pdeemphasis)
-{
-	return hpi_control_query(h_tuner, HPI_TUNER_DEEMPHASIS, index, band,
-		pdeemphasis);
-}
-
-u16 hpi_tuner_set_deemphasis(u32 h_control, u32 deemphasis)
-{
-	return hpi_control_param_set(h_control, HPI_TUNER_DEEMPHASIS,
-		deemphasis, 0);
-}
-
-u16 hpi_tuner_get_deemphasis(u32 h_control, u32 *pdeemphasis)
-{
-	return hpi_control_param1_get(h_control, HPI_TUNER_DEEMPHASIS,
-		pdeemphasis);
-}
-
-u16 hpi_tuner_query_program(const u32 h_tuner, u32 *pbitmap_program)
-{
-	return hpi_control_query(h_tuner, HPI_TUNER_PROGRAM, 0, 0,
-		pbitmap_program);
-}
-
-u16 hpi_tuner_set_program(u32 h_control, u32 program)
-{
-	return hpi_control_param_set(h_control, HPI_TUNER_PROGRAM, program,
-		0);
-}
-
-u16 hpi_tuner_get_program(u32 h_control, u32 *pprogram)
-{
-	return hpi_control_param1_get(h_control, HPI_TUNER_PROGRAM, pprogram);
-}
-
-u16 hpi_tuner_get_hd_radio_dsp_version(u32 h_control, char *psz_dsp_version,
-	const u32 string_size)
-{
-	return hpi_control_get_string(h_control,
-		HPI_TUNER_HDRADIO_DSP_VERSION, psz_dsp_version, string_size);
-}
-
-u16 hpi_tuner_get_hd_radio_sdk_version(u32 h_control, char *psz_sdk_version,
-	const u32 string_size)
-{
-	return hpi_control_get_string(h_control,
-		HPI_TUNER_HDRADIO_SDK_VERSION, psz_sdk_version, string_size);
-}
-
-u16 hpi_tuner_get_status(u32 h_control, u16 *pw_status_mask, u16 *pw_status)
-{
-	u32 status = 0;
-	u16 error = 0;
-
-	error = hpi_control_param1_get(h_control, HPI_TUNER_STATUS, &status);
-	if (pw_status) {
-		if (!error) {
-			*pw_status_mask = (u16)(status >> 16);
-			*pw_status = (u16)(status & 0xFFFF);
-		} else {
-			*pw_status_mask = 0;
-			*pw_status = 0;
-		}
-	}
-	return error;
-}
-
-u16 hpi_tuner_set_mode(u32 h_control, u32 mode, u32 value)
-{
-	return hpi_control_param_set(h_control, HPI_TUNER_MODE, mode, value);
-}
-
-u16 hpi_tuner_get_mode(u32 h_control, u32 mode, u32 *pn_value)
-{
-	return hpi_control_param_get(h_control, HPI_TUNER_MODE, mode, 0,
-		pn_value, NULL);
-}
-
-u16 hpi_tuner_get_hd_radio_signal_quality(u32 h_control, u32 *pquality)
-{
-	return hpi_control_param1_get(h_control,
-		HPI_TUNER_HDRADIO_SIGNAL_QUALITY, pquality);
-}
-
-u16 hpi_tuner_get_hd_radio_signal_blend(u32 h_control, u32 *pblend)
-{
-	return hpi_control_param1_get(h_control, HPI_TUNER_HDRADIO_BLEND,
-		pblend);
-}
-
-u16 hpi_tuner_set_hd_radio_signal_blend(u32 h_control, const u32 blend)
-{
-	return hpi_control_param_set(h_control, HPI_TUNER_HDRADIO_BLEND,
-		blend, 0);
-}
-
-u16 hpi_tuner_get_rds(u32 h_control, char *p_data)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_CONTROL,
-		HPI_CONTROL_GET_STATE);
-	if (hpi_handle_indexes(h_control, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.c.attribute = HPI_TUNER_RDS;
-	hpi_send_recv(&hm, &hr);
-	if (p_data) {
-		*(u32 *)&p_data[0] = hr.u.cu.tuner.rds.data[0];
-		*(u32 *)&p_data[4] = hr.u.cu.tuner.rds.data[1];
-		*(u32 *)&p_data[8] = hr.u.cu.tuner.rds.bLER;
-	}
-	return hr.error;
-}
-
-u16 hpi_pad_get_channel_name(u32 h_control, char *psz_string,
-	const u32 data_length)
-{
-	return hpi_control_get_string(h_control, HPI_PAD_CHANNEL_NAME,
-		psz_string, data_length);
-}
-
-u16 hpi_pad_get_artist(u32 h_control, char *psz_string, const u32 data_length)
-{
-	return hpi_control_get_string(h_control, HPI_PAD_ARTIST, psz_string,
-		data_length);
-}
-
-u16 hpi_pad_get_title(u32 h_control, char *psz_string, const u32 data_length)
-{
-	return hpi_control_get_string(h_control, HPI_PAD_TITLE, psz_string,
-		data_length);
-}
-
-u16 hpi_pad_get_comment(u32 h_control, char *psz_string,
-	const u32 data_length)
-{
-	return hpi_control_get_string(h_control, HPI_PAD_COMMENT, psz_string,
-		data_length);
-}
-
-u16 hpi_pad_get_program_type(u32 h_control, u32 *ppTY)
-{
-	return hpi_control_param1_get(h_control, HPI_PAD_PROGRAM_TYPE, ppTY);
-}
-
-u16 hpi_pad_get_rdsPI(u32 h_control, u32 *ppI)
-{
-	return hpi_control_param1_get(h_control, HPI_PAD_PROGRAM_ID, ppI);
-}
-
-u16 hpi_volume_query_channels(const u32 h_volume, u32 *p_channels)
-{
-	return hpi_control_query(h_volume, HPI_VOLUME_NUM_CHANNELS, 0, 0,
-		p_channels);
-}
-
 u16 hpi_volume_set_gain(u32 h_control, short an_log_gain[HPI_MAX_CHANNELS]
 	)
 {
@@ -2794,78 +1448,3 @@ u16 hpi_volume_query_range(u32 h_control, short *min_gain_01dB,
 		*step_gain_01dB = (short)hr.u.c.param1;
 	return hr.error;
 }
-
-u16 hpi_volume_auto_fade_profile(u32 h_control,
-	short an_stop_gain0_01dB[HPI_MAX_CHANNELS], u32 duration_ms,
-	u16 profile)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_CONTROL,
-		HPI_CONTROL_SET_STATE);
-	if (hpi_handle_indexes(h_control, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-
-	memcpy(hm.u.c.an_log_value, an_stop_gain0_01dB,
-		sizeof(short) * HPI_MAX_CHANNELS);
-
-	hm.u.c.attribute = HPI_VOLUME_AUTOFADE;
-	hm.u.c.param1 = duration_ms;
-	hm.u.c.param2 = profile;
-
-	hpi_send_recv(&hm, &hr);
-
-	return hr.error;
-}
-
-u16 hpi_volume_auto_fade(u32 h_control,
-	short an_stop_gain0_01dB[HPI_MAX_CHANNELS], u32 duration_ms)
-{
-	return hpi_volume_auto_fade_profile(h_control, an_stop_gain0_01dB,
-		duration_ms, HPI_VOLUME_AUTOFADE_LOG);
-}
-
-u16 hpi_volume_query_auto_fade_profile(const u32 h_volume, const u32 i,
-	u16 *profile)
-{
-	u16 e;
-	u32 u;
-	e = hpi_control_query(h_volume, HPI_VOLUME_AUTOFADE, i, 0, &u);
-	*profile = (u16)u;
-	return e;
-}
-
-u16 hpi_vox_set_threshold(u32 h_control, short an_gain0_01dB)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_CONTROL,
-		HPI_CONTROL_SET_STATE);
-	if (hpi_handle_indexes(h_control, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.c.attribute = HPI_VOX_THRESHOLD;
-
-	hm.u.c.an_log_value[0] = an_gain0_01dB;
-
-	hpi_send_recv(&hm, &hr);
-
-	return hr.error;
-}
-
-u16 hpi_vox_get_threshold(u32 h_control, short *an_gain0_01dB)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_CONTROL,
-		HPI_CONTROL_GET_STATE);
-	if (hpi_handle_indexes(h_control, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-	hm.u.c.attribute = HPI_VOX_THRESHOLD;
-
-	hpi_send_recv(&hm, &hr);
-
-	*an_gain0_01dB = hr.u.c.an_log_value[0];
-
-	return hr.error;
-}
-- 
1.7.10.4

