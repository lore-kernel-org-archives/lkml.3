Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab3DWSF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:05:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:49064 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895Ab3DWSFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:05:25 -0400
Message-ID: <5176CD22.6070906@infradead.org>
Date: Tue, 23 Apr 2013 11:04:18 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for Apr 23 (netlink)
References: <20130423180028.e08f92e6cc72105f67b77491@canb.auug.org.au>
In-Reply-To: <20130423180028.e08f92e6cc72105f67b77491@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/13 01:00, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130422:
> 
> The net-next tree lost its build failure but gained another for which I
> applied a patch.
> 


when CONFIG_NETLINK_MMAP is not enabled:

net/netlink/diag.c: In function 'sk_diag_put_rings_cfg':
net/netlink/diag.c:28:17: error: 'struct netlink_sock' has no member named 'pg_vec_lock'
net/netlink/diag.c:29:29: error: 'struct netlink_sock' has no member named 'rx_ring'
net/netlink/diag.c:31:30: error: 'struct netlink_sock' has no member named 'tx_ring'
net/netlink/diag.c:33:19: error: 'struct netlink_sock' has no member named 'pg_vec_lock'


-- 
~Randy
