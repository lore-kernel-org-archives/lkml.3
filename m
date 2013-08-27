Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab3H0Tzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:55:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59306 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3H0Tzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:55:54 -0400
Date: Tue, 27 Aug 2013 15:55:52 -0400 (EDT)
Message-Id: <20130827.155552.747451190932124237.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-08-23
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130823162044.GD15114@tuxdriver.com>
References: <20130823162044.GD15114@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 27 Aug 2013 12:55:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 23 Aug 2013 12:20:44 -0400

> This is one more set of fixes intended for the 3.11 stream...
> 
> For the mac80211 bits, Johannes says:
> 
> "I have three more patches for the 3.11 stream: Felix's fix for the
> fairly visible brcmsmac crash, a fix from Simon for an IBSS join bug I
> found and a fix for a channel context bug in IBSS I'd introduced."
> 
> Along with those...
> 
> Sujith Manoharan makes a minor change to not use a PLL hang workaroun
> for AR9550.  This one-liner fixes a couple of bugs reported in the Red Hat
> bugzilla.
> 
> Helmut Schaa addresses an ath9k_htc bug that mangles frame headers
> during Tx.  This fix is small, tested by the bug reported and isolated
> to ath9k_htc.
> 
> Stanislaw Gruszka reverts a recent iwl4965 change that broke rfkill
> notification to user space.
> 
> Please let me know if there are problems!

Pulled, thanks John.
