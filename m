Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab3IERhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:37:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57321 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab3IERhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:37:38 -0400
Message-ID: <5228C140.1010504@infradead.org>
Date: Thu, 05 Sep 2013 10:37:04 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: linux-next: Tree for Sep 5 (netfilter: xt_socket.c)
References: <20130905193249.8b7c57afd5e39349ff5508bb@canb.auug.org.au>
In-Reply-To: <20130905193249.8b7c57afd5e39349ff5508bb@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/13 02:32, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add any code for v3.13 to your linux-next included branches
> until after v3.12-rc1 is released.
> 
> Changes since 20130904:
> 

on x86_64:

when CONFIG_IPV6=m
and CONFIG_NETFILTER_XT_MATCH_SOCKET=y:

net/built-in.o: In function `socket_mt6_v1_v2':
xt_socket.c:(.text+0x51b55): undefined reference to `udp6_lib_lookup'
net/built-in.o: In function `socket_mt_init':
xt_socket.c:(.init.text+0x1ef8): undefined reference to `nf_defrag_ipv6_enable'



-- 
~Randy
