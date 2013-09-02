Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab3IBUui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 16:50:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758919Ab3IBUuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 16:50:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130902195056.GB32628@leaf>
References: <20130902195056.GB32628@leaf> <9976.1378132260@warthog.procyon.org.uk> <1378138205.1953.66.camel@joe-AO722> <20130902181510.GA29787@leaf> <20130902181856.GB29787@leaf> <20130902153945.6d7e510c@samsung.com> <1378148367.1953.98.camel@joe-AO722>
To: Josh Triplett <josh@joshtriplett.org>
Cc: dhowells@redhat.com, Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about updating Documentation/CodingStyle
Date: Mon, 02 Sep 2013 21:50:23 +0100
Message-ID: <13834.1378155023@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Triplett <josh@joshtriplett.org> wrote:

> > There are many checkpatch rules (like semicolons) that
> > are not in CodingStyle.
> 
> It's a rule of thumb, not a mandate.  In *general*, checkpatch.pl should
> not be enforcing style rules that aren't documented in CodingStyle.

Except that it becomes a mandate when someone runs it automatically against
every one of your patches and then sends you an email for each patch it finds
a checkpatch niggle against...

David
