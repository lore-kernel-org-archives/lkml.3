Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaJGQ7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:59:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:56258 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbaJGQ7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:59:11 -0400
Message-ID: <54341BD7.3070207@infradead.org>
Date: Tue, 07 Oct 2014 09:59:03 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, dev@openvswitch.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for Oct 7 (openvswitch)
References: <20141007194454.10502188@canb.auug.org.au>
In-Reply-To: <20141007194454.10502188@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/14 01:44, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20141003:
> 

on i386 or x86_64:

In file included from ../include/net/geneve.h:4:0,
                 from ../net/openvswitch/flow_netlink.c:45:
../include/net/udp_tunnel.h: In function 'udp_tunnel_handle_offloads':
../include/net/udp_tunnel.h:100:2: error: implicit declaration of function 'iptunnel_handle_offloads' [-Werror=implicit-function-declaration]
  return iptunnel_handle_offloads(skb, udp_csum, type);
  ^
../include/net/udp_tunnel.h:100:2: warning: return makes pointer from integer without a cast [enabled by default]



-- 
~Randy
