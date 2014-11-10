Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaKJSPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:15:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:60135 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaKJSPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:15:18 -0500
Message-ID: <546100AF.40201@infradead.org>
Date: Mon, 10 Nov 2014 10:15:11 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for Nov 10 (net/ipv4/ip_tunnel.c)
References: <20141110205945.51af32a6@canb.auug.org.au>
In-Reply-To: <20141110205945.51af32a6@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/14 01:59, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20141106:
> 

on x86_64:
when CONFIG_NET_IP_TUNNEL=y and CONFIG_NET_FOU=m:

net/built-in.o: In function `ip_tunnel_encap':
(.text+0xb04d8): undefined reference to `gue_build_header'
net/built-in.o: In function `ip_tunnel_encap':
(.text+0xb04ea): undefined reference to `fou_build_header'



-- 
~Randy
