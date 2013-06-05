Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab3FEAPC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 20:15:02 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60520 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab3FEAO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 20:14:58 -0400
Date: Tue, 04 Jun 2013 17:14:56 -0700 (PDT)
Message-Id: <20130604.171456.2052649822776872955.davem@davemloft.net>
To: emilgoode@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, lorenzo@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: ipv6: Fix incompatible pointer type warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1370262068-16658-1-git-send-email-emilgoode@gmail.com>
References: <1370262068-16658-1-git-send-email-emilgoode@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r550F6Ik024027

From: Emil Goode <emilgoode@gmail.com>
Date: Mon,  3 Jun 2013 14:21:08 +0200

> This fixes the sparse warning below about assignment from
> incompatible pointer type.
> 
> In the following commit the third argument in function ipv6_chk_addr
> was changed to const and struct nf_ipv6_ops was introduced with
> the third argument of .chk_addr beeing const.
> 
> 2a7851bffb008ff4882eee673da74718997b4265
> ("netfilter: add nf_ipv6_ops hook to fix xt_addrtype with IPv6")
> 
> The below commit introduced the warning as the third argument of
> dummy_ipv6_chk_addr and .ipv6_chk_addr in struct pingv6_ops is
> missing a const.
> 
> 6d0bfe22611602f36617bc7aa2ffa1bbb2f54c67
> ("net: ipv6: Add IPv6 support to the ping socket.")
> 
> Sparse output:
> 
> net/ipv6/ping.c: In function ¡pingv6_init¢:
> net/ipv6/ping.c:87:27: warning:
> 	assignment from incompatible pointer type [enabled by default]
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>

This only happens when you combine net with net-next, therefore your
patch isn't actually relevent to any real GIT tree.

Please make this very clear in the future.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
