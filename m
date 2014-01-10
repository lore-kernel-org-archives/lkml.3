Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbaAJRQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 12:16:17 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:54638 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaAJRQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 12:16:15 -0500
Date: Fri, 10 Jan 2014 18:16:13 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: sohny thomas <sohny.kernel@gmail.com>, linux-kernel@vger.kernel.org,
        yoshfuji@linux-ipv6.org, davem@davemloft.net,
        kumuda <kumuda@linux.vnet.ibm.com>, netdev <netdev@vger.kernel.org>
Subject: Re: ipv6: default route for link local address is not added while assigning a address
Message-ID: <20140110171613.GA23647@order.stressinduktion.org>
Mail-Followup-To: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	sohny thomas <sohny.kernel@gmail.com>, linux-kernel@vger.kernel.org,
	yoshfuji@linux-ipv6.org, davem@davemloft.net,
	kumuda <kumuda@linux.vnet.ibm.com>, netdev <netdev@vger.kernel.org>
References: <52CFE594.8010808@gmail.com> <52D020C4.30105@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52D020C4.30105@6wind.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 05:33:08PM +0100, Nicolas Dichtel wrote:
> CC: netdev
> 
> Le 10/01/2014 13:20, sohny thomas a écrit :
> >Default route for link local address is configured automatically if
> >NETWORKING_IPV6=yes is in ifcfg-eth*.
> >When the route table for the interface is flushed and a new address is 
> >added to
> >the same device with out removing linklocal addr, default route for link 
> >local
> >address has to added by default.
> I would say that removing the link local route but not the link local 
> address
> is a configuration problem.
> If you remove a connected route but not the associated address, you will 
> have
> the same problem.

We have some user accessible routes that are essential for IPv6 stack
to work at all. So I don't know if I can agree with that.

Maybe flush is a bit too aggressive?

