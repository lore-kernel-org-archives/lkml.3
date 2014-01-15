Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaAOXjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:39:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52466 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbaAOXjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 18:39:10 -0500
Message-ID: <52D71C1D.3020609@infradead.org>
Date: Wed, 15 Jan 2014 15:39:09 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 15 (netfilter: nft_reject)
References: <20140115185545.497c14923814b6ecaa540d9f@canb.auug.org.au>
In-Reply-To: <20140115185545.497c14923814b6ecaa540d9f@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 11:55 PM, Stephen Rothwell wrote:
> Hi all,
> 
> This tree fails (more than usual) the powerpc allyesconfig build.
> 
> Changes since 20140114:
> 

on x86_64:
# CONFIG_IPV6 is not enabled.

warning: (NF_TABLES_INET) selects NF_TABLES_IPV6 which has unmet direct dependencies (NET && INET && IPV6 && NETFILTER && NF_TABLES)
...
ERROR: "ip6_dst_hoplimit" [net/netfilter/nft_reject.ko] undefined!
ERROR: "ip6_route_output" [net/netfilter/nft_reject.ko] undefined!
ERROR: "nf_ip6_checksum" [net/netfilter/nft_reject.ko] undefined!



-- 
~Randy
