Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaAWUpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 15:45:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970AbaAWUpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 15:45:21 -0500
Date: Thu, 23 Jan 2014 15:45:17 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/10] atyfb: remove resolution limit 1600
In-Reply-To: <CAMuHMdVRR4gKrR4Fx1ZMjZTRQXsP0o2o_ySv_gSzjjoM6ZtmCw@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1401231544510.21686@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231302340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231303100.31739@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1401231303460.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231305390.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231306220.31739@file01.intranet.prod.int.rdu2.redhat.com>
 <CAMuHMdVRR4gKrR4Fx1ZMjZTRQXsP0o2o_ySv_gSzjjoM6ZtmCw@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Jan 2014, Geert Uytterhoeven wrote:

> On Thu, Jan 23, 2014 at 7:19 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> > The card works fine in 1980x1080 resolution. Therefore, there is no need
> 
> 1920x1080?

Yes, I meant that.

Mikulas

> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 
