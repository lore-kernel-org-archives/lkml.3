Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab3LPQks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:40:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab3LPQkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:40:46 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFy1moQwnV7NVqFyCCZAwXG3z5c8o-mij1isMbv2B0ikNA@mail.gmail.com>
References: <CA+55aFy1moQwnV7NVqFyCCZAwXG3z5c8o-mij1isMbv2B0ikNA@mail.gmail.com> <4197.1386708027@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
        keyrings@linux-nfs.org,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] KEYS: Miscellaneous fixes
Date: Mon, 16 Dec 2013 16:40:36 +0000
Message-ID: <22351.1387212036@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Pulled. However, I notice that the following issue remains with module
> key signing, and I *think* it was introduced in the -rc1 pull:

I posted four patches on Friday.  Does:

	[PATCH 1/4] X.509: Fix certificate gathering

fix your problem?

David
