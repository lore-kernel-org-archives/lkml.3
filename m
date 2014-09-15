Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbaIOSY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:24:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36135 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbaIOSY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:24:27 -0400
Date: Mon, 15 Sep 2014 14:24:25 -0400 (EDT)
Message-Id: <20140915.142425.1929538078667151559.davem@davemloft.net>
To: mike.looijmans@topic.nl
Cc: f.fainelli@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net/phy: micrel: Disable asymmetric pause for
 KSZ9031
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410775594-3129-1-git-send-email-mike.looijmans@topic.nl>
References: <20140912.181820.1440041146938289489.davem@davemloft.net>
	<1410775594-3129-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Sep 2014 11:24:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Looijmans <mike.looijmans@topic.nl>
Date: Mon, 15 Sep 2014 12:06:33 +0200

> The KSZ9031 appears to suffer from the same hardware bug as described
> for the KSZ9021 in commit 32fcafbcd1c9f6c7013016a22a5369b4acb93577
> ("net/phy: micrel: Disable asymmetric pause for KSZ9021")
> you have to unplug the cable and plug it back to get it to work.
> 
> Remove the SUPPORTED_Asym_Pause flag for the KSZ9031 to fix this.
> 
> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>

Applied, thanks.
