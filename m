Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762682Ab3JQUGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:06:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46798 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758393Ab3JQUGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:06:22 -0400
Date: Thu, 17 Oct 2013 16:06:20 -0400 (EDT)
Message-Id: <20131017.160620.433147354971362075.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-10-15
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131015175611.GA15706@tuxdriver.com>
References: <20131015175611.GA15706@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 17 Oct 2013 13:06:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 15 Oct 2013 13:56:12 -0400

> Please pull this batch of fixes intended for the 3.12 stream!
> 
> For the mac80211 bits, Johannes says:
> 
> "Jouni fixes a remain-on-channel vs. scan bug, and Felix fixes client TX
> probing on VLANs."
> 
> And also:
> 
> "This time I have two fixes from Emmanuel for RF-kill issues, and fixed
> two issues reported by Evan Huus and Thomas Lindroth respectively."
> 
> On top of those...
> 
> Avinash Patil adds a couple of mwifiex fixes to properly inform cfg80211
> about some different types of disconnects, avoiding WARNINGs.
> 
> Mark Cave-Ayland corrects a pointer arithmetic problem in rtlwifi,
> avoiding incorrect automatic gain calculations.
> 
> Solomon Peachy sends a cw1200 fix for locking around calls to
> cw1200_irq_handler, addressing "lost interrupt" problems.
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.
