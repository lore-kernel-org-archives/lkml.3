Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbaBSVjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:39:52 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47022 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbaBSVjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:39:49 -0500
Date: Wed, 19 Feb 2014 16:39:47 -0500 (EST)
Message-Id: <20140219.163947.1811017443430580104.davem@davemloft.net>
To: daeseok.youn@gmail.com
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: nicstar: use NULL instead of 0 for pointer
From: David Miller <davem@davemloft.net>
In-Reply-To: <1738246.bUPoQjSxLC@daeseok-laptop.cloud.net>
References: <1738246.bUPoQjSxLC@daeseok-laptop.cloud.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2014 13:39:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Wed, 19 Feb 2014 14:12:46 +0900

> From c320d2ea1ed51c88255c33a50c74fa3598ab7be6 Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Wed, 19 Feb 2014 10:10:11 +0900
> Subject: [PATCH] atm: nicstar: use NULL instead of 0 for pointer
> 
> sparse says:
> 
> drivers/atm/nicstar.c:642:27: warning:
>  Using plain integer as NULL pointer
> drivers/atm/nicstar.c:644:27:
>  warning: Using plain integer as NULL pointer
> drivers/atm/nicstar.c:982:51:
>  warning: Using plain integer as NULL pointer
> drivers/atm/nicstar.c:996:51:
>  warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>

Applied.
