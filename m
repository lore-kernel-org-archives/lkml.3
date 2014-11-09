Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaKIUjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 15:39:54 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:53109 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaKIUjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 15:39:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Olof Johansson <olof@lixom.net>, Scott Branden <sbranden@broadcom.com>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ray Jui <rjui@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JD Zheng <jdzheng@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 4/8] ARM: dts: Enable Broadcom Cygnus SoC
Date: Sun, 09 Nov 2014 21:38:25 +0100
Message-ID: <5982323.RDuqIHPULA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141109172311.GB738@kroah.com>
References: <sbranden@broadcom.com> <CAOesGMhd37UM+7+6eR9iLY22Fb9cG1dr8dD4DAzLJNRmtysnkg@mail.gmail.com> <20141109172311.GB738@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:nhm5bpxhWSA2nx/pfCTO62kbS+3ACxbLBXuWnn6hlRL
 Qo5nxcdmudwhKrv+uA3MAZ10dSr9JbAR7oNWSrM0Kik/2q4NuN
 IAXFiqAv3oMMpTmaTEoMXSGxa9AznYmmt1pi0KTRhk4iOqj0nS
 foJ4NnISoqH5yPbJIvouZqHn1xRGN/h4PQxj+m8of+8Kf0PyS6
 Hq7uRxXaj8Hftvm6Qw0c4ErudnjgEiboihwdnZ7nPcnuGlxOJh
 kK5SvXKYWvdYj2YDew/vVEc2lYxhx46e8Ar+i9Ydw+pkUpihB6
 Ay22ghWUc7L9Rps4Ay91fe+F/IY9jrqEpZUu55hiKj/FykccDT
 tNMmnmQncr6wOEgfe0jg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 November 2014 09:23:11 Greg Kroah-Hartman wrote:
> On Sat, Nov 08, 2014 at 10:49:09PM -0800, Olof Johansson wrote:
> > >>> +/*
> > >>> + * Copyright 2014 Broadcom Corporation.  All rights reserved.
> > >>> + *
> > >>> + * Unless you and Broadcom execute a separate written software license
> > >>> + * agreement governing use of this software, this software is licensed
> > >>> to you
> > >>> + * under the terms of the GNU General Public License as
> > >>> + * published by the Free Software Foundation version 2.
> > >>> + *
> > >>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> > >>> + * kind, whether express or implied; without even the implied warranty
> > >>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > >>> + * GNU General Public License for more details.
> > >>
> > >>
> > >> We ask for new DT contents to be added with dual BSD/GPL license, to
> > >> allow for reuse of the DT data structures in other projects as well.
> > >> There's currently a lot of activity going on relicensing the current
> > >> files so I recommend sorting it out before they are added if you can.
> > >
> > >
> > > This may take more time than you think.  I am going to have to go through
> > > legal to get such a license created. Also, why would you need dual license?
> > > If it is BSD that should serve both purposes?
> >
> > I haven't followed the discussion close enough to know if there's been
> > discussion about single-license BSD vs dual BSD/GPL.

I think for all practical purposes, BSD and dual BSD/GPL is the same and
listing it as dual was meant as a clarification to make it easier to see
that all files in the kernel are GPLv2 compatible.
 
> > At the very least, please start the process of getting it changed.
> > 
> > Also, I see now that this isn't even a clean GPL v2, given "Unless you
> > and Broadcom..." language. I see the bnx2x driver had that in the
> > past, but none of the Kona contributions did. I strongly suggest
> > sticking to the normal copyrights here and not making things more
> > complicated than they have to.
> 
> I'm thinking that the "unless you and Broadcom..." language really
> doesn't mean much other than what all other files in the kernel mean
> from what I can tell.  This should just default to GPLv2 and everyone
> should be ok.

I would hope so at least. It's certainly not obvious whether that means
Broadcom can give additional rights to someone over what someone else
contributed upstream, or worse if this becomes GPL-incompatible and
makes the kernel undistributable for anybody who has an additional
license agreement that doesn't give them all the rights that they already
had under the GPL.

	Arnd
