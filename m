Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3GXWqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:46:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35927 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3GXWqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:46:47 -0400
Date: Wed, 24 Jul 2013 15:46:46 -0700 (PDT)
Message-Id: <20130724.154646.2283898956674234778.davem@davemloft.net>
To: andi@etezian.org
Cc: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: trans_rdma: remove unused function
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374497956-32104-1-git-send-email-andi@etezian.org>
References: <1374497956-32104-1-git-send-email-andi@etezian.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 24 Jul 2013 15:46:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6OMkrg0032246

From: Andi Shyti <andi@etezian.org>
Date: Mon, 22 Jul 2013 14:59:16 +0200

> This patch gets rid of the following warning:
> 
> net/9p/trans_rdma.c:594:12: warning: ¡rdma_cancelled¢ defined but not used [-Wunused-function]
>  static int rdma_cancelled(struct p9_client *client, struct p9_req_t *req)
> 
> The rdma_cancelled function is not called anywhere in the kernel
> 
> Signed-off-by: Andi Shyti <andi@etezian.org>

Applied to net-next, thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
