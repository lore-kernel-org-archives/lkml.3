Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab3LRQLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:11:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab3LRQLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:11:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20131217.151656.2218064732946772466.davem@davemloft.net>
References: <20131217.151656.2218064732946772466.davem@davemloft.net> <1386975369-30837-1-git-send-email-khoroshilov@ispras.ru>
To: netdev@vger.kernel.org
Cc: dhowells@redhat.com, khoroshilov@ispras.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RXRPC]: do not unlock unheld spinlock in rxrpc_connect_exclusive()
Date: Wed, 18 Dec 2013 16:10:55 +0000
Message-ID: <29861.1387383055@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

> From: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Date: Sat, 14 Dec 2013 02:56:09 +0400
> 
> > +		_net("CONNECT EXCL old %d on TRANS %d",
> > +		     conn->debug_id, conn->trans->debug_id);
> 
> Please do not add more of these ad-hoc kernel log tracing entries.

Why not?  They're useful for debugging and they give me more control than
plain printk().

I presume you want all the debugging statements in net/rxrpc/ changing to
something else - but what?

David
