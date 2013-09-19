Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab3ISJ5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:57:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38175 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3ISJ5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:57:12 -0400
Date: Thu, 19 Sep 2013 11:57:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: 3.12-rc1: no longer compiles for Nokia n900 (omap based)
Message-ID: <20130919095711.GA19346@amd.pavel.ucw.cz>
References: <20130919093002.GA23806@amd.pavel.ucw.cz>
 <20130919093627.GB24866@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919093627.GB24866@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-09-19 10:36:28, Will Deacon wrote:
> On Thu, Sep 19, 2013 at 10:30:02AM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > I get:
> > 
> >   CC      arch/arm/kernel/machine_kexec.o
> > /tmp/ccCFXeXG.s: Assembler messages:
> > /tmp/ccCFXeXG.s:217: Error: garbage following instruction -- `dsb
> > nshst'
> > /tmp/ccCFXeXG.s:225: Error: garbage following instruction -- `dsb nsh'
> > make[1]: *** [arch/arm/kernel/suspend.o] Error 1
> > make[1]: *** Waiting for unfinished jobs....
> > 
> > pavel@amd:/data/l/linux-n900$ arm-linux-gnueabi-gcc --version
> > arm-linux-gnueabi-gcc (Debian 4.3.5-4) 4.3.5
> > 
> > Minimum required gcc is 3.2, so I'm safe.
> 
> Please check your binutils. >= 2.22 has been reported to work.

pavel@amd:/data/l/linux-good$ arm-linux-gnueabi-ld --version
GNU ld (GNU Binutils for Debian) 2.20.1.20100303
Copyright 2009 Free Software Foundation, Inc.
This program is free software; you may redistribute it under the terms
of
the GNU General Public License version 3 or (at your option) a later
version.
This program has absolutely no warranty.

but

Documentation/Changes:
o  binutils               2.12                    # ld -v

Can the code be fixed so that binutils 2.12 still work?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
