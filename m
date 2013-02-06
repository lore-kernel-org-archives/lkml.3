Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482Ab3BFTx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:53:29 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42962 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370Ab3BFTxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:53:25 -0500
Date: Wed, 06 Feb 2013 14:53:20 -0500 (EST)
Message-Id: <20130206.145320.721522259467415518.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-02-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130206193423.GI2148@tuxdriver.com>
References: <20130206193423.GI2148@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 6 Feb 2013 14:34:23 -0500

> Please consider this pull request for the 3.8 stream...
> 
> Included is a bluetooth pull.  Gustavo says:
> 
> "Two simple fixes for 3.8. One of the patches fixes a situation
> where the connection wasn't terminated if a timeout ocurrs for LE
> an SCO connections.  The other fixes prevent NULL dereference in the
> SMP code, it is a security fix as well."
> 
> Along with those...
> 
> Hauke Mehrtens provides a couple of ssb and bcma bus fixes that
> prevent oopses when unloading those modules.
> 
> Larry Finger provides and rtlwifi fix to avoid a "scheduling while
> atomic" bug.
> 
> Last but certainly not least, Arend van Spriel bring a brcmsmac fix that
> reworks the mac80211 .flush() callback in order to avoid the dreaded
> brcms_c_wait_for_tx_completion warnings.  This one looks a little
> large, but I think it is safe and isolated to brcmsmac in any case.
> 
> Please let me know if there are problems!

Pulled, even though the comments weren't styled correctly
in the bluetooth fixes.  Please fix that when this stuff
propagates into net-next, thanks.
