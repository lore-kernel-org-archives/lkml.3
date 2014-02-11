Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaBKSO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:14:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37973 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbaBKSOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:14:54 -0500
Message-ID: <52FA689C.7090103@infradead.org>
Date: Tue, 11 Feb 2014 10:14:52 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: linux-next: Tree for Feb 11  (staging/rtl8821ae/)
References: <20140211172136.37976e8c5e7b81ce11f30b34@canb.auug.org.au>
In-Reply-To: <20140211172136.37976e8c5e7b81ce11f30b34@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 10:21 PM, Stephen Rothwell wrote:
> Hi all,
> 
> This tree fails (more than usual) the powerpc allyesconfig build.
> 
> Changes since 20140210:
> 

on i386:

ERROR: "ieee80211_rx_irqsafe" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_beacon_get_tim" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_unregister_hw" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "rate_control_send_low" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_stop_queue" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_rate_control_register" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "wiphy_to_ieee80211_hw" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_stop_tx_ba_cb_irqsafe" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_tx_status_irqsafe" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_find_sta" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_wake_queue" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_rate_control_unregister" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_register_hw" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_start_tx_ba_session" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_alloc_hw" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_free_hw" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_connection_loss" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_start_tx_ba_cb_irqsafe" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!

when CONFIG_MAC80211 is not enabled.
Looks like it should also depend on MAC80211.



-- 
~Randy
