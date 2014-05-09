Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbaEIHiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:38:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41660 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbaEIHix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:38:53 -0400
Date: Fri, 9 May 2014 09:38:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: RFC: A reduced Linux network stack for small systems
Message-ID: <20140509073847.GD4965@xo-6d-61-c0.localdomain>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
 <CAFLxGvww8t-PpuS3B=dFvn8k3xBydk3CgA=qoLyEbkKJZJ0xhQ@mail.gmail.com>
 <1399383246.8767.99.camel@empanada>
 <CAADnVQLYiNfXRrXc=VZkGEFDbNhF63AzPg6Gyu6P1SF=6AiO7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLYiNfXRrXc=VZkGEFDbNhF63AzPg6Gyu6P1SF=6AiO7g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > wants to build it and try it out:
> >
> > https://github.com/tzanussi/meta-galileo/blob/daisy/meta-galileo/README
> >
> > It's very much a work-in-progress with a lot of rough edges, but it is a
> > fully functional system on real hardware (Galileo board/Quark processor)
> > with a usable shell (ps too!) and web server running on a kernel with
> > native networking and ~ 750k text size.
> 
> Intel Galileo datasheet says:
> - 400MHz 32bit Intel
> - 512 KBytes of on-die embedded SRAM
> - 256 MByte DRAM, enabled by the firmware by default
> 
> where did 2-4Mbyte restriction come from?
> 
> Anyway, with all these hacks you get a half functional kernel with "a
> lot of rough edges"
> that is likely working only for the given very limited set of applications.
> Kernel function profiling can potentially achieve the same thing.
> Profile the kernel with the set of apps and then prune all cold
> functions out of kernel.

That does not really work, right? As soon attacker triggers some error path
you did not trigger in testing, your machine dies.

That no longer qualifies as functional kernel.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
