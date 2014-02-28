Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaB1LDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 06:03:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaB1LDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 06:03:11 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140226.140053.115418122553568429.davem@davemloft.net>
References: <20140226.140053.115418122553568429.davem@davemloft.net> <12143.1393436505@warthog.procyon.org.uk>
To: David Miller <davem@davemloft.net>
Cc: dhowells@redhat.com, netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        tim@electronghost.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AF_RXRPC fixes and development
Date: Fri, 28 Feb 2014 11:02:44 +0000
Message-ID: <18115.1393585364@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

> > Here are some AF_RXRPC fixes (to tag rxrpc-20140226):
> 
> You really need to post the patch series along with the pull
> request so that netdev can review your changes.

Okay.  Fengguang's magic box reported some warnings with one of the patches,
which I'll get fixed up first.  Turns out it doesn't like a bunch of __be
values being added together to make a hash value without casts:-/

David
