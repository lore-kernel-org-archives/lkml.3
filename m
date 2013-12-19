Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab3LSXwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:52:18 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36820 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab3LSXwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:52:13 -0500
Date: Thu, 19 Dec 2013 18:52:12 -0500 (EST)
Message-Id: <20131219.185212.2216925356822187727.davem@davemloft.net>
To: rashika.kheria@gmail.com
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH v3 3/8] drivers: net: Mark functions as static in
 stmmac_platform.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <0f515b300a982f4a2f5a2e00ac08c5f783e81f4d.1387382457.git.rashika.kheria@gmail.com>
References: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
	<0f515b300a982f4a2f5a2e00ac08c5f783e81f4d.1387382457.git.rashika.kheria@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 19 Dec 2013 15:52:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBJNqX3h008815

From: Rashika Kheria <rashika.kheria@gmail.com>
Date: Thu, 19 Dec 2013 14:19:44 +0530

> This patch marks the function stmmac_pltfr_freeze() and
> stmmac_pltfr_restore() in stmmac_platform.c as static because they are
> not used outside this file.
> 
> Thus, it also removes the following warnings in
> ethernet/stmicro/stmmac/stmmac_platform.c:
> 
> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:222:5: warning: no previous prototype for ¡stmmac_pltfr_freeze¢ [-Wmissing-prototypes]
> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:236:5: warning: no previous prototype for ¡stmmac_pltfr_restore¢ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
