Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab3J2ETm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 00:19:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40407 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3J2ETl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 00:19:41 -0400
Date: Tue, 29 Oct 2013 00:19:40 -0400 (EDT)
Message-Id: <20131029.001940.738944506900728476.davem@davemloft.net>
To: zwu.kernel@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephen@networkplumber.org, wuzhy@linux.vnet.ibm.com
Subject: Re: [PATCH v2 1/3] vxlan: silence one build warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382940110-10737-1-git-send-email-zwu.kernel@gmail.com>
References: <1382940110-10737-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 28 Oct 2013 21:19:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9T4JqhS009410

From: Zhi Yong Wu <zwu.kernel@gmail.com>
Date: Mon, 28 Oct 2013 14:01:48 +0800

> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> drivers/net/vxlan.c: In function ¡vxlan_sock_add¢:
> drivers/net/vxlan.c:2298:11: warning: ¡sock¢ may be used uninitialized in this function [-Wmaybe-uninitialized]
> drivers/net/vxlan.c:2275:17: note: ¡sock¢ was declared here
>   LD      drivers/net/built-in.o
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Applied to net-next.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
