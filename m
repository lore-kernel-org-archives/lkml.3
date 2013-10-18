Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab3JRRSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:18:16 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41116 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab3JRRSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:18:15 -0400
Message-ID: <1382116693.3284.21.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH] netfilter: fix ordering of jumpstack allocation and
 table update
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Fri, 18 Oct 2013 10:18:13 -0700
In-Reply-To: <20131018165749.GI3296@mudshark.cambridge.arm.com>
References: <1382016273-21993-1-git-send-email-will.deacon@arm.com>
	 <20131018111536.GA11132@localhost>
	 <20131018165749.GI3296@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-18 at 17:57 +0100, Will Deacon wrote:
> Hi Pablo,
> 

> > We also need fixes for net/ipv6/netfilter/ip6_tables.c and
> > net/ipv4/netfilter/arp_tables.c as well. Could you extend this patch
> > and resend?
> 
> Sure, I can try, but that's going to require a bit of time to sit down and
> look at the shared data, access order, dependencies etc. I'm currently
> preparing for Edinburgh, so it might be a while before I get a chance to
> extend this.

That's basically same code copy/pasted, so it should be relatively easy.


