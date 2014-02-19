Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbaBSRyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:54:36 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45594 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaBSRyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:54:35 -0500
Date: Wed, 19 Feb 2014 12:54:32 -0500 (EST)
Message-Id: <20140219.125432.903199758409719335.davem@davemloft.net>
To: sergei.shtylyov@cogentembedded.com
Cc: grant.likely@linaro.org, ben.dooks@codethink.co.uk,
        linux-kernel@lists.codethink.co.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] of_mdio: fix phy interrupt passing
From: David Miller <davem@davemloft.net>
In-Reply-To: <5304B14B.2070402@cogentembedded.com>
References: <20140218161551.44A52C40517@trevor.secretlab.ca>
	<20140218.181317.1712776234149210938.davem@davemloft.net>
	<5304B14B.2070402@cogentembedded.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2014 09:54:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Wed, 19 Feb 2014 17:27:39 +0400

>    So, you decided to ignore my comment about unneeded *else* branch?

Not ignored, just figured that a follow-up patch could fix it.
