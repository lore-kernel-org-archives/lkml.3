Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab3EFVYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:24:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59865 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab3EFVYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 17:24:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pavel Machek <pavel@denx.de>, tglx@linutronix.de
Subject: Re: dw_apb_timer_of.c: remove parts that were picoxcell-specific
Date: Mon, 6 May 2013 23:24:16 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Jamie Iles <jamie@jamieiles.com>, dinguyen@altera.com, wd@denx.de,
        linux-arm-kernel@lists.infradead.org, olof@lixom.net,
        kernel list <linux-kernel@vger.kernel.org>, john.stultz@linaro.org
References: <20130426121433.GA16249@amd.pavel.ucw.cz> <201305061545.22587.arnd@arndb.de> <20130506155304.GA6645@amd.pavel.ucw.cz>
In-Reply-To: <20130506155304.GA6645@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305062324.17080.arnd@arndb.de>
X-Provags-ID: V02:K0:A1H+Le555DIjks/htytO+qdpbfiuzvVCu0r3uVMOTnE
 Rd2yLoDk9t63XIk3u6JtFC0EIy6s4mVH+hLJ0Z3IFGD1DrdHaN
 HxZ0vdPwXvttuHceH1HSFlrE8ITp/yYVrzfuEfN+sYN/3YgQdX
 K8JMMIUXrHa2+eR26RwHKm9i2FD+0lrlwEjHe9wm+E8XwEiwpr
 S618QuzhJri4GvHmlEd2TVKNNDcQhH4f0CTEsLKozbrwMTvfgr
 uE0oIMinXjtf27HqWt6Sv1enJDfSlY6MtBCeM0Fn6mGKFspk4S
 2xhsyh6y74hu2CBQ/bK0ek2r2Nn5x4nVe8KN4MIGLIjMLZV76j
 4706RwwAYR1r7P3/zrmA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 May 2013, Pavel Machek wrote:
> On Mon 2013-05-06 15:45:22, Arnd Bergmann wrote:
> > On Monday 06 May 2013, Pavel Machek wrote:
> > > 
> > > Hi!
> > > 
> > > Ping? Previous version was tested by Dinh, and this one is based on
> > > Jamie's updates, so I assume it is acceptable for him, too.
> > > 
> > > It brings two platforms closer together, and makes time actually work
> > > on socfpga. It would be good to get it applied.
> > 
> > Who should apply it? I guess it needs to go through arm-soc with all the
> > other clocksource changes already queued up there. Can we have an Ack
> > from Jamie and from the clocksource maintainers?
> 
> Well, changes to arch/arm/mach-picoxcell are single line (and that's a
> cleanup of duplicate include). 

The point is that Jamie had comments on the earlier version, so it would
be good to see his Ack on the current one.

> So I guess it should go through the timekeeping tree...?

I would prefer that, but we can also take it through arm-soc, it doesn't
really matter.

	Arnd
