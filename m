Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaILWSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 18:18:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51993 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaILWSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 18:18:23 -0400
Date: Fri, 12 Sep 2014 18:18:20 -0400 (EDT)
Message-Id: <20140912.181820.1440041146938289489.davem@davemloft.net>
To: mike.looijmans@topic.nl
Cc: f.fainelli@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/phy: micrel: Disable asymmetric pause for
 KSZ9031
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410525637-849-1-git-send-email-mike.looijmans@topic.nl>
References: <5411ECE9.8050600@gmail.com>
	<1410525637-849-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Sep 2014 15:18:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Looijmans <mike.looijmans@topic.nl>
Date: Fri, 12 Sep 2014 14:40:37 +0200

> The KSZ9031 appears to suffer from the same hardware bug as described
> for the KSZ9021 in commit 32fcafbcd1c9f6c7013016a22a5369b4acb93577
> ("net/phy: micrel: Disable asymmetric pause for KSZ9021")
> you have to unplug the cable and plug it back to get it to work.
> 
> Remove the SUPPORTED_Asym_Pause flag for the KSZ9031 to fix this.
> 
> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>

This patch does not apply cleanly to the net tree, please respin.
