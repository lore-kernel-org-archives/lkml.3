Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3DKUUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:20:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38923 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3DKUUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:20:11 -0400
Date: Thu, 11 Apr 2013 16:20:07 -0400 (EDT)
Message-Id: <20130411.162007.896982847089316512.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        buytenh@wantstofly.org, andrew@lunn.ch, jason@lakedaemon.net,
        florian@openwrt.org, sergei.shtylyov@cogentembedded.com,
        benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] net: mv643xx_eth: use managed clk and allocation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1365672574-31123-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1365672574-31123-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 11 Apr 2013 13:20:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Thu, 11 Apr 2013 11:29:32 +0200

> With introduction of common clock framework and the ability to provide
> gated clocks, mv643xx_eth required calls to get and enable these clock
> gates on some platforms. Back then, common clock framework api wasn't
> safe for architectures without support for common clocks. This has
> changed now and there are also managed (devm_) counterparts for clock
> related functions.
> 
> The second patch in this series, also converts kzalloc to devm_kzalloc
> where applicable.
> 
> Both patches have been sent to the corresponding mailing lists as
> individual patches before. To get the order required to apply them right,
> this patch set combines both patches into one set.

Both applied to net-next, thanks.
