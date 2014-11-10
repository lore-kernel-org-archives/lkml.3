Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaKJTYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:24:44 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47069 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaKJTYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:24:42 -0500
Date: Mon, 10 Nov 2014 14:24:39 -0500 (EST)
Message-Id: <20141110.142439.2292080248990157625.davem@davemloft.net>
To: rdunlap@infradead.org
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        therbert@google.com
Subject: Re: linux-next: Tree for Nov 10 (net/ipv4/ip_tunnel.c)
From: David Miller <davem@davemloft.net>
In-Reply-To: <546100AF.40201@infradead.org>
References: <20141110205945.51af32a6@canb.auug.org.au>
	<546100AF.40201@infradead.org>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Nov 2014 11:24:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Mon, 10 Nov 2014 10:15:11 -0800

> On 11/10/14 01:59, Stephen Rothwell wrote:
>> Hi all,
>> 
>> Changes since 20141106:
>> 
> 
> on x86_64:
> when CONFIG_NET_IP_TUNNEL=y and CONFIG_NET_FOU=m:
> 
> net/built-in.o: In function `ip_tunnel_encap':
> (.text+0xb04d8): undefined reference to `gue_build_header'
> net/built-in.o: In function `ip_tunnel_encap':
> (.text+0xb04ea): undefined reference to `fou_build_header'

Tom, this has now been reported twice, please fix this.

Thanks.
