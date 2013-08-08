Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966644Ab3HHVHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:07:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36160 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966588Ab3HHVHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:07:32 -0400
Date: Thu, 08 Aug 2013 14:12:41 -0700 (PDT)
Message-Id: <20130808.141241.2150105195238423513.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-08-08
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130808172940.GC30925@tuxdriver.com>
References: <20130808172940.GC30925@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 08 Aug 2013 14:07:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 8 Aug 2013 13:29:40 -0400

> This is a batch of fixes intended for the 3.11 queue...
> 
> Regarding the mac80211 (and related) bits, Johannes says:
> 
> "I have a fix from Chris for an infinite loop along with fixes from
> myself to prevent it entering the loop to start with (continue using
> disabled channels, many thanks to Chris for his debug/test help) and a
> workaround for broken APs that advertise a bad HT primary channel in
> their beacons. Additionally, a fix for another attrbuf race in mac80211
> and a fix to clean up properly while P2P GO interfaces go down."
> 
> Along with that...
> 
> Solomon Peachy corrects a range check in cw1200 that would lead to
> a BUG_ON when starting AP mode.
> 
> Stanislaw Gruszka provides an iwl4965 patch to power-up the device
> earlier (avoiding microcode errors), and another iwl4965 fix that
> resets the firmware after turning rfkill off (resolving a bug in the
> Red Hat Bugzilla).
> 
> Please let me know if there are problems!

Pulled, thanks John.
