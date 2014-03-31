Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaCaPt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:49:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53478 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaCaPtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:49:25 -0400
Message-ID: <53398E84.4050907@infradead.org>
Date: Mon, 31 Mar 2014 08:49:24 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for Mar 31 (netfilter)
References: <20140331190618.ecee9947ade030d7fced05b9@canb.auug.org.au>
In-Reply-To: <20140331190618.ecee9947ade030d7fced05b9@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 01:06 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add material intended for v3.16 to your linux-next included
> branches until after v3.15-rc1 is released.
> 
> This tree still fails (more than usual) the powerpc allyesconfig build.
> 
> Changes since 20140328:
> 

on i386:
CONFIG_IPV6=m


net/built-in.o: In function `tproxy_tg6_v1':
xt_TPROXY.c:(.text+0xb2719): undefined reference to `udp6_lib_lookup'
xt_TPROXY.c:(.text+0xb2d0e): undefined reference to `udp6_lib_lookup'
xt_TPROXY.c:(.text+0xb2f61): undefined reference to `udp6_lib_lookup'
net/built-in.o: In function `tproxy_tg_init':
xt_TPROXY.c:(.init.text+0x28ba): undefined reference to `nf_defrag_ipv6_enable'



-- 
~Randy
