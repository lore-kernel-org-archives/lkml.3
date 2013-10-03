Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab3JCU5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:57:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40151 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab3JCU5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:57:18 -0400
Date: Thu, 03 Oct 2013 16:54:04 -0400 (EDT)
Message-Id: <20131003.165404.1304983997786923256.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-10-03
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131003201023.GC3142@tuxdriver.com>
References: <20131003201023.GC3142@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 03 Oct 2013 13:57:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 3 Oct 2013 16:10:24 -0400

> Here is another batch of fixes intended for the 3.12 stream...
> 
> For the mac80211 bits, Johannes says:
> 
> "This time I have two fixes for IBSS (including one for wext, hah), a fix
> for extended rates IEs, an active monitor checking fix and a sysfs
> registration race fix."
> 
> On top of those...
> 
> Amitkumar Karwar brings an mwifiex fix for an interrupt loss issue
> w/ SDIO devices.  The problem was due to a command timeout issue
> introduced by an earlier patch.
> 
> Felix Fietkau a stall in the ath9k driver.  This patch fixes the
> regression introduced in the commit "ath9k: use software queues for
> un-aggregated data packets".
> 
> Stanislaw Gruszka reverts an rt2x00 patch that was found to cause
> connection problems with some devices.
> 
> Please let me know if there are problems!

Pulled, thanks John.
