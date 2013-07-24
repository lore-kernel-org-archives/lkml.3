Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3GXXpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 19:45:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36510 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3GXXpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 19:45:17 -0400
Date: Wed, 24 Jul 2013 16:45:14 -0700 (PDT)
Message-Id: <20130724.164514.393667021861625699.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: andi@etezian.org, ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: trans_rdma: remove unused function
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374707387.29835.23.camel@x61.thuisdomein>
References: <1374497956-32104-1-git-send-email-andi@etezian.org>
	<20130724.154646.2283898956674234778.davem@davemloft.net>
	<1374707387.29835.23.camel@x61.thuisdomein>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 24 Jul 2013 16:45:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6ONjS1A032461

From: Paul Bolle <pebolle@tiscali.nl>
Date: Thu, 25 Jul 2013 01:09:47 +0200

> On Wed, 2013-07-24 at 15:46 -0700, David Miller wrote:
>> From: Andi Shyti <andi@etezian.org>
>> > This patch gets rid of the following warning:
>> > 
>> > net/9p/trans_rdma.c:594:12: warning: ¡rdma_cancelled¢ defined but not used [-Wunused-function]
>> >  static int rdma_cancelled(struct p9_client *client, struct p9_req_t *req)
>> > 
>> > The rdma_cancelled function is not called anywhere in the kernel
>> > 
>> > Signed-off-by: Andi Shyti <andi@etezian.org>
>> 
>> Applied to net-next, thanks.
> 
> After this patch one might as well revert the rest of commit
> 80b45261a0b2 ("9P: Add cancelled() to the transport functions.") too. It
> seems the entire cancelled callback stuff is now pointless.
> 
> As I already asked in https://lkml.org/lkml/2013/7/15/87 : did that
> commit "forget to actually hook up rdma_cancelled() into
> p9_rdma_trans()?". It does look so to me.

If nobody responds to this in the next day or so, feel free to send me
a patch which rips it all out.

No response means they don't care, and neither, therefore, should we.

Thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
