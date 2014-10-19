Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142AbaJSGFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 02:05:00 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34169 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaJSGE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 02:04:58 -0400
Message-ID: <1413698696.27176.37.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: Upstream kernel build failures in include/net/tcp.h
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sat, 18 Oct 2014 23:04:56 -0700
In-Reply-To: <54434016.2070209@roeck-us.net>
References: <54434016.2070209@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-18 at 21:37 -0700, Guenter Roeck wrote:
> Hi,
> 
> I am getting lots of build failures with the latest upstream kernel.
> 
> In file included from net/core/sock.c:140:0:
> include/net/tcp.h: In function 'tcp_v6_iif':
> include/net/tcp.h:738:32: error: 'union <anonymous>' has no member named 'h6'
> 
> This may have been introduced by 870c3151382 ("ipv6: introduce tcp_v6_iif()").
>  From the context, it looks like it happens if CONFIG_IPV6 is not enabled.
> 
> For details and failed configurations see the 'master' column at
> http://server.roeck-us.net:8010/builders.
> 
> Guenter

I sent the fix this morning, and it is in David net tree

http://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=815afe1785da727ee48cd8e63ac4a3ec6c7459b3

Thanks


