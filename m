Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3ETG4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:56:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54314 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab3ETG4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:56:16 -0400
Date: Sun, 19 May 2013 23:56:15 -0700 (PDT)
Message-Id: <20130519.235615.1794473948693729339.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: netdev@vger.kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] x86: bpf_jit_comp: secure bpf jit against
 spraying attacks
From: David Miller <davem@davemloft.net>
In-Reply-To: <1368844623.3301.142.camel@edumazet-glaptop>
References: <1368844623.3301.142.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 19 May 2013 23:56:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 17 May 2013 19:37:03 -0700

> From: Eric Dumazet <edumazet@google.com>
> 
> hpa bringed into my attention some security related issues
> with BPF JIT on x86.
> 
> This patch makes sure the bpf generated code is marked read only,
> as other kernel text sections.
> 
> It also splits the unused space (we vmalloc() and only use a fraction of
> the page) in two parts, so that the generated bpf code not starts at a
> known offset in the page, but a pseudo random one.
> 
> Refs:
> http://mainisusuallyafunction.blogspot.com/2012/11/attacking-hardened-linux-systems-with.html
> 
> Reported-by: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied.
