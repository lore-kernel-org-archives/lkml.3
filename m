Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaJYXHa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 19:07:30 -0400
Received: from mx1.riseup.net ([198.252.153.129]:44578 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbaJYXH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 19:07:27 -0400
MIME-Version: 1.0
Date: Sat, 25 Oct 2014 21:07:24 -0200
Message-ID: <CA+bYFQbyTGQaAKuLCS1b8dexei=mEB8OL87-3b=erbajY4urtg@mail.gmail.com>
Subject: Compiling kernel errors
From: Albino Biasutti Neto <bino@riseup.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I was compiling kernel current, problems. I was installed modules.

DEPMOD  3.18.0-rc1+
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54spi.ko
needs unknown symbol ieee80211_queue_work
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/he.ko
needs unknown symbol atm_pcr_goal
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/he.ko
needs unknown symbol atm_dev_deregister
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/he.ko
needs unknown symbol vcc_hash
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/he.ko
needs unknown symbol atm_dev_register
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/he.ko
needs unknown symbol atm_alloc_charge
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/he.ko
needs unknown symbol vcc_sklist_lock
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/rtl8192e/rtllib_crypt_ccmp.ko
needs unknown symbol lib80211_unregister_crypto_ops
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/rtl8192e/rtllib_crypt_ccmp.ko
needs unknown symbol lib80211_register_crypto_ops
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/uPD98402.ko needs unknown
symbol sonet_subtract_stats
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/uPD98402.ko needs unknown
symbol sonet_copy_stats
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/hamradio/yam.ko needs
unknown symbol ax25_header_ops
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/hamradio/yam.ko needs
unknown symbol ax25_defaddr
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/hamradio/yam.ko needs
unknown symbol ax25_bcast
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/hamradio/mkiss.ko needs
unknown symbol ax25_hard_header
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/hamradio/mkiss.ko needs
unknown symbol ax25_rebuild_header
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/hamradio/mkiss.ko needs
unknown symbol ax25_defaddr
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/hamradio/mkiss.ko needs
unknown symbol ax25_bcast
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btusb.ko needs
unknown symbol hci_free_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btusb.ko needs
unknown symbol hci_alloc_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btusb.ko needs
unknown symbol bt_info
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btusb.ko needs
unknown symbol bt_to_errno
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btusb.ko needs
unknown symbol bt_err
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btusb.ko needs
unknown symbol __hci_cmd_sync_ev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btusb.ko needs
unknown symbol hci_unregister_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btusb.ko needs
unknown symbol hci_recv_frame
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btusb.ko needs
unknown symbol hci_register_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btusb.ko needs
unknown symbol __hci_cmd_sync
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/fs/cachefiles/cachefiles.ko needs
unknown symbol fscache_op_complete
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/fs/cachefiles/cachefiles.ko needs
unknown symbol fscache_enqueue_operation
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/fs/cachefiles/cachefiles.ko needs
unknown symbol fscache_object_sleep_till_congested
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/fs/cachefiles/cachefiles.ko needs
unknown symbol fscache_io_error
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/fs/cachefiles/cachefiles.ko needs
unknown symbol fscache_put_operation
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/fs/cachefiles/cachefiles.ko needs
unknown symbol fscache_object_destroy
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/fs/cachefiles/cachefiles.ko needs
unknown symbol fscache_init_cache
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/fs/cachefiles/cachefiles.ko needs
unknown symbol fscache_mark_page_cached
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/fs/cachefiles/cachefiles.ko needs
unknown symbol fscache_mark_pages_cached
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/fs/cachefiles/cachefiles.ko needs
unknown symbol fscache_withdraw_cache
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/fs/cachefiles/cachefiles.ko needs
unknown symbol fscache_obtained_object
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/fs/cachefiles/cachefiles.ko needs
unknown symbol fscache_cache_cleared_wq
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/fs/cachefiles/cachefiles.ko needs
unknown symbol fscache_check_aux
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/fs/cachefiles/cachefiles.ko needs
unknown symbol fscache_add_cache
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/fs/cachefiles/cachefiles.ko needs
unknown symbol fscache_object_lookup_negative
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/fs/cachefiles/cachefiles.ko needs
unknown symbol fscache_object_init
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/atmel.ko needs
unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/atmel.ko needs
unknown symbol ieee80211_frequency_to_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192ce.ko
needs unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_connection_loss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_probereq_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_nullfunc_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_pspoll_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_wake_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_get_key_rx_seq
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_sta_set_buffered
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol cfg80211_put_bss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_bss_get_ie
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol cfg80211_get_bss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_tx_status
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_stop_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol cfg80211_find_ie
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_scan_completed
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_hdrlen
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_cqm_rssi_notify
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/cw1200/cw1200_core.ko
needs unknown symbol ieee80211_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/vt6656/vt6656_stage.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/vt6656/vt6656_stage.ko
needs unknown symbol ieee80211_get_tkip_p2k
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/vt6656/vt6656_stage.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/vt6656/vt6656_stage.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/vt6656/vt6656_stage.ko
needs unknown symbol ieee80211_get_hdrlen_from_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/vt6656/vt6656_stage.ko
needs unknown symbol ieee80211_get_key_tx_seq
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/vt6656/vt6656_stage.ko
needs unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/vt6656/vt6656_stage.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/vt6656/vt6656_stage.ko
needs unknown symbol ieee80211_free_txskb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/vt6656/vt6656_stage.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/vt6656/vt6656_stage.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/vt6656/vt6656_stage.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/vt6656/vt6656_stage.ko
needs unknown symbol ieee80211_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol ieee80211_queue_stopped
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol ieee80211_start_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol regulatory_hint
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol ieee80211_restart_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol __ieee80211_get_radio_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol ieee80211_wake_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol wiphy_rfkill_set_hw_state
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol ieee80211_stop_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol wiphy_to_ieee80211_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol ieee80211_queue_delayed_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol ieee80211_proberesp_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol wiphy_rfkill_stop_polling
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol wiphy_apply_custom_regulatory
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol cordic_calc_iq
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol ieee80211_stop_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol wiphy_rfkill_start_polling
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol freq_reg_info
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
needs unknown symbol ieee80211_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btwilink.ko needs
unknown symbol hci_free_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btwilink.ko needs
unknown symbol hci_alloc_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btwilink.ko needs
unknown symbol bt_err
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btwilink.ko needs
unknown symbol hci_unregister_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btwilink.ko needs
unknown symbol hci_recv_frame
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btwilink.ko needs
unknown symbol hci_register_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore_spi.ko
needs unknown symbol crc7_be
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/via-ircc.ko needs
unknown symbol alloc_irdadev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/via-ircc.ko needs
unknown symbol irlap_open
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/via-ircc.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/via-ircc.ko needs
unknown symbol irlap_close
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/via-ircc.ko needs
unknown symbol irda_device_set_media_busy
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/via-ircc.ko needs
unknown symbol irda_setup_dma
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/via-ircc.ko needs
unknown symbol async_wrap_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/via-ircc.ko needs
unknown symbol irda_init_max_qos_capabilies
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol regulatory_hint
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_restart_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_stop_rx_ba_session_offl
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol cfg80211_put_bss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_bss_get_ie
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol wiphy_to_ieee80211_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_queue_delayed_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_find_sta_by_ifaddr
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_remain_on_channel_expired
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_rx
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_report_low_ack
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_free_txskb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol cfg80211_get_bss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol __ieee80211_get_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_tx_status
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_ready_on_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol cfg80211_find_ie
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_scan_completed
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_iterate_active_interfaces_atomic
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_hdrlen
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_start_rx_ba_session_offl
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_radar_detected
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_csa_is_complete
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_queue_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol cfg80211_find_vendor_ie
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
needs unknown symbol ieee80211_csa_finish
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rndis_wlan.ko
needs unknown symbol cfg80211_scan_done
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rndis_wlan.ko
needs unknown symbol cfg80211_disconnected
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rndis_wlan.ko
needs unknown symbol wiphy_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rndis_wlan.ko
needs unknown symbol wiphy_new
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rndis_wlan.ko
needs unknown symbol cfg80211_put_bss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rndis_wlan.ko
needs unknown symbol cfg80211_roamed
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rndis_wlan.ko
needs unknown symbol cfg80211_inform_bss_width
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rndis_wlan.ko
needs unknown symbol cfg80211_ibss_joined
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rndis_wlan.ko
needs unknown symbol cfg80211_michael_mic_failure
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rndis_wlan.ko
needs unknown symbol cfg80211_connect_result
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rndis_wlan.ko
needs unknown symbol wiphy_unregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rndis_wlan.ko
needs unknown symbol __ieee80211_get_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rndis_wlan.ko
needs unknown symbol cfg80211_pmksa_candidate_notify
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rndis_wlan.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rndis_wlan.ko
needs unknown symbol ieee80211_frequency_to_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rndis_wlan.ko
needs unknown symbol wiphy_free
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rndis_wlan.ko
needs unknown symbol cfg80211_cqm_rssi_notify
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/fore_200e.ko needs unknown
symbol atm_dev_deregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/fore_200e.ko needs unknown
symbol atm_dev_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/fore_200e.ko needs unknown
symbol atm_charge
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/act200l-sir.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_con_keepalive
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_osdc_build_request
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_msg_get
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_create_snap_context
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_create_client
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol __fscache_read_or_alloc_pages
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol osd_req_op_extent_osd_data
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_calc_pg_primary
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_osdc_get_request
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_con_open
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol __fscache_attr_changed
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_osdc_put_request
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_auth_destroy_authorizer
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_flags_to_mode
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_put_snap_context
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_caps_for_mode
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol osd_req_op_extent_update
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol __fscache_readpages_cancel
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol __fscache_relinquish_cookie
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_msg_new
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_auth_invalidate_authorizer
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_msg_data_add_pagelist
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_msg_type_name
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_release_page_vector
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_check_fsid
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_pagelist_append
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_auth_verify_authorizer_reply
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_auth_update_authorizer
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_pg_pool_name_by_id
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_osdc_wait_request
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_osdc_new_request
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol __fscache_unregister_netfs
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_calc_file_object_mapping
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_monc_got_mdsmap
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_osdc_readpages
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol __fscache_maybe_release_page
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_con_send
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_zero_page_vector_range
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_osdc_start_request
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_compare_options
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_msg_dump
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_buffer_new
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol __fscache_uncache_all_inode_pages
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol __fscache_read_or_alloc_page
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_put_page_vector
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_get_snap_context
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_auth_create_authorizer
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_pagelist_release
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol osd_req_op_extent_osd_data_pages
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_osdc_sync
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol __fscache_uncache_page
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_destroy_client
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_oloc_oid_to_pg
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol __ceph_open_session
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol __fscache_register_netfs
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_alloc_page_vector
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol __fscache_write_page
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_monc_do_statfs
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_monc_validate_auth
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_osdc_writepages
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_parse_options
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol __fscache_invalidate
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_msg_put
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_str_hash
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_pr_addr
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_buffer_release
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_con_init
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol __fscache_wait_on_page_write
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_destroy_options
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol __fscache_acquire_cookie
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_con_close
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol ceph_msgr_flush
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/ceph/ceph.ko needs
unknown symbol __fscache_check_consistency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bluecard_cs.ko needs
unknown symbol hci_free_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bluecard_cs.ko needs
unknown symbol hci_alloc_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bluecard_cs.ko needs
unknown symbol bt_err
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bluecard_cs.ko needs
unknown symbol hci_unregister_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bluecard_cs.ko needs
unknown symbol hci_recv_frame
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bluecard_cs.ko needs
unknown symbol hci_register_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/usb/atm/ueagle-atm.ko needs
unknown symbol atm_dev_signal_change
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/airo.ko needs
unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/airo.ko needs
unknown symbol ieee80211_frequency_to_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/hostap/hostap_plx.ko
needs unknown symbol lib80211_crypt_info_init
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/hostap/hostap_plx.ko
needs unknown symbol lib80211_crypt_info_free
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/actisys-sir.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/tekram-sir.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl_pci.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl_pci.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl_pci.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl_pci.ko
needs unknown symbol ieee80211_wake_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl_pci.ko
needs unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl_pci.ko
needs unknown symbol ieee80211_stop_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl_pci.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl_pci.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl_pci.ko
needs unknown symbol ieee80211_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_stop_tx_ba_session
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_gtk_rekey_notify
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_get_tkip_p1k_iv
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_start_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_connection_loss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_report_wowlan_wakeup
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_set_key_tx_seq
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_sched_scan_stopped
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_get_tkip_p2k
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_start_tx_ba_session
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_beacon_loss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_restart_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_sta_eosp
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_rate_control_unregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol __ieee80211_get_radio_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_wake_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_get_key_tx_seq
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_iter_keys
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_get_key_rx_seq
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_sta_set_buffered
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol wiphy_rfkill_set_hw_state
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_set_key_rx_seq
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_stop_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_remove_key
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_gtk_rekey_add
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_find_sta_by_ifaddr
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_sta_block_awake
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_remain_on_channel_expired
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_rx
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_beacon_get_template
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_iterate_active_interfaces
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_rate_control_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_napi_add
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_free_txskb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_tx_status
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_stop_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_ready_on_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_get_tkip_rx_p1k
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_sched_scan_results
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_data_to_8023
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_scan_completed
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_iterate_active_interfaces_atomic
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol rate_control_send_low
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_resume_disconnect
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_csa_update_counter
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_hdrlen
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol cfg80211_chandef_create
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_tdls_oper_request
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_cqm_rssi_notify
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_request_smps
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_aes_cmac_calculate_k1_k2
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_csa_is_complete
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_iterate_active_interfaces_rtnl
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
needs unknown symbol ieee80211_csa_finish
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
needs unknown symbol ieee80211_start_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
needs unknown symbol ieee80211_connection_loss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
needs unknown symbol ieee80211_start_tx_ba_session
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
needs unknown symbol ieee80211_rate_control_unregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
needs unknown symbol ieee80211_get_hdrlen_from_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
needs unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
needs unknown symbol wiphy_rfkill_set_hw_state
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
needs unknown symbol ieee80211_stop_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
needs unknown symbol wiphy_to_ieee80211_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
needs unknown symbol wiphy_rfkill_stop_polling
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
needs unknown symbol wiphy_apply_custom_regulatory
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
needs unknown symbol ieee80211_rate_control_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
needs unknown symbol wiphy_rfkill_start_polling
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
needs unknown symbol freq_reg_info
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
needs unknown symbol rate_control_send_low
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
needs unknown symbol ieee80211_resume_disconnect
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
needs unknown symbol ieee80211_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/usb/atm/usbatm.ko needs
unknown symbol atm_dev_deregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/usb/atm/usbatm.ko needs
unknown symbol atm_dev_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/usb/atm/usbatm.ko needs
unknown symbol vcc_release_async
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/usb/atm/usbatm.ko needs
unknown symbol atm_charge
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl18xx/wl18xx.ko
needs unknown symbol ieee80211_connection_loss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl18xx/wl18xx.ko
needs unknown symbol ieee80211_get_hdrlen_from_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl18xx/wl18xx.ko
needs unknown symbol __cfg80211_alloc_event_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl18xx/wl18xx.ko
needs unknown symbol __cfg80211_send_event_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl18xx/wl18xx.ko
needs unknown symbol ieee80211_queue_delayed_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl18xx/wl18xx.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_stop_tx_ba_session
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_start_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_start_tx_ba_session
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_restart_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_stop_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_find_sta_by_ifaddr
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol cfg80211_find_ie
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_hdrlen
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_queue_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwl8k.ko needs
unknown symbol ieee80211_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wan/lapbether.ko needs
unknown symbol lapb_data_received
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wan/lapbether.ko needs
unknown symbol lapb_disconnect_request
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wan/lapbether.ko needs
unknown symbol lapb_unregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wan/lapbether.ko needs
unknown symbol lapb_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wan/lapbether.ko needs
unknown symbol lapb_data_request
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wan/lapbether.ko needs
unknown symbol lapb_connect_request
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_start_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol regulatory_hint
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol __ieee80211_create_tpt_led_trigger
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_sta_eosp
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol __ieee80211_get_radio_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_wake_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_get_buffered_bc
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_get_tx_rates
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_send_bar
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_sta_set_buffered
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol wiphy_rfkill_set_hw_state
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_stop_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol wiphy_to_ieee80211_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_queue_delayed_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol wiphy_rfkill_stop_polling
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_find_sta_by_ifaddr
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_rx
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_free_txskb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_tx_status
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_stop_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol wiphy_rfkill_start_polling
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_iterate_active_interfaces_atomic
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_hdrlen
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol cfg80211_chandef_create
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_csa_is_complete
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_queue_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
needs unknown symbol ieee80211_csa_finish
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ethernet/broadcom/bnx2x/bnx2x.ko
needs unknown symbol crc32c
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251_spi.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251_spi.ko
needs unknown symbol crc7_be
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251_spi.ko
needs unknown symbol ieee80211_queue_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_queue_stopped
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_stop_tx_ba_session
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_start_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol regulatory_hint
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_restart_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_wake_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol __ieee80211_get_tx_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_get_tx_rates
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_stop_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol wiphy_to_ieee80211_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_queue_delayed_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_sta_block_awake
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_rx
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_free_txskb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_stop_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol __ieee80211_get_assoc_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
needs unknown symbol ieee80211_queue_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544_i2c.ko needs
unknown symbol nfc_fw_download_done
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544_i2c.ko needs
unknown symbol crc_ccitt
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544_i2c.ko needs
unknown symbol nfc_hci_recv_frame
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/suni.ko
needs unknown symbol atm_dev_signal_change
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/suni.ko
needs unknown symbol sonet_subtract_stats
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/suni.ko
needs unknown symbol sonet_copy_stats
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol ieee80211_get_response_rate
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol __ieee80211_get_radio_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol ieee80211_generic_frame_duration
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol ieee80211_wake_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol __ieee80211_get_tx_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol wiphy_rfkill_set_hw_state
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol __ieee80211_get_rx_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol ieee80211_queue_delayed_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol ieee80211_ctstoself_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol ieee80211_stop_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol __ieee80211_get_assoc_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol wiphy_rfkill_start_polling
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol ieee80211_hdrlen
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol ieee80211_rts_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol ieee80211_queue_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
needs unknown symbol ieee80211_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_hci_set_clientdata
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_hci_get_param
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_hci_send_cmd_async
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_add_se
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_tm_data_received
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_hci_unregister_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_hci_free_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_get_local_general_bytes
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_hci_register_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_hci_target_discovered
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_set_remote_general_bytes
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_hci_send_cmd
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_hci_get_clientdata
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_tm_activated
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_find_se
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_hci_allocate_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_hci_set_param
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_dep_link_is_up
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn544/pn544.ko needs
unknown symbol nfc_hci_send_event
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/cifs/cifs.ko needs
unknown symbol __fscache_read_or_alloc_pages
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/cifs/cifs.ko needs
unknown symbol __fscache_readpages_cancel
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/cifs/cifs.ko needs
unknown symbol __fscache_relinquish_cookie
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/cifs/cifs.ko needs
unknown symbol __fscache_unregister_netfs
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/cifs/cifs.ko needs
unknown symbol __fscache_maybe_release_page
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/cifs/cifs.ko needs
unknown symbol __fscache_uncache_all_inode_pages
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/cifs/cifs.ko needs
unknown symbol __fscache_read_or_alloc_page
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/cifs/cifs.ko needs
unknown symbol __fscache_uncache_page
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/cifs/cifs.ko needs
unknown symbol __fscache_register_netfs
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/cifs/cifs.ko needs
unknown symbol __fscache_write_page
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/cifs/cifs.ko needs
unknown symbol __fscache_wait_on_page_write
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/cifs/cifs.ko needs
unknown symbol __fscache_acquire_cookie
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/zatm.ko
needs unknown symbol atm_dev_deregister
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/zatm.ko
needs unknown symbol atm_dev_register
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/zatm.ko
needs unknown symbol atm_charge
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_start_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_start_tx_ba_session
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol regulatory_hint
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol __ieee80211_create_tpt_led_trigger
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_get_hdrlen_from_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_get_buffered_bc
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol wiphy_rfkill_set_hw_state
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_stop_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol wiphy_to_ieee80211_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_queue_delayed_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol wiphy_rfkill_stop_polling
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_rx
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_tx_status
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol wiphy_rfkill_start_polling
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_iterate_active_interfaces_atomic
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_hdrlen
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
needs unknown symbol ieee80211_queue_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/zd1201.ko needs
unknown symbol ieee80211_frequency_to_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/usb/atm/cxacru.ko needs
unknown symbol atm_dev_signal_change
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl8192se/rtl8192se.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl8192se/rtl8192se.ko
needs unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ipw2x00/libipw.ko
needs unknown symbol lib80211_crypt_info_init
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ipw2x00/libipw.ko
needs unknown symbol wiphy_new
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ipw2x00/libipw.ko
needs unknown symbol lib80211_get_crypto_ops
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ipw2x00/libipw.ko
needs unknown symbol lib80211_crypt_info_free
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ipw2x00/libipw.ko
needs unknown symbol lib80211_crypt_delayed_deinit
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ipw2x00/libipw.ko
needs unknown symbol wiphy_free
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/litelink-sir.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bfusb.ko needs
unknown symbol hci_free_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bfusb.ko needs
unknown symbol hci_alloc_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bfusb.ko needs
unknown symbol bt_info
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bfusb.ko needs
unknown symbol bt_err
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bfusb.ko needs
unknown symbol hci_unregister_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bfusb.ko needs
unknown symbol hci_recv_frame
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bfusb.ko needs
unknown symbol hci_register_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/dtl1_cs.ko needs
unknown symbol hci_free_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/dtl1_cs.ko needs
unknown symbol hci_alloc_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/dtl1_cs.ko needs
unknown symbol bt_err
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/dtl1_cs.ko needs
unknown symbol hci_unregister_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/dtl1_cs.ko needs
unknown symbol hci_recv_frame
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/dtl1_cs.ko needs
unknown symbol hci_register_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/toim3232-sir.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/afs/kafs.ko needs
unknown symbol rxrpc_kernel_abort_call
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/afs/kafs.ko needs
unknown symbol rxrpc_kernel_get_abort_code
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/afs/kafs.ko needs
unknown symbol rxrpc_kernel_begin_call
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/afs/kafs.ko needs
unknown symbol rxrpc_kernel_accept_call
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/afs/kafs.ko needs
unknown symbol rxrpc_kernel_data_delivered
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/afs/kafs.ko needs
unknown symbol key_type_rxrpc
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/afs/kafs.ko needs
unknown symbol rxrpc_kernel_is_data_last
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/afs/kafs.ko needs
unknown symbol rxrpc_kernel_intercept_rx_messages
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/afs/kafs.ko needs
unknown symbol rxrpc_get_null_key
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/afs/kafs.ko needs
unknown symbol rxrpc_kernel_free_skb
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/afs/kafs.ko needs
unknown symbol rxrpc_kernel_send_data
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/afs/kafs.ko needs
unknown symbol rxrpc_kernel_end_call
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/afs/kafs.ko needs
unknown symbol rxrpc_kernel_reject_call
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/afs/kafs.ko needs
unknown symbol rxrpc_kernel_get_error_number
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/nsc-ircc.ko needs
unknown symbol alloc_irdadev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/nsc-ircc.ko needs
unknown symbol irlap_open
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/nsc-ircc.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/nsc-ircc.ko needs
unknown symbol async_unwrap_char
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/nsc-ircc.ko needs
unknown symbol irlap_close
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/nsc-ircc.ko needs
unknown symbol irda_device_set_media_busy
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/nsc-ircc.ko needs
unknown symbol irda_setup_dma
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/nsc-ircc.ko needs
unknown symbol async_wrap_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/nsc-ircc.ko needs
unknown symbol irda_init_max_qos_capabilies
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/old_belkin-sir.ko
needs unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/stir4200.ko needs
unknown symbol alloc_irdadev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/stir4200.ko needs
unknown symbol irlap_open
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/stir4200.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/stir4200.ko needs
unknown symbol async_unwrap_char
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/stir4200.ko needs
unknown symbol irlap_close
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/stir4200.ko needs
unknown symbol irda_device_set_media_busy
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/stir4200.ko needs
unknown symbol async_wrap_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/stir4200.ko needs
unknown symbol irda_init_max_qos_capabilies
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_connection_loss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_sched_scan_stopped
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_chswitch_done
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_probereq_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_ap_probereq_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_nullfunc_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_pspoll_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_restart_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_get_hdrlen_from_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_stop_rx_ba_session
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_wake_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol wiphy_to_ieee80211_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_queue_delayed_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_proberesp_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_remain_on_channel_expired
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_rx
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_report_low_ack
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_iterate_active_interfaces
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_free_txskb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol rfc1042_header
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_tx_status
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_stop_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_ready_on_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol cfg80211_find_ie
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_sched_scan_results
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_scan_completed
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_iterate_active_interfaces_atomic
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_hdrlen
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_cqm_rssi_notify
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_frequency_to_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_queue_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol ieee80211_sta_ps_transition
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
needs unknown symbol cfg80211_find_vendor_ie
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/sir-dev.ko needs
unknown symbol alloc_irdadev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/sir-dev.ko needs
unknown symbol irlap_open
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/sir-dev.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/sir-dev.ko needs
unknown symbol async_unwrap_char
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/sir-dev.ko needs
unknown symbol irlap_close
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/sir-dev.ko needs
unknown symbol irda_device_set_media_busy
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/sir-dev.ko needs
unknown symbol async_wrap_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/sir-dev.ko needs
unknown symbol irda_init_max_qos_capabilies
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas/libertas.ko
needs unknown symbol cfg80211_scan_done
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas/libertas.ko
needs unknown symbol regulatory_hint
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas/libertas.ko
needs unknown symbol cfg80211_disconnected
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas/libertas.ko
needs unknown symbol wiphy_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas/libertas.ko
needs unknown symbol wiphy_new
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas/libertas.ko
needs unknown symbol cfg80211_put_bss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas/libertas.ko
needs unknown symbol cfg80211_inform_bss_width
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas/libertas.ko
needs unknown symbol ieee80211_bss_get_ie
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas/libertas.ko
needs unknown symbol cfg80211_ibss_joined
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas/libertas.ko
needs unknown symbol cfg80211_michael_mic_failure
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas/libertas.ko
needs unknown symbol cfg80211_connect_result
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas/libertas.ko
needs unknown symbol wiphy_unregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas/libertas.ko
needs unknown symbol cfg80211_get_bss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas/libertas.ko
needs unknown symbol __ieee80211_get_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas/libertas.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas/libertas.ko
needs unknown symbol wiphy_free
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas/libertas.ko
needs unknown symbol ieee80211_get_num_supported_channels
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol ieee80211_beacon_loss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol regulatory_hint
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol ieee80211_get_hdrlen_from_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol __ieee80211_get_radio_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol crc_ccitt
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol ieee80211_wake_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol __ieee80211_get_tx_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol wiphy_rfkill_set_hw_state
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol __ieee80211_get_rx_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol ieee80211_queue_delayed_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol ieee80211_free_txskb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol ieee80211_stop_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol __ieee80211_get_assoc_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol ieee80211_frequency_to_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54common.ko
needs unknown symbol ieee80211_rx_irqsafe
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/net/vxlan.ko
needs unknown symbol udp_sock_create4
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/net/vxlan.ko
needs unknown symbol udp_tunnel6_xmit_skb
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/net/vxlan.ko
needs unknown symbol udp_tunnel_sock_release
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/net/vxlan.ko
needs unknown symbol setup_udp_tunnel_sock
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/net/vxlan.ko
needs unknown symbol udp_sock_create6
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/net/vxlan.ko
needs unknown symbol udp_tunnel_xmit_skb
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/adummy.ko
needs unknown symbol atm_dev_signal_change
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/adummy.ko
needs unknown symbol atm_dev_deregister
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/adummy.ko
needs unknown symbol atm_dev_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/hostap/hostap_cs.ko
needs unknown symbol lib80211_crypt_info_init
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/hostap/hostap_cs.ko
needs unknown symbol lib80211_crypt_info_free
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/hamradio/bpqether.ko needs
unknown symbol ax25_header_ops
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/hamradio/bpqether.ko needs
unknown symbol ax25_defaddr
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/hamradio/bpqether.ko needs
unknown symbol ax25_bcast
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/iphase.ko
needs unknown symbol atm_dev_deregister
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/iphase.ko
needs unknown symbol atm_dev_register
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/iphase.ko
needs unknown symbol atm_alloc_charge
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_stop_tx_ba_session
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_get_tkip_p1k_iv
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_start_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_report_wowlan_wakeup
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_chswitch_done
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_get_tkip_p2k
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_start_tx_ba_session
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol __ieee80211_create_tpt_led_trigger
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_restart_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_rate_control_unregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol __ieee80211_get_radio_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_wake_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_get_key_tx_seq
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_iter_keys
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_get_key_rx_seq
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol wiphy_rfkill_set_hw_state
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_enable_rssi_reports
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_stop_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_ave_rssi
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_sta_block_awake
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_rx
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_rate_control_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_napi_add
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_free_txskb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_tx_status
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_stop_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_get_tkip_rx_p1k
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_scan_completed
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol rate_control_send_low
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_resume_disconnect
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_hdrlen
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_request_smps
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
needs unknown symbol ieee80211_disable_rssi_reports
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_getattr_dotl
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_wstat
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_open
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_rename
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_remove
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_renameat
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_fcreate
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_is_proto_dotu
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_disconnect
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_attach
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9stat_free
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_create
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_setattr
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_xattrwalk
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_destroy
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_unlinkat
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_mkdir_dotl
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_xattrcreate
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_create_dotl
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_lock_dotl
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_write
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_walk
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_read
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_fsync
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9dirent_read
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_symlink
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_readlink
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_is_proto_dotl
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_clunk
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9stat_read
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_statfs
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_link
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_stat
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_begin_disconnect
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_getlock_dotl
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_readdir
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/9p/9p.ko needs
unknown symbol p9_client_mknod_dotl
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/hamradio/hdlcdrv.ko needs
unknown symbol ax25_header_ops
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/hamradio/hdlcdrv.ko needs
unknown symbol crc_ccitt
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/hamradio/hdlcdrv.ko needs
unknown symbol ax25_defaddr
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/hamradio/hdlcdrv.ko needs
unknown symbol ax25_bcast
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl12xx/wl12xx.ko
needs unknown symbol ieee80211_queue_delayed_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_scan_done
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_remain_on_channel_expired
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol ieee80211_amsdu_to_8023s
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol regulatory_hint
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_new_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_disconnected
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_ready_on_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_classify8021d
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol wiphy_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol wiphy_new
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_put_bss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_inform_bss_width
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_tdls_oper_request
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol ieee80211_bss_get_ie
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_ibss_joined
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_michael_mic_failure
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_connect_result
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol wiphy_unregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_get_bss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol __ieee80211_get_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol rfc1042_header
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_mgmt_tx_status
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_find_ie
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_del_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_rx_mgmt
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol ieee80211_frequency_to_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol bridge_tunnel_header
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_find_vendor_ie
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol wiphy_free
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mwifiex/mwifiex.ko
needs unknown symbol cfg80211_cqm_rssi_notify
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_osdc_build_request
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_create_snap_context
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_create_client
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_osdc_put_request
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol osd_req_op_cls_response_data_pages
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_copy_from_page_vector
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_put_snap_context
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_monc_wait_osdmap
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol libceph_compatible
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol osd_req_op_alloc_hint_init
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_osdc_set_request_linger
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_osdc_flush_notifies
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_osdc_cancel_event
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_release_page_vector
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_pagelist_append
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol osd_req_op_cls_request_data_pages
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_monc_do_get_version
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol osd_req_op_watch_init
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_pg_pool_name_by_id
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_osdc_start_request
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_compare_options
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_osdc_create_event
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_monc_request_next_osdmap
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol osd_req_op_extent_init
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_osdc_alloc_request
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_pg_poolid_by_name
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol osd_req_op_init
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_get_snap_context
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_osdc_cancel_request
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol osd_req_op_extent_osd_data_pages
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_destroy_client
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_alloc_page_vector
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_client_id
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol osd_req_op_cls_request_data_pagelist
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol osd_req_op_cls_init
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_parse_options
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_open_session
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol osd_req_op_raw_data_in_pages
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol ceph_destroy_options
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/block/rbd.ko
needs unknown symbol osd_req_op_extent_osd_data_bio
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/girbil-sir.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_stop_tx_ba_session
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_start_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_chswitch_done
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_get_tkip_p2k
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_start_tx_ba_session
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_restart_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_rate_control_unregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_wake_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol wiphy_rfkill_set_hw_state
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_stop_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_sta_block_awake
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_rx
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_rate_control_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_stop_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol rate_control_send_low
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
needs unknown symbol ieee80211_hdrlen
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/dsa/mv88e6xxx_drv.ko needs
unknown symbol register_switch_driver
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/dsa/mv88e6xxx_drv.ko needs
unknown symbol dsa_host_dev_to_mii_bus
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/dsa/mv88e6xxx_drv.ko needs
unknown symbol unregister_switch_driver
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ipw2x00/ipw2100.ko
needs unknown symbol wiphy_rfkill_set_hw_state
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ipw2x00/ipw2100.ko
needs unknown symbol wiphy_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ipw2x00/ipw2100.ko
needs unknown symbol wiphy_unregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/isdn/gigaset/gigaset.ko needs
unknown symbol crc_ccitt_table
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/hostap/hostap.ko
needs unknown symbol lib80211_get_crypto_ops
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/hostap/hostap.ko
needs unknown symbol lib80211_crypt_delayed_deinit
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/irda-usb.ko needs
unknown symbol alloc_irdadev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/irda-usb.ko needs
unknown symbol irlap_open
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/irda-usb.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/irda-usb.ko needs
unknown symbol irlap_close
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/irda-usb.ko needs
unknown symbol irda_device_set_media_busy
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/irda-usb.ko needs
unknown symbol irda_init_max_qos_capabilies
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_get_response_rate
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_get_tkip_p1k_iv
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol __ieee80211_get_radio_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_generic_frame_duration
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_wake_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol __ieee80211_get_tx_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol wiphy_rfkill_set_hw_state
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol __ieee80211_get_rx_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_queue_delayed_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_ctstoself_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_rx
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_free_txskb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_tx_status
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_stop_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol __ieee80211_get_assoc_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol wiphy_rfkill_start_polling
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_hdrlen
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_rts_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/b43/b43.ko needs
unknown symbol ieee80211_queue_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/isdn/i4l/isdnhdlc.ko needs
unknown symbol crc_ccitt_table
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/btrfs/btrfs.ko
needs unknown symbol raid6_2data_recov
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/btrfs/btrfs.ko
needs unknown symbol raid6_datap_recov
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/btrfs/btrfs.ko
needs unknown symbol raid6_call
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bpa10x.ko needs
unknown symbol hci_free_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bpa10x.ko needs
unknown symbol hci_alloc_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bpa10x.ko needs
unknown symbol bt_err
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bpa10x.ko needs
unknown symbol hci_unregister_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bpa10x.ko needs
unknown symbol hci_recv_frame
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bpa10x.ko needs
unknown symbol hci_register_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_sched_scan_results
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_scan_done
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_sched_scan_stopped
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_remain_on_channel_expired
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_new_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_disconnected
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_ready_on_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_classify8021d
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_crit_proto_stopped
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol wiphy_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol __cfg80211_alloc_reply_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol wiphy_new
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_put_bss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_roamed
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_inform_bss_width
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_ibss_joined
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_michael_mic_failure
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol wiphy_apply_custom_regulatory
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_connect_result
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol wiphy_unregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol __ieee80211_get_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_vendor_cmd_reply
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_mgmt_tx_status
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_unregister_wdev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_del_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_rx_mgmt
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol cfg80211_get_p2p_attr
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol ieee80211_frequency_to_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
needs unknown symbol wiphy_free
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol regulatory_hint
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_ctstoself_duration
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_get_hdrlen_from_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_generic_frame_duration
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_wake_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol __ieee80211_get_tx_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_get_buffered_bc
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_get_tx_rates
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol wiphy_rfkill_set_hw_state
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol __ieee80211_get_rx_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol wiphy_to_ieee80211_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_queue_delayed_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_rx
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_free_txskb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_tx_status
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_stop_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_iterate_active_interfaces_atomic
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_hdrlen
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_frequency_to_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_queue_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
needs unknown symbol ieee80211_rts_duration
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_sched_scan_results
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_cqm_txe_notify
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_scan_done
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_sched_scan_stopped
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_remain_on_channel_expired
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol regulatory_hint
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_roamed_bss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_new_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_disconnected
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_ready_on_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol wiphy_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol wiphy_new
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_put_bss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_ch_switch_notify
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_inform_bss_width
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_ibss_joined
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_michael_mic_failure
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_connect_result
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol wiphy_unregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_get_bss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol __ieee80211_get_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_pmksa_candidate_notify
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_mgmt_tx_status
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_check_station_change
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_find_ie
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_del_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_rx_mgmt
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_chandef_create
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol cfg80211_conn_failed
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath6kl/ath6kl_core.ko
needs unknown symbol wiphy_free
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/firestream.ko needs
unknown symbol atm_pcr_goal
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/firestream.ko needs
unknown symbol atm_dev_deregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/firestream.ko needs
unknown symbol atm_dev_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/arch/x86/crypto/glue_helper.ko needs
unknown symbol __fentry__
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn533.ko
needs unknown symbol nfc_unregister_device
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn533.ko
needs unknown symbol nfc_allocate_device
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn533.ko
needs unknown symbol nfc_tm_data_received
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn533.ko
needs unknown symbol nfc_tm_deactivated
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn533.ko
needs unknown symbol nfc_alloc_recv_skb
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn533.ko
needs unknown symbol nfc_get_local_general_bytes
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn533.ko
needs unknown symbol nfc_set_remote_general_bytes
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn533.ko
needs unknown symbol nfc_tm_activated
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn533.ko
needs unknown symbol nfc_targets_found
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn533.ko
needs unknown symbol nfc_dep_link_is_up
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/pn533.ko
needs unknown symbol nfc_register_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ethernet/via/via-velocity.ko
needs unknown symbol crc_ccitt
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ieee802154/at86rf230.ko
needs unknown symbol ieee802154_register_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ieee802154/at86rf230.ko
needs unknown symbol ieee802154_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ieee802154/at86rf230.ko
needs unknown symbol ieee802154_free_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ieee802154/at86rf230.ko
needs unknown symbol ieee802154_alloc_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ieee802154/at86rf230.ko
needs unknown symbol ieee802154_unregister_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/port100.ko needs unknown
symbol nfc_digital_allocate_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/port100.ko needs unknown
symbol nfc_digital_free_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/port100.ko needs unknown
symbol nfc_digital_register_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/port100.ko needs unknown
symbol nfc_digital_unregister_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/isdn/gigaset/bas_gigaset.ko
needs unknown symbol crc_ccitt_table
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/horizon.ko needs unknown
symbol atm_pcr_goal
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/horizon.ko needs unknown
symbol atm_dev_deregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/horizon.ko needs unknown
symbol atm_dev_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/horizon.ko needs unknown
symbol atm_alloc_charge
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00usb.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00usb.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/kingsun-sir.ko needs
unknown symbol alloc_irdadev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/kingsun-sir.ko needs
unknown symbol irlap_open
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/kingsun-sir.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/kingsun-sir.ko needs
unknown symbol async_unwrap_char
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/kingsun-sir.ko needs
unknown symbol irlap_close
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/kingsun-sir.ko needs
unknown symbol irda_device_set_media_busy
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/kingsun-sir.ko needs
unknown symbol async_wrap_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/kingsun-sir.ko needs
unknown symbol irda_init_max_qos_capabilies
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas_tf/libertas_tf.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas_tf/libertas_tf.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas_tf/libertas_tf.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas_tf/libertas_tf.ko
needs unknown symbol ieee80211_get_buffered_bc
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas_tf/libertas_tf.ko
needs unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas_tf/libertas_tf.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas_tf/libertas_tf.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas_tf/libertas_tf.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas_tf/libertas_tf.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/libertas_tf/libertas_tf.ko
needs unknown symbol ieee80211_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/hci_vhci.ko needs
unknown symbol hci_free_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/hci_vhci.ko needs
unknown symbol hci_alloc_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/hci_vhci.ko needs
unknown symbol bt_info
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/hci_vhci.ko needs
unknown symbol bt_err
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/hci_vhci.ko needs
unknown symbol hci_unregister_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/hci_vhci.ko needs
unknown symbol hci_recv_frame
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/hci_vhci.ko needs
unknown symbol hci_register_dev
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/crypto/lz4hc.ko needs
unknown symbol lz4hc_compress
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/infiniband/hw/nes/iw_nes.ko
needs unknown symbol crc32c
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btmrvl.ko needs
unknown symbol hci_free_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btmrvl.ko needs
unknown symbol hci_alloc_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btmrvl.ko needs
unknown symbol bt_err
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btmrvl.ko needs
unknown symbol hci_unregister_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btmrvl.ko needs
unknown symbol hci_register_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btmrvl.ko needs
unknown symbol __hci_cmd_sync
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/zd1211rw/zd1211rw.ko
needs unknown symbol ieee80211_queue_stopped
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/zd1211rw/zd1211rw.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/zd1211rw/zd1211rw.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/zd1211rw/zd1211rw.ko
needs unknown symbol regulatory_hint
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/zd1211rw/zd1211rw.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/zd1211rw/zd1211rw.ko
needs unknown symbol ieee80211_get_buffered_bc
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/zd1211rw/zd1211rw.ko
needs unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/zd1211rw/zd1211rw.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/zd1211rw/zd1211rw.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/zd1211rw/zd1211rw.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/zd1211rw/zd1211rw.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/zd1211rw/zd1211rw.ko
needs unknown symbol ieee80211_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_common.ko
needs unknown symbol ieee80211_get_hdrlen_from_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath9k/ath9k_common.ko
needs unknown symbol ieee80211_hdrlen
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/mcp2120-sir.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/usb/gadget/function/usb_f_phonet.ko
needs unknown symbol phonet_header_ops
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_hci_set_clientdata
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_hci_get_param
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_hci_send_cmd_async
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol crc_ccitt
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_tm_data_received
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_hci_result_to_errno
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_hci_unregister_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_hci_sak_to_protocol
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_hci_free_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_get_local_general_bytes
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_hci_register_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_set_remote_general_bytes
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_hci_send_cmd
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_hci_get_clientdata
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_tm_activated
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_hci_allocate_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_hci_set_param
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_targets_found
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_dep_link_is_up
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread.ko
needs unknown symbol nfc_hci_send_event
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wan/x25_asy.ko needs
unknown symbol lapb_data_received
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wan/x25_asy.ko needs
unknown symbol lapb_disconnect_request
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wan/x25_asy.ko needs
unknown symbol lapb_unregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wan/x25_asy.ko needs
unknown symbol lapb_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wan/x25_asy.ko needs
unknown symbol lapb_data_request
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wan/x25_asy.ko needs
unknown symbol lapb_connect_request
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/mcs7780.ko needs
unknown symbol alloc_irdadev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/mcs7780.ko needs
unknown symbol irlap_open
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/mcs7780.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/mcs7780.ko needs
unknown symbol crc_ccitt
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/mcs7780.ko needs
unknown symbol async_unwrap_char
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/mcs7780.ko needs
unknown symbol irlap_close
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/mcs7780.ko needs
unknown symbol async_wrap_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/mcs7780.ko needs
unknown symbol irda_init_max_qos_capabilies
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/adm8211.ko needs
unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/adm8211.ko needs
unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/adm8211.ko needs
unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/adm8211.ko needs
unknown symbol ieee80211_wake_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/adm8211.ko needs
unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/adm8211.ko needs
unknown symbol ieee80211_stop_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/adm8211.ko needs
unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/adm8211.ko needs
unknown symbol ieee80211_hdrlen
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/adm8211.ko needs
unknown symbol ieee80211_frequency_to_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/adm8211.ko needs
unknown symbol ieee80211_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl8723be/rtl8723be.ko
needs unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btmrvl_sdio.ko needs
unknown symbol hci_suspend_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btmrvl_sdio.ko needs
unknown symbol hci_resume_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btmrvl_sdio.ko needs
unknown symbol bt_info
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btmrvl_sdio.ko needs
unknown symbol bt_err
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btmrvl_sdio.ko needs
unknown symbol hci_recv_frame
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ali-ircc.ko needs
unknown symbol alloc_irdadev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ali-ircc.ko needs
unknown symbol irlap_open
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ali-ircc.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ali-ircc.ko needs
unknown symbol async_unwrap_char
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ali-ircc.ko needs
unknown symbol irlap_close
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ali-ircc.ko needs
unknown symbol irda_device_set_media_busy
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ali-ircc.ko needs
unknown symbol irda_setup_dma
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ali-ircc.ko needs
unknown symbol async_wrap_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ali-ircc.ko needs
unknown symbol irda_init_max_qos_capabilies
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/esi-sir.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/lanai.ko
needs unknown symbol atm_pcr_goal
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/lanai.ko
needs unknown symbol atm_dev_deregister
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/lanai.ko
needs unknown symbol atm_dev_register
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/lanai.ko
needs unknown symbol atm_alloc_charge
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/lanai.ko
needs unknown symbol vcc_sklist_lock
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/md/persistent-data/dm-persistent-data.ko
needs unknown symbol crc32c
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/nicstar.ko needs unknown
symbol atm_pcr_goal
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/nicstar.ko needs unknown
symbol atm_dev_deregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/nicstar.ko needs unknown
symbol atm_dev_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/nicstar.ko needs unknown
symbol atm_charge
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/usb/cdc-phonet.ko needs
unknown symbol phonet_header_ops
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/rtl8192e/rtllib_crypt_tkip.ko
needs unknown symbol lib80211_unregister_crypto_ops
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/rtl8192e/rtllib_crypt_tkip.ko
needs unknown symbol lib80211_register_crypto_ops
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/hci_uart.ko needs
unknown symbol hci_free_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/hci_uart.ko needs
unknown symbol hci_alloc_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/hci_uart.ko needs
unknown symbol bt_info
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/hci_uart.ko needs
unknown symbol bt_err
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/hci_uart.ko needs
unknown symbol hci_unregister_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/hci_uart.ko needs
unknown symbol hci_recv_frame
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/hci_uart.ko needs
unknown symbol hci_register_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/hci_uart.ko needs
unknown symbol hci_recv_stream_fragment
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
needs unknown symbol ieee80211_restart_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
needs unknown symbol ieee80211_rate_control_unregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
needs unknown symbol ieee80211_wake_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
needs unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
needs unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
needs unknown symbol wiphy_rfkill_set_hw_state
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
needs unknown symbol ieee80211_rx
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
needs unknown symbol ieee80211_rate_control_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
needs unknown symbol ieee80211_stop_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
needs unknown symbol rate_control_send_low
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
needs unknown symbol ieee80211_hdrlen
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ppp/ppp_async.ko needs
unknown symbol crc_ccitt_table
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath.ko needs
unknown symbol reg_initiator_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath.ko needs
unknown symbol wiphy_apply_custom_regulatory
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath.ko needs
unknown symbol __ieee80211_get_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ath.ko needs
unknown symbol freq_reg_info
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wcn36xx/wcn36xx.ko
needs unknown symbol ieee80211_start_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wcn36xx/wcn36xx.ko
needs unknown symbol ieee80211_connection_loss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wcn36xx/wcn36xx.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wcn36xx/wcn36xx.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wcn36xx/wcn36xx.ko
needs unknown symbol ieee80211_start_tx_ba_session
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wcn36xx/wcn36xx.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wcn36xx/wcn36xx.ko
needs unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wcn36xx/wcn36xx.ko
needs unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wcn36xx/wcn36xx.ko
needs unknown symbol ieee80211_stop_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wcn36xx/wcn36xx.ko
needs unknown symbol ieee80211_proberesp_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wcn36xx/wcn36xx.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wcn36xx/wcn36xx.ko
needs unknown symbol ieee80211_free_txskb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wcn36xx/wcn36xx.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wcn36xx/wcn36xx.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wcn36xx/wcn36xx.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wcn36xx/wcn36xx.ko
needs unknown symbol ieee80211_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl8188ee/rtl8188ee.ko
needs unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/nfcwilink.ko needs unknown
symbol nci_free_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/nfcwilink.ko needs unknown
symbol nci_allocate_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/nfcwilink.ko needs unknown
symbol nci_register_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/nfcwilink.ko needs unknown
symbol nci_unregister_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/nfcwilink.ko needs unknown
symbol nci_recv_frame
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ppp/pptp.ko needs unknown
symbol gre_del_protocol
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ppp/pptp.ko needs unknown
symbol gre_add_protocol
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/mtd/devices/docg3.ko needs
unknown symbol init_bch
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/mtd/devices/docg3.ko needs
unknown symbol decode_bch
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/mtd/devices/docg3.ko needs
unknown symbol free_bch
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol cfg80211_scan_done
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol cfg80211_new_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol cfg80211_disconnected
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol cfg80211_inform_bss_width_frame
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol wiphy_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol wiphy_new
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol cfg80211_put_bss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol ieee80211_bss_get_ie
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol cfg80211_get_drvinfo
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol cfg80211_connect_result
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol wiphy_unregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol cfg80211_get_bss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol __ieee80211_get_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol cfg80211_mgmt_tx_status
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol cfg80211_find_ie
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol cfg80211_del_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol cfg80211_rx_mgmt
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol cfg80211_chandef_create
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/wil6210/wil6210.ko
needs unknown symbol wiphy_free
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/crypto/lz4.ko needs
unknown symbol lz4_compress
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/ath3k.ko needs
unknown symbol bt_err
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/usb/atm/speedtch.ko needs
unknown symbol atm_dev_signal_change
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/rtl8192e/rtllib.ko
needs unknown symbol lib80211_crypt_info_init
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/rtl8192e/rtllib.ko
needs unknown symbol lib80211_get_crypto_ops
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/rtl8192e/rtllib.ko
needs unknown symbol lib80211_crypt_info_free
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/rtl8192e/rtllib.ko
needs unknown symbol lib80211_crypt_delayed_deinit
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/rtl8192e/rtllib_crypt_wep.ko
needs unknown symbol lib80211_unregister_crypto_ops
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/rtl8192e/rtllib_crypt_wep.ko
needs unknown symbol lib80211_register_crypto_ops
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/mtd/nand/nand_bch.ko needs
unknown symbol init_bch
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/mtd/nand/nand_bch.ko needs
unknown symbol decode_bch
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/mtd/nand/nand_bch.ko needs
unknown symbol free_bch
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/mtd/nand/nand_bch.ko needs
unknown symbol encode_bch
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/w83977af_ir.ko needs
unknown symbol alloc_irdadev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/w83977af_ir.ko needs
unknown symbol irlap_open
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/w83977af_ir.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/w83977af_ir.ko needs
unknown symbol async_unwrap_char
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/w83977af_ir.ko needs
unknown symbol irlap_close
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/w83977af_ir.ko needs
unknown symbol irda_device_set_media_busy
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/w83977af_ir.ko needs
unknown symbol irda_setup_dma
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/w83977af_ir.ko needs
unknown symbol async_wrap_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/w83977af_ir.ko needs
unknown symbol irda_init_max_qos_capabilies
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/atmtcp.ko
needs unknown symbol atm_dev_deregister
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/atmtcp.ko
needs unknown symbol vcc_hash
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/atmtcp.ko
needs unknown symbol atm_dev_register
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/atmtcp.ko
needs unknown symbol atm_init_aal5
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/atmtcp.ko
needs unknown symbol atm_dev_lookup
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/atmtcp.ko
needs unknown symbol register_atm_ioctl
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/atmtcp.ko
needs unknown symbol deregister_atm_ioctl
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/atmtcp.ko
needs unknown symbol atm_alloc_charge
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/atmtcp.ko
needs unknown symbol vcc_insert_socket
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/atmtcp.ko
needs unknown symbol vcc_sklist_lock
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/hostap/hostap_pci.ko
needs unknown symbol lib80211_crypt_info_init
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/hostap/hostap_pci.ko
needs unknown symbol lib80211_crypt_info_free
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwlegacy.ko
needs unknown symbol ieee80211_chswitch_done
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwlegacy.ko
needs unknown symbol __ieee80211_create_tpt_led_trigger
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwlegacy.ko
needs unknown symbol __ieee80211_get_radio_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwlegacy.ko
needs unknown symbol ieee80211_wake_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwlegacy.ko
needs unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwlegacy.ko
needs unknown symbol wiphy_rfkill_set_hw_state
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwlegacy.ko
needs unknown symbol ieee80211_scan_completed
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwlegacy.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlegacy/iwlegacy.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/idt77252.ko needs unknown
symbol atm_pcr_goal
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/idt77252.ko needs unknown
symbol atm_dev_deregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/idt77252.ko needs unknown
symbol atm_dev_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/idt77252.ko needs unknown
symbol atm_charge
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ieee802154/fakelb.ko needs
unknown symbol ieee802154_register_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ieee802154/fakelb.ko needs
unknown symbol ieee802154_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ieee802154/fakelb.ko needs
unknown symbol ieee802154_free_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ieee802154/fakelb.ko needs
unknown symbol ieee802154_alloc_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ieee802154/fakelb.ko needs
unknown symbol ieee802154_unregister_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol ieee80211_queue_stopped
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol ieee80211_ctstoself_duration
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol __ieee80211_get_radio_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol ieee80211_generic_frame_duration
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol __ieee80211_get_tx_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol wiphy_rfkill_set_hw_state
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol __ieee80211_get_rx_led_name
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol ieee80211_queue_delayed_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol wiphy_rfkill_stop_polling
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol wiphy_rfkill_start_polling
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol ieee80211_frequency_to_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol ieee80211_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
needs unknown symbol ieee80211_rts_duration
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ksdazzle-sir.ko needs
unknown symbol alloc_irdadev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ksdazzle-sir.ko needs
unknown symbol irlap_open
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ksdazzle-sir.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ksdazzle-sir.ko needs
unknown symbol async_unwrap_char
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ksdazzle-sir.ko needs
unknown symbol irlap_close
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ksdazzle-sir.ko needs
unknown symbol irda_device_set_media_busy
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ksdazzle-sir.ko needs
unknown symbol async_wrap_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ksdazzle-sir.ko needs
unknown symbol irda_init_max_qos_capabilies
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol ieee80211_get_hdrlen_from_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol ieee80211_wake_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol ieee80211_get_buffered_bc
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol wiphy_rfkill_set_hw_state
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol ieee80211_queue_delayed_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol wiphy_rfkill_stop_polling
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol ieee80211_ctstoself_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol ieee80211_rx
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol ieee80211_iterate_active_interfaces
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol ieee80211_free_txskb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol ieee80211_tx_status
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol ieee80211_stop_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol wiphy_rfkill_start_polling
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol ieee80211_iterate_active_interfaces_atomic
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol ieee80211_rts_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
needs unknown symbol ieee80211_queue_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2800lib.ko
needs unknown symbol ieee80211_start_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2800lib.ko
needs unknown symbol crc_ccitt
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2800lib.ko
needs unknown symbol ieee80211_stop_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/mtd/nand/diskonchip.ko needs
unknown symbol decode_rs16
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/mtd/nand/diskonchip.ko needs
unknown symbol init_rs
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/mtd/nand/diskonchip.ko needs
unknown symbol free_rs
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btuart_cs.ko needs
unknown symbol hci_free_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btuart_cs.ko needs
unknown symbol hci_alloc_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btuart_cs.ko needs
unknown symbol bt_err
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btuart_cs.ko needs
unknown symbol hci_unregister_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btuart_cs.ko needs
unknown symbol hci_recv_frame
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btuart_cs.ko needs
unknown symbol hci_register_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/ambassador.ko needs
unknown symbol atm_pcr_goal
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/ambassador.ko needs
unknown symbol atm_dev_deregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/ambassador.ko needs
unknown symbol atm_dev_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/ambassador.ko needs
unknown symbol atm_charge
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/firewire/firewire-core.ko
needs unknown symbol crc_itu_t
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/isdn/hisax/hisax.ko needs
unknown symbol crc_ccitt_table
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt73usb.ko
needs unknown symbol crc_itu_t_table
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt73usb.ko
needs unknown symbol crc_itu_t
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/eni.ko
needs unknown symbol atm_pcr_goal
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/eni.ko
needs unknown symbol atm_dev_deregister
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/eni.ko
needs unknown symbol vcc_hash
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/eni.ko
needs unknown symbol atm_dev_register
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/eni.ko
needs unknown symbol atm_alloc_charge
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/atm/eni.ko
needs unknown symbol vcc_sklist_lock
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_probereq_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_beacon_loss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_nullfunc_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_pspoll_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_get_hdrlen_from_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_queue_delayed_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_rx
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_tx_status
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_scan_completed
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_hdrlen
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_cqm_rssi_notify
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_frequency_to_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
needs unknown symbol ieee80211_queue_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/wl3501_cs.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/at76c50x-usb.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/at76c50x-usb.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/at76c50x-usb.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/at76c50x-usb.ko
needs unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/at76c50x-usb.ko
needs unknown symbol ieee80211_queue_delayed_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/at76c50x-usb.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/at76c50x-usb.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/at76c50x-usb.ko
needs unknown symbol cfg80211_find_ie
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/at76c50x-usb.ko
needs unknown symbol ieee80211_scan_completed
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/at76c50x-usb.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/at76c50x-usb.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/at76c50x-usb.ko
needs unknown symbol ieee80211_queue_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/at76c50x-usb.ko
needs unknown symbol ieee80211_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wan/hdlc_x25.ko needs
unknown symbol lapb_data_received
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wan/hdlc_x25.ko needs
unknown symbol lapb_disconnect_request
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wan/hdlc_x25.ko needs
unknown symbol lapb_unregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wan/hdlc_x25.ko needs
unknown symbol lapb_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wan/hdlc_x25.ko needs
unknown symbol lapb_data_request
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wan/hdlc_x25.ko needs
unknown symbol lapb_connect_request
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ma600-sir.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt61pci.ko
needs unknown symbol crc_itu_t_table
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt61pci.ko
needs unknown symbol crc_itu_t
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/block/drbd/drbd.ko needs
unknown symbol lc_seq_printf_stats
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/block/drbd/drbd.ko needs
unknown symbol lc_get_cumulative
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/block/drbd/drbd.ko needs
unknown symbol lc_del
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/block/drbd/drbd.ko needs
unknown symbol lc_committed
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/block/drbd/drbd.ko needs
unknown symbol lc_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/block/drbd/drbd.ko needs
unknown symbol lc_try_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/block/drbd/drbd.ko needs
unknown symbol lc_element_by_index
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/block/drbd/drbd.ko needs
unknown symbol lc_create
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/block/drbd/drbd.ko needs
unknown symbol lc_try_lock
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/block/drbd/drbd.ko needs
unknown symbol lc_destroy
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/block/drbd/drbd.ko needs
unknown symbol lc_reset
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/block/drbd/drbd.ko needs
unknown symbol lc_is_used
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/block/drbd/drbd.ko needs
unknown symbol crc32c
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/block/drbd/drbd.ko needs
unknown symbol lc_seq_dump_details
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/block/drbd/drbd.ko needs
unknown symbol lc_put
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/block/drbd/drbd.ko needs
unknown symbol lc_find
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/microread/microread_i2c.ko
needs unknown symbol nfc_hci_recv_frame
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/nfcsim.ko
needs unknown symbol nfc_unregister_device
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/nfcsim.ko
needs unknown symbol nfc_allocate_device
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/nfcsim.ko
needs unknown symbol nfc_tm_data_received
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/nfcsim.ko
needs unknown symbol nfc_get_local_general_bytes
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/nfcsim.ko
needs unknown symbol nfc_set_remote_general_bytes
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/nfcsim.ko
needs unknown symbol nfc_tm_activated
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/nfcsim.ko
needs unknown symbol nfc_targets_found
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/nfcsim.ko
needs unknown symbol nfc_dep_link_is_up
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/drivers/nfc/nfcsim.ko
needs unknown symbol nfc_register_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bcm203x.ko needs
unknown symbol bt_err
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/wlan-ng/prism2_usb.ko
needs unknown symbol cfg80211_scan_done
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/wlan-ng/prism2_usb.ko
needs unknown symbol cfg80211_disconnected
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/wlan-ng/prism2_usb.ko
needs unknown symbol wiphy_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/wlan-ng/prism2_usb.ko
needs unknown symbol wiphy_new
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/wlan-ng/prism2_usb.ko
needs unknown symbol cfg80211_put_bss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/wlan-ng/prism2_usb.ko
needs unknown symbol cfg80211_roamed
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/wlan-ng/prism2_usb.ko
needs unknown symbol cfg80211_inform_bss_width
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/wlan-ng/prism2_usb.ko
needs unknown symbol cfg80211_connect_result
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/wlan-ng/prism2_usb.ko
needs unknown symbol wiphy_unregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/wlan-ng/prism2_usb.ko
needs unknown symbol __ieee80211_get_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/wlan-ng/prism2_usb.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/wlan-ng/prism2_usb.ko
needs unknown symbol ieee80211_frequency_to_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/staging/wlan-ng/prism2_usb.ko
needs unknown symbol wiphy_free
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/crypto/async_tx/async_pq.ko needs
unknown symbol raid6_gfexp
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/crypto/async_tx/async_pq.ko needs
unknown symbol raid6_call
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/crypto/async_tx/async_pq.ko needs
unknown symbol raid6_empty_zero_page
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8180/rtl818x_pci.ko
needs unknown symbol ieee80211_queue_stopped
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8180/rtl818x_pci.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8180/rtl818x_pci.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8180/rtl818x_pci.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8180/rtl818x_pci.ko
needs unknown symbol ieee80211_ctstoself_duration
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8180/rtl818x_pci.ko
needs unknown symbol ieee80211_generic_frame_duration
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8180/rtl818x_pci.ko
needs unknown symbol ieee80211_wake_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8180/rtl818x_pci.ko
needs unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8180/rtl818x_pci.ko
needs unknown symbol ieee80211_stop_queue
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8180/rtl818x_pci.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8180/rtl818x_pci.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8180/rtl818x_pci.ko
needs unknown symbol ieee80211_frequency_to_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8180/rtl818x_pci.ko
needs unknown symbol ieee80211_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtl818x/rtl8180/rtl818x_pci.ko
needs unknown symbol ieee80211_rts_duration
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/vlsi_ir.ko needs
unknown symbol alloc_irdadev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/vlsi_ir.ko needs
unknown symbol irlap_open
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/vlsi_ir.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/vlsi_ir.ko needs
unknown symbol crc_ccitt
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/vlsi_ir.ko needs
unknown symbol irlap_close
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/vlsi_ir.ko needs
unknown symbol irda_device_set_media_busy
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/vlsi_ir.ko needs
unknown symbol async_wrap_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/vlsi_ir.ko needs
unknown symbol irda_init_max_qos_capabilies
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00pci.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rt2x00/rt2x00pci.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ks959-sir.ko needs
unknown symbol alloc_irdadev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ks959-sir.ko needs
unknown symbol irlap_open
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ks959-sir.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ks959-sir.ko needs
unknown symbol async_unwrap_char
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ks959-sir.ko needs
unknown symbol irlap_close
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ks959-sir.ko needs
unknown symbol irda_device_set_media_busy
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ks959-sir.ko needs
unknown symbol async_wrap_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/ks959-sir.ko needs
unknown symbol irda_init_max_qos_capabilies
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/nfc/mei_phy.ko needs unknown
symbol nfc_hci_recv_frame
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ti/wl1251/wl1251_sdio.ko
needs unknown symbol ieee80211_queue_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/smsc-ircc2.ko needs
unknown symbol alloc_irdadev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/smsc-ircc2.ko needs
unknown symbol irlap_open
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/smsc-ircc2.ko needs
unknown symbol irda_qos_bits_to_value
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/smsc-ircc2.ko needs
unknown symbol async_unwrap_char
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/smsc-ircc2.ko needs
unknown symbol irlap_close
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/smsc-ircc2.ko needs
unknown symbol irda_device_set_media_busy
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/smsc-ircc2.ko needs
unknown symbol irda_setup_dma
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/smsc-ircc2.ko needs
unknown symbol async_wrap_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/irda/smsc-ircc2.ko needs
unknown symbol irda_init_max_qos_capabilies
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/solos-pci.ko needs unknown
symbol atm_dev_signal_change
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/solos-pci.ko needs unknown
symbol atm_dev_deregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/solos-pci.ko needs unknown
symbol vcc_hash
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/solos-pci.ko needs unknown
symbol atm_dev_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/solos-pci.ko needs unknown
symbol atm_charge
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/atm/solos-pci.ko needs unknown
symbol vcc_sklist_lock
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol cfg80211_scan_done
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol cfg80211_wext_siwfrag
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol cfg80211_wext_giwrts
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol cfg80211_wext_giwscan
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol cfg80211_wext_giwname
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol cfg80211_wext_giwmode
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol cfg80211_wext_giwrange
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol wiphy_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol wiphy_new
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol cfg80211_put_bss
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol cfg80211_wext_siwrts
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol cfg80211_inform_bss_width
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol cfg80211_wext_giwfrag
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol wiphy_unregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol __ieee80211_get_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol cfg80211_wext_siwmode
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol cfg80211_find_ie
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol cfg80211_wext_giwretry
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol cfg80211_wext_siwscan
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol ieee80211_frequency_to_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/orinoco/orinoco.ko
needs unknown symbol wiphy_free
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/mtd/nand/cafe_nand.ko needs
unknown symbol decode_rs16
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/mtd/nand/cafe_nand.ko needs
unknown symbol init_rs_non_canonical
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/mtd/nand/cafe_nand.ko needs
unknown symbol free_rs
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wimax/i2400m/i2400m.ko
needs unknown symbol wimax_msg
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wimax/i2400m/i2400m.ko
needs unknown symbol wimax_dev_rm
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wimax/i2400m/i2400m.ko
needs unknown symbol wimax_dev_add
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wimax/i2400m/i2400m.ko
needs unknown symbol wimax_msg_alloc
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wimax/i2400m/i2400m.ko
needs unknown symbol wimax_report_rfkill_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wimax/i2400m/i2400m.ko
needs unknown symbol wimax_state_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wimax/i2400m/i2400m.ko
needs unknown symbol wimax_msg_data_len
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wimax/i2400m/i2400m.ko
needs unknown symbol wimax_msg_send
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wimax/i2400m/i2400m.ko
needs unknown symbol wimax_state_change
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wimax/i2400m/i2400m.ko
needs unknown symbol wimax_msg_data
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wimax/i2400m/i2400m.ko
needs unknown symbol wimax_report_rfkill_sw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wimax/i2400m/i2400m.ko
needs unknown symbol wimax_dev_init
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/mtd/nand/docg4.ko needs
unknown symbol init_bch
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/mtd/nand/docg4.ko needs
unknown symbol decode_bch
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/mtd/nand/docg4.ko needs
unknown symbol free_bch
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ieee802154/mrf24j40.ko
needs unknown symbol ieee802154_register_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ieee802154/mrf24j40.ko
needs unknown symbol ieee802154_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ieee802154/mrf24j40.ko
needs unknown symbol ieee802154_free_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ieee802154/mrf24j40.ko
needs unknown symbol ieee802154_alloc_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/ieee802154/mrf24j40.ko
needs unknown symbol ieee802154_unregister_device
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_start_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_probereq_get
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol regulatory_hint
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_get_tx_rates
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_stop_tx_ba_cb_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_queue_delayed_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol wiphy_apply_custom_regulatory
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_remain_on_channel_expired
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_iterate_active_interfaces
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_free_txskb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_ready_on_channel
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_scan_completed
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_iterate_active_interfaces_atomic
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_beacon_get_tim
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_radar_detected
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_csa_is_complete
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_csa_finish
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/mac80211_hwsim.ko
needs unknown symbol ieee80211_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/hamradio/6pack.ko needs
unknown symbol ax25_hard_header
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/hamradio/6pack.ko needs
unknown symbol ax25_rebuild_header
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/hamradio/6pack.ko needs
unknown symbol ax25_defaddr
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/hamradio/6pack.ko needs
unknown symbol ax25_bcast
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/iwlwifi.ko
needs unknown symbol ieee80211_channel_to_frequency
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/iwlwifi/iwlwifi.ko
needs unknown symbol ieee80211_hdrlen
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl_usb.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl_usb.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl_usb.ko
needs unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl_usb.ko
needs unknown symbol ieee80211_rx
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl_usb.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/arch/x86/crypto/aes-x86_64.ko needs
unknown symbol __fentry__
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btsdio.ko needs
unknown symbol hci_free_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btsdio.ko needs
unknown symbol hci_alloc_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btsdio.ko needs
unknown symbol bt_info
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btsdio.ko needs
unknown symbol hci_unregister_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btsdio.ko needs
unknown symbol hci_recv_frame
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/btsdio.ko needs
unknown symbol hci_register_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/dsa/mv88e6060.ko needs
unknown symbol register_switch_driver
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/dsa/mv88e6060.ko needs
unknown symbol dsa_host_dev_to_mii_bus
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/dsa/mv88e6060.ko needs
unknown symbol unregister_switch_driver
depmod: WARNING: /lib/modules/3.18.0-rc1+/kernel/fs/dlm/dlm.ko needs
unknown symbol sctp_do_peeloff
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/crypto/async_tx/async_raid6_recov.ko
needs unknown symbol raid6_2data_recov
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/crypto/async_tx/async_raid6_recov.ko
needs unknown symbol raid6_gfexi
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/crypto/async_tx/async_raid6_recov.ko
needs unknown symbol raid6_gfmul
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/crypto/async_tx/async_raid6_recov.ko
needs unknown symbol raid6_gfinv
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/crypto/async_tx/async_raid6_recov.ko
needs unknown symbol raid6_gfexp
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/crypto/async_tx/async_raid6_recov.ko
needs unknown symbol raid6_datap_recov
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/crypto/async_tx/async_raid6_recov.ko
needs unknown symbol raid6_empty_zero_page
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl8192cu/rtl8192cu.ko
needs unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/rtlwifi/rtl8192cu/rtl8192cu.ko
needs unknown symbol ieee80211_rx
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/p54/p54usb.ko
needs unknown symbol ieee80211_restart_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ar5523/ar5523.ko
needs unknown symbol ieee80211_free_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ar5523/ar5523.ko
needs unknown symbol ieee80211_alloc_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ar5523/ar5523.ko
needs unknown symbol ieee80211_register_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ar5523/ar5523.ko
needs unknown symbol ieee80211_get_hdrlen_from_skb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ar5523/ar5523.ko
needs unknown symbol ieee80211_find_sta
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ar5523/ar5523.ko
needs unknown symbol ieee80211_tx_status_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ar5523/ar5523.ko
needs unknown symbol ieee80211_queue_delayed_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ar5523/ar5523.ko
needs unknown symbol ieee80211_wake_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ar5523/ar5523.ko
needs unknown symbol ieee80211_free_txskb
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ar5523/ar5523.ko
needs unknown symbol ieee80211_stop_queues
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ar5523/ar5523.ko
needs unknown symbol ieee80211_unregister_hw
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ar5523/ar5523.ko
needs unknown symbol ieee80211_queue_work
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ath/ar5523/ar5523.ko
needs unknown symbol ieee80211_rx_irqsafe
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/appletalk/ipddp.ko needs
unknown symbol atrtr_get_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/appletalk/ipddp.ko needs
unknown symbol aarp_send_ddp
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/appletalk/ipddp.ko needs
unknown symbol atalk_find_dev_addr
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ipw2x00/ipw2200.ko
needs unknown symbol cfg80211_wext_giwname
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ipw2x00/ipw2200.ko
needs unknown symbol wiphy_rfkill_set_hw_state
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ipw2x00/ipw2200.ko
needs unknown symbol wiphy_register
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/net/wireless/ipw2x00/ipw2200.ko
needs unknown symbol wiphy_unregister
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bt3c_cs.ko needs
unknown symbol hci_free_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bt3c_cs.ko needs
unknown symbol hci_alloc_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bt3c_cs.ko needs
unknown symbol bt_info
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bt3c_cs.ko needs
unknown symbol bt_err
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bt3c_cs.ko needs
unknown symbol hci_unregister_dev
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bt3c_cs.ko needs
unknown symbol hci_recv_frame
depmod: WARNING:
/lib/modules/3.18.0-rc1+/kernel/drivers/bluetooth/bt3c_cs.ko needs
unknown symbol hci_register_dev


                          Albino
                          binoanb.eti.br
