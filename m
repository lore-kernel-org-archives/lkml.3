Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab3CAU5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:57:31 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33119 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab3CAU5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 15:57:30 -0500
Date: Fri, 01 Mar 2013 15:57:28 -0500 (EST)
Message-Id: <20130301.155728.88068767335721442.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-03-01
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130301192332.GE27114@tuxdriver.com>
References: <20130301192332.GE27114@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 01 Mar 2013 12:57:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 1 Mar 2013 14:23:33 -0500

> This is another flurry of fixes intended for the 3.9 stream...
> 
> A mac80211 pull from Johannes:
> 
> "Seth fixes a stupid bug I introduced into one of his earlier patches,
> Chun-Yeow fixes mesh forwarding and Felix fixes monitor mode. I myself
> fixed a small locking issue and, the biggest change here, removed some
> nl80211 information with which sometimes the per wiphy information was
> getting too large for the typical 4k-minus-overhead. In my -next tree I
> have a patch to allow splitting that and add back the information
> removed now."
> 
> An iwlwifi pull from Johannes:
> 
> "I have a fix for a pretty important bug regarding DMA mapping, that
> could cause the DMA engine to overwrite data we wanted to send to it, so
> that the next time we send it it would be bad. This particularly affects
> calibration results. Other than that, three little fixes for the MVM
> driver."
> 
> But wait, there's more!
> 
> Avinash Patil fixes an incorrectly timed delay in mwifiex.
> 
> Bing Zhao prevents a crash in SD8688 caused by failing to properly
> set a flag before issuing a command.
> 
> Felix Fietkau is the big here this time, providing a trio of minor
> ath9k fixes and correcting the advertised interface combinations for
> rt2x00 when mesh support is disabled.
> 
> Finally, Hauke Mehrtens gives us a patch that correctlin initializes
> a spin lock in the bcma code.
> 
> Please let me know if there are problems!

Pulled, thanks John.
