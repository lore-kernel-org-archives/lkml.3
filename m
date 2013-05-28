Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab3E1S4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:56:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab3E1S4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:56:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFz34Hn5xLwJL4PS+agpK-L3fNjNxkcXAS4gNx8tqOOwFQ@mail.gmail.com>
References: <CA+55aFz34Hn5xLwJL4PS+agpK-L3fNjNxkcXAS4gNx8tqOOwFQ@mail.gmail.com> <20130528143409.9790.41260.stgit@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        linux-am33-list@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ken Cox <jkc@redhat.com>
Subject: Re: [PATCH 1/4] MN10300: Fix ret_from_kernel_thread
Date: Tue, 28 May 2013 19:56:03 +0100
Message-ID: <5007.1369767363@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> What kernel version are these patches against?
> 
> You explicitly mention commit ddf23e87a804, but the patch contains
> ret_from_kernel_execve that was *removed* by that commit.
> 
> So the whole thing seems very confused. I'm dropping this series.

Sorry about that.  It seems I pulled your master branch from my upstream tree
rather than your upstream tree.

David
