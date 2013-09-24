Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab3IXBWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 21:22:05 -0400
Received: from tundra.namei.org ([65.99.196.166]:33038 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029Ab3IXBWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 21:22:03 -0400
Date: Tue, 24 Sep 2013 11:23:38 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@parisplace.org>
cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <james.l.morris@oracle.com>,
        Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: Oddness in security/Makefile
In-Reply-To: <1378821492.2493.3.camel@localhost>
Message-ID: <alpine.LRH.2.02.1309241123270.3782@tundra.namei.org>
References: <11543.1378741281@turing-police.cc.vt.edu> <1378821492.2493.3.camel@localhost>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, Eric Paris wrote:

> >From 4675ca3470e3c2e325c5be6d9a11f47ac0917537 Mon Sep 17 00:00:00 2001
> From: Eric Paris <eparis@redhat.com>
> Date: Tue, 10 Sep 2013 09:51:50 -0400
> Subject: [PATCH] security: remove erroneous comment about capabilities.o link
>  ordering
> 
> Back when we had half ass LSM stacking we had to link capabilities.o
> after bigger LSMs so that on initialization the bigger LSM would
> register first and the capabilities module would be the one stacked as
> the 'seconday'.  Somewhere around 6f0f0fd496333777d53 (back in 2008) we
> finally removed the last of the kinda module stacking code but this
> comment in the makefile still lives today.
> 

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next


-- 
James Morris
<jmorris@namei.org>
