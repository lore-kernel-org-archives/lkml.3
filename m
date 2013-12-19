Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab3LSXwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:52:55 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36851 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab3LSXwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:52:51 -0500
Date: Thu, 19 Dec 2013 18:52:49 -0500 (EST)
Message-Id: <20131219.185249.732943424956542038.davem@davemloft.net>
To: rashika.kheria@gmail.com
Cc: ian.campbell@citrix.com, wei.liu2@citrix.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH v3 8/8] drivers: net: Mark function
 xenvif_count_frag_slots() as static in netback.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <72d6fe114ba7cc2f09f51e279313860f83142d46.1387382457.git.rashika.kheria@gmail.com>
References: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
	<72d6fe114ba7cc2f09f51e279313860f83142d46.1387382457.git.rashika.kheria@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 19 Dec 2013 15:52:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBJNr4Id008837

From: Rashika Kheria <rashika.kheria@gmail.com>
Date: Thu, 19 Dec 2013 14:26:47 +0530

> This patch marks the function xenvif_count_frag_slots() in netback.c as
> static because they are not used outside this file.
> 
> Thus, it also removes the following warning in xen-netback/netback.c:
> drivers/net/xen-netback/netback.c:218:14: warning: no previous prototype for ¡xenvif_count_frag_slots¢ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> Acked-by: Ian Campbell <ian.campbell@citrix.com>

This patch doesn't apply cleanly to net-next, please respin.

Thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
