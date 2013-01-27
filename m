Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3A0Gjb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 01:39:31 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:55524 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab3A0Gj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 01:39:29 -0500
Date: Sun, 27 Jan 2013 01:39:28 -0500 (EST)
Message-Id: <20130127.013928.1867901911175664439.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-01-23
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130123201605.GC5221@tuxdriver.com>
References: <20130123201605.GC5221@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 23 Jan 2013 15:16:06 -0500

> This is a batch of fixes intende for the 3.8 stream.
> 
> Regarding the iwlwifi bits, Johannes says this:
> 
> "Please pull to get a single fix from Emmanuel for a bug I introduced due
> to misunderstanding the code."
> 
> Regarding the mac80211 bits, Johannes says this:
> 
> "I have a few small fixes for you:
>  * some mesh frames would cause encryption warnings -- fixes from Bob
>  * scanning would pretty much break an association if we transmitted
>    anything to the AP while scanning -- fix from Stanislaw
>  * mode injection was broken by channel contexts -- fix from Felix
>  * FT roaming was broken: hardware crypto would get disabled by it"
> 
> Along with that, a handful of other fixes confined to specific drivers.
> 
> Avinash Patil fixes a typo in a NULL check in mwifiex.
> 
> Larry Finger fixes a build warning in rtlwifi.  Seems safe...
> 
> Stanislaw Gruszka fixes iwlegacy to prevent microcode errors when
> switching from IBSS mode to STA mode.
> 
> Felix Fietkau provides a trio of ath9k fixes related to proper tuning.
> 
> Please let me know if there are problems!

Pulled, thanks John.
