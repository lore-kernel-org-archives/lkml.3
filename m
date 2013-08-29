Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab3H2SzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:55:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36880 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab3H2SzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:55:19 -0400
Date: Thu, 29 Aug 2013 14:55:13 -0400 (EDT)
Message-Id: <20130829.145513.179529840926907721.davem@davemloft.net>
To: maxime.ripard@free-electrons.com
Cc: jszhang@marvell.com, emilio@elopez.com.ar, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mdio-sun4i: Convert to devm_* api
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130828093508.GQ2695@lukather>
References: <1377522717-5784-1-git-send-email-jszhang@marvell.com>
	<20130828093508.GQ2695@lukather>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 29 Aug 2013 11:55:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Ripard <maxime.ripard@free-electrons.com>
Date: Wed, 28 Aug 2013 11:35:08 +0200

> Hi Jisheng,
> 
> On Mon, Aug 26, 2013 at 09:11:57PM +0800, Jisheng Zhang wrote:
>> Use devm_ioremap_resource instead of of_iomap() and devm_kzalloc()
>> instead of kmalloc() to make cleanup paths simpler. This patch also
>> fixes the resource leak caused by missing corresponding iounamp()
>> of the of_iomap().
>> 
>> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> 
> It looks fine for me.
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Applied to net-next, thanks.
