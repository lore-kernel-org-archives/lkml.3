Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaAWT0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:26:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbaAWT0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:26:42 -0500
Date: Thu, 23 Jan 2014 14:26:38 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/10] framebuffer patches
In-Reply-To: <CA+55aFykzCSKeXgBEiFTozVqbBvJUiK2bdTDfRO80sqZZS8TXw@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1401231417320.7971@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com> <CA+55aFykzCSKeXgBEiFTozVqbBvJUiK2bdTDfRO80sqZZS8TXw@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Jan 2014, Linus Torvalds wrote:

> Hmm. Is there some reason why these are not going through Tomi? And
> cc'd to linux-fbdev for that matter?
> 
> It's not that I can't apply patches sent directly to me, but quite
> frankly, unless there is a *reason* to not go through the subsystem
> maintainer I don't really want to. Afaik Tomi has been active and
> responsive, but maybe there's some strife I don't know about..
> 
>              Linus

I posted the patches a year ago to the linux-fbdev mailing list 
(http://marc.info/?l=linux-fbdev&r=6&b=201208&w=2) and to Florian Tobias 
Schandinat who was FB maintainer at that time. I didn't get an answer and 
they were ignored.

Mikulas

> On Thu, Jan 23, 2014 at 10:17 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > Here I'm sending some framebuffer patches for matrox, mach64, tga and a
> > fix for copying on vesafb.
> >
> > Mikulas
> 
