Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaBSVj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:39:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47024 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbaBSVj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:39:56 -0500
Date: Wed, 19 Feb 2014 16:39:53 -0500 (EST)
Message-Id: <20140219.163953.1781109081917971221.davem@davemloft.net>
To: daeseok.youn@gmail.com
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: solos-pci: make solos_bh() as static
From: David Miller <davem@davemloft.net>
In-Reply-To: <1547067.MtNWZjBp8J@daeseok-laptop.cloud.net>
References: <1547067.MtNWZjBp8J@daeseok-laptop.cloud.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2014 13:39:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Wed, 19 Feb 2014 14:13:54 +0900

> From 6297aabeff748777b520cc0ee835af0a3ddc79e2 Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Wed, 19 Feb 2014 10:49:12 +0900
> Subject: [PATCH] atm: solos-pci: make solos_bh() as static
> 
> sparse says:
> 
> drivers/atm/solos-pci.c:763:6: warning:
>  symbol 'solos_bh' was not declared. Should it be static?
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>

Applied.
