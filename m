Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbaBKUNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:13:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaBKUNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:13:15 -0500
Date: Tue, 11 Feb 2014 12:14:30 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Feb 11  (staging/rtl8821ae/)
Message-ID: <20140211201430.GB25722@kroah.com>
References: <20140211172136.37976e8c5e7b81ce11f30b34@canb.auug.org.au>
 <52FA689C.7090103@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FA689C.7090103@infradead.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 10:14:52AM -0800, Randy Dunlap wrote:
> On 02/10/2014 10:21 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > This tree fails (more than usual) the powerpc allyesconfig build.
> > 
> > Changes since 20140210:
> > 
> 
> on i386:
> 
> ERROR: "ieee80211_rx_irqsafe" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
> ERROR: "ieee80211_beacon_get_tim" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
> ERROR: "ieee80211_unregister_hw" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
> ERROR: "rate_control_send_low" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
> ERROR: "ieee80211_stop_queue" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
> ERROR: "ieee80211_rate_control_register" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
> ERROR: "wiphy_to_ieee80211_hw" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
> ERROR: "ieee80211_stop_tx_ba_cb_irqsafe" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
> ERROR: "ieee80211_tx_status_irqsafe" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
> ERROR: "ieee80211_find_sta" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
> ERROR: "ieee80211_wake_queue" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
> ERROR: "ieee80211_rate_control_unregister" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
> ERROR: "ieee80211_register_hw" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
> ERROR: "ieee80211_start_tx_ba_session" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
> ERROR: "ieee80211_alloc_hw" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
> ERROR: "ieee80211_free_hw" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
> ERROR: "ieee80211_connection_loss" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
> ERROR: "ieee80211_start_tx_ba_cb_irqsafe" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
> 
> when CONFIG_MAC80211 is not enabled.
> Looks like it should also depend on MAC80211.

Care to send me a patch?

thanks,

greg k-h
