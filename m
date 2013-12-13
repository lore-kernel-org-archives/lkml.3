Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab3LMPAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:00:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab3LMPAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:00:48 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <5685.1386945340@warthog.procyon.org.uk>
References: <5685.1386945340@warthog.procyon.org.uk> <CA+55aFy1moQwnV7NVqFyCCZAwXG3z5c8o-mij1isMbv2B0ikNA@mail.gmail.com> <4197.1386708027@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
        keyrings@linux-nfs.org,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] KEYS: Miscellaneous fixes
Date: Fri, 13 Dec 2013 15:00:32 +0000
Message-ID: <28904.1386946832@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Howells <dhowells@redhat.com> wrote:

> >  - build kernel again ("make -j" - nothing has changed):
> > 
> >    ...
> >    X.509 certificate list changed
> 
> Hmmm...  I don't see this.

I take that back.  I do, but only on the first rebuild.  The problem appears
to be that kernel/Makefile does not predict the path of kernel/.x509.list when
it does not exist yet.

David
