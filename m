Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaGQGbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 02:31:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57769 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaGQGbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 02:31:52 -0400
Date: Wed, 16 Jul 2014 23:31:51 -0700 (PDT)
Message-Id: <20140716.233151.1229307096154836730.davem@davemloft.net>
To: jlayton@primarydata.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH v2] net: clean up some sparse endianness warnings in
 ipv6.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405508146-13004-1-git-send-email-jlayton@primarydata.com>
References: <1405340746-10678-1-git-send-email-jlayton@primarydata.com>
	<1405508146-13004-1-git-send-email-jlayton@primarydata.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Jul 2014 23:31:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Layton <jlayton@primarydata.com>
Date: Wed, 16 Jul 2014 06:55:46 -0400

> sparse is throwing warnings when building sunrpc modules due to some
> endianness shenanigans in ipv6.h. Specifically:
> 
>   CHECK   net/sunrpc/addr.c
> include/net/ipv6.h:573:17: warning: restricted __be64 degrades to integer
> include/net/ipv6.h:577:34: warning: restricted __be32 degrades to integer
> include/net/ipv6.h:573:17: warning: restricted __be64 degrades to integer
> include/net/ipv6.h:577:34: warning: restricted __be32 degrades to integer
> 
> Sprinkle some endianness fixups to silence them. These should all get
> fixed up at compile time, so I don't think this will add any extra work
> to be done at runtime.
> 
> Signed-off-by: Jeff Layton <jlayton@primarydata.com>

Applied, thank you.
