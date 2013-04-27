Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab3D0PuG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 11:50:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47327 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab3D0PuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 11:50:04 -0400
Date: Sat, 27 Apr 2013 17:49:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: vitalif@yourcmc.ru
Cc: Thomas Gleixner <tglx@linutronix.de>, Ben Hutchings <ben@decadent.org.uk>,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        700333@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: Re: Bug#700333: Stack trace
Message-ID: <20130427154956.GC4358@pd.tnic>
References: <20130305203952.GZ9079@decadent.org.uk>
 <4e8c511dcfd811c0f2ab822adaf52e50@yourcmc.ru>
 <1362536476.3768.416.camel@deadeye.wl.decadent.org.uk>
 <15ec7b46ebd929a67caea0d80b324af9@yourcmc.ru>
 <1362971451.3937.29.camel@deadeye.wl.decadent.org.uk>
 <cc9020446ea75ed733ec96c505039f2a@yourcmc.ru>
 <20130420225516.GB4649@pd.tnic>
 <alpine.LFD.2.02.1304221409420.21884@ionos>
 <alpine.LFD.2.02.1304251139340.21884@ionos>
 <2666050d6d50efdbfa3503aa10c0e5ec@yourcmc.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2666050d6d50efdbfa3503aa10c0e5ec@yourcmc.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 07:08:42PM +0400, vitalif@yourcmc.ru wrote:
> >Looks like we can't do anything about that in the HPET code itself.
> >
> >Vitaliy, could you try that patch ?
> 
> Thanks, I've tried it several days ago (and still using a patched
> kernel :)) - the box survives.
> But at which moment should I check for "Spurious interrupt" in dmesg?

When you do a suspend/resume cycle.

The bug says "The photo shows a BUG in hrtimer_interrupt() after making
the hibernation image and while resuming the non-boot CPUs." so I'm
guessing with Thomas' patch it suspends fine now?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
