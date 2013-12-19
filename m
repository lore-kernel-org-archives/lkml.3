Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab3LSXwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:52:06 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36813 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab3LSXwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:52:03 -0500
Date: Thu, 19 Dec 2013 18:52:01 -0500 (EST)
Message-Id: <20131219.185201.2268644156166690269.davem@davemloft.net>
To: rashika.kheria@gmail.com
Cc: linux-kernel@vger.kernel.org, himanshu.madhani@qlogic.com,
        rajesh.borundia@qlogic.com, shahed.shaikh@qlogic.com,
        jitendra.kalsaria@qlogic.com, sony.chacko@qlogic.com,
        sucheta.chakraborty@qlogic.com, linux-driver@qlogic.com,
        netdev@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH v3 1/8] drivers: net: Mark functions as static in
 qlcnic_io.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
References: <e03d2664d5490bf7af673fc66b83a9684c8758ed.1386911123.git.rashika.kheria@gmail.com>
	<04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 19 Dec 2013 15:52:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBJNqIwu008806

From: Rashika Kheria <rashika.kheria@gmail.com>
Date: Thu, 19 Dec 2013 14:17:27 +0530

> This patch marks the function qlcnic_enable_tx_intr(),
> qlcnic_83xx_enable_tx_intr() and qlcnic_83xx_disable_tx_intr() in
> qlcnic_io.c as static because they are not used outside this file.
> 
> Thus, it also removes the following warnings in
> ethernet/qlogic/qlcnic/qlcnic_io.c:
> 
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c:130:13: warning: no previous prototype for ¡qlcnic_enable_tx_intr¢ [-Wmissing-prototypes]
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c:147:13: warning: no previous prototype for ¡qlcnic_83xx_enable_tx_intr¢ [-Wmissing-prototypes]
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c:153:13: warning: no previous prototype for ¡qlcnic_83xx_disable_tx_intr¢ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
