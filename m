Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbaHAFrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 01:47:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54627 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaHAFrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 01:47:01 -0400
Date: Thu, 31 Jul 2014 22:46:59 -0700 (PDT)
Message-Id: <20140731.224659.1839149761075616147.davem@davemloft.net>
To: tgraf@suug.ch
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        challa@noironetworks.com, walpole@cs.pdx.edu, dev@openvswitch.org,
        tklauser@distanz.ch, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/3 net-next] Lockless netlink_lookup() with new
 concurrent hash table
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140731.223946.2222491319947824077.davem@davemloft.net>
References: <cover.1406846586.git.tgraf@suug.ch>
	<20140731.223946.2222491319947824077.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Jul 2014 22:47:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s715l86r014152

From: David Miller <davem@davemloft.net>
Date: Thu, 31 Jul 2014 22:39:46 -0700 (PDT)

> Looks great, series applied, thanks!

Actually, this needs more work, reverted:

net/netfilter/nft_hash.c: In function ¡nft_hash_destroy¢:
net/netfilter/nft_hash.c:183:3: error: ¡ht¢ undeclared (first use in this function)
net/netfilter/nft_hash.c:183:3: note: each undeclared identifier is reported only once for each function it appears in
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
