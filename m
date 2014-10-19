Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbaJSCP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 22:15:59 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:44965 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaJSCP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 22:15:58 -0400
Date: Sun, 19 Oct 2014 04:15:54 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
Message-ID: <20141019021554.GD22068@x4>
References: <20141018.001844.1317443518545745039.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141018.001844.1317443518545745039.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.10.18 at 00:18 -0400, David Miller wrote:
> 
> Please pull, thanks a lot.

In file included from net/core/sock.c:140:0:
include/net/tcp.h: In function ‘tcp_v6_iif’:
include/net/tcp.h:738:32: error: ‘union <anonymous>’ has no member named ‘h6’
  return TCP_SKB_CB(skb)->header.h6.iif;
                                ^
scripts/Makefile.build:257: recipe for target 'net/core/sock.o' failed
make[2]: *** [net/core/sock.o] Error 1
scripts/Makefile.build:402: recipe for target 'net/core' failed
make[1]: *** [net/core] Error 2
Makefile:936: recipe for target 'net' failed
make: *** [net] Error 2

 │ Symbol: IPV6 [=n]                                                                                                                                                       │
 │ Type  : tristate                                                                                                                                                        │
 │ Prompt: The IPv6 protocol                                                                                                                                               │
 │   Location:                                                                                                                                                             │
 │     -> Networking support (NET [=y])                                                                                                                                    │
 │       -> Networking options                                                                                                                                             │
 │         -> TCP/IP networking (INET [=y])                                                                                                                                │
 │   Defined at net/ipv6/Kconfig:6                                                                                                                                         │
 │   Depends on: NET [=y] && INET [=y]

-- 
Markus
