Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbaBSVjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:39:45 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47010 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaBSVjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:39:44 -0500
Date: Wed, 19 Feb 2014 16:39:42 -0500 (EST)
Message-Id: <20140219.163942.74432949275197405.davem@davemloft.net>
To: daeseok.youn@gmail.com
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: ambassador: use NULL instead of 0 for pointer
From: David Miller <davem@davemloft.net>
In-Reply-To: <4982315.WAlBt88ElR@daeseok-laptop.cloud.net>
References: <4982315.WAlBt88ElR@daeseok-laptop.cloud.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2014 13:39:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Wed, 19 Feb 2014 14:11:15 +0900

> From 932e928d53b1e588dc17019e7f9fa7a61b8b7468 Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Wed, 19 Feb 2014 10:35:41 +0900
> Subject: [PATCH] atm: ambassador: use NULL instead of 0 for pointer
> 
> sparse says:
> 
> drivers/atm/ambassador.c:1928:24: warning:
>  Using plain integer as NULL pointer
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>

Applied.
