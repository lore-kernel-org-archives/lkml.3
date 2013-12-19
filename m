Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab3LSXwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:52:24 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36829 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab3LSXwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:52:19 -0500
Date: Thu, 19 Dec 2013 18:52:17 -0500 (EST)
Message-Id: <20131219.185217.1184476466384528159.davem@davemloft.net>
To: rashika.kheria@gmail.com
Cc: paul.gortmaker@windriver.com, gregkh@linuxfoundation.org,
        linux@roeck-us.net, sebastian@breakpoint.cc, sachin.kamat@linaro.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH v3 4/8] drivers: net: Include new header file in sbni.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <036b203aec94b1e688b7bd6ad09c72b3d481bf18.1387382457.git.rashika.kheria@gmail.com>
References: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
	<036b203aec94b1e688b7bd6ad09c72b3d481bf18.1387382457.git.rashika.kheria@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 19 Dec 2013 15:52:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBJNqXG5008818

From: Rashika Kheria <rashika.kheria@gmail.com>
Date: Thu, 19 Dec 2013 14:22:37 +0530

> Create a new header file include/net/Space.h which contains
> prototype declaration of sbni_probe().
> 
> Include the new header file in drivers/net/Space.c and
> drivers/net/wan/sbni.c because they use this function.
> 
> This eliminates the following warning in wan/sbni.c:
> drivers/net/wan/sbni.c:224:12: warning: no previous prototype for ¡sbni_probe¢ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
