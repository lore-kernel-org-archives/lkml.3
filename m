Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbaLUAV7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 19:21:59 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:45551 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaLUAV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 19:21:56 -0500
MIME-Version: 1.0
In-Reply-To: <1419120588-14105-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1419120588-14105-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun, 21 Dec 2014 01:21:34 +0100
Message-ID: <CAFo99ga9L3x0cS1kBfSx2dt2JLi1br=USBGvi9PF7=rSejCQYg@mail.gmail.com>
Subject: Re: [PATCH v2] net: wireless: brcm80211: brcmsmac: phy: phy_cmn.c:
 Remove some unused functions
To: Brett Rudley <brudley@broadcom.com>, Arend van Spriel <arend@broadcom.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Hante Meuleman <meuleman@broadcom.com>, Kalle Valo <kvalo@adurom.com>,
        Fabian Frederick <fabf@skynet.be>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-21 1:09 GMT+01:00 Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se>:
> Removes some functions that are not used anywhere:
> wlc_phy_edcrs_lock() wlc_phy_txpower_ipa_ison() wlc_phy_upd_rssi_offset()
> wlc_phy_get_pwrdet_offsets() wlc_lcnphy_epa_switch() wlc_phy_stf_ssmode_get()
> wlc_phy_stf_chain_get() write_phy_channel_reg() wlc_phy_BSSinit()
> wlc_phy_set_deaf() wlc_phy_freqtrack_end() wlc_phy_freqtrack_start()
> wlc_phy_noise_sample_request_external() wlc_phy_test_ison()
> wlc_phy_txpower_hw_ctrl_set() wlc_phy_bf_preempt_enable()
> wlc_phy_runbist_config() wlc_phy_txpwr_percent_set()
> wlc_phy_txpower_get_target_max() wlc_radioreg_exit()
> wlc_phy_txpower_get_target_min() wlc_phy_txpower_boardlimit_band()
> wlc_phy_txpower_sromlimit_max_get() wlc_radioreg_enter()
> wlc_phy_txpower_target_set() wlc_phy_chanspec_band_firstch()
> wlc_phy_chanspec_bandrange_get() wlc_phy_bw_state_get() wlc_phy_clear_tssi()


Hi

Sorry!  Wrong again :(

wlc_lcnphy_crsuprs () should not be removed from hedder file.
V2 was the same problem with wlc_phy_txpwr_idx_get_nphy()
A new V3 comes in same minute.


Kind regards
Rickard Strandqvist
