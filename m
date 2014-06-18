Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966568AbaFRNBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 09:01:51 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:63219 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966317AbaFRNBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 09:01:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH] tty: serial: msm: Fix section mismatch warning
Date: Wed, 18 Jun 2014 15:01:42 +0200
Message-ID: <4362858.JqVD2H8dBO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <D4093820-1DCF-4B10-8DEC-1378B5D64D3A@codeaurora.org>
References: <1401826402-1079-1-git-send-email-galak@codeaurora.org> <CAOesGMjNVoKCDQ8=dB8TB+ghTxxCQ_xMW0A07k9s4imVTgoLbA@mail.gmail.com> <D4093820-1DCF-4B10-8DEC-1378B5D64D3A@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5NKVyuSekLyhDQ2AFXfhGuqHm3HY6L/JaVDWUmlgEoi
 xVRyksIdsFfG6m+yIt3I274Sg6j1q5l4tFrdMo4L+cXDnM7Ktt
 K/m8J4n9OIRcpWBI2mJc+MdAxVzQnhWKUZRWTAX/6ZL9+1c967
 HGnQqkpsVbFpLYNPKRmE790j5jm0Q1X8getOkG6PuA0GsBwVR0
 qqW92U5nPqDykVk7v6lJFd0uJ/AIBOwf82dwz3/eovz51Yt2GT
 Hses8R7w7fTGWE5/2YB/iMm25PrzdGlZ7j6tRGTRHN3G0Gq3S9
 aAC43CQ/4H7WL6X5XwxyeuXTAJm8pL/wMXC8oazvEgDLyxJ/EC
 b47pjsPX7AB+IgGydcTQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 June 2014 14:53:44 Kumar Gala wrote:
> 
> On Jun 3, 2014, at 4:17 PM, Olof Johansson <olof@lixom.net> wrote:
> 
> > On Tue, Jun 3, 2014 at 2:14 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> On Tue, Jun 03, 2014 at 02:04:43PM -0700, Olof Johansson wrote:
> >>> On Tue, Jun 3, 2014 at 1:33 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >>>> On Tue, Jun 03, 2014 at 03:13:22PM -0500, Kumar Gala wrote:
> >>>>> WARNING: drivers/tty/built-in.o(.data+0x3544): Section mismatch in
> >>>>> reference from the variable msm_platform_driver to the function
> >>>>> .init.text:msm_serial_probe()
> >>>>> The variable msm_platform_driver references
> >>>>> the function __init msm_serial_probe()
> >>>>> If the reference is valid then annotate the
> >>>>> variable with __init* or __refdata (see linux/init.h) or name the variable:
> >>>>> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
> >>>> 
> >>>> Where is this mismatch showing up at?  3.15-rc8, 3.16-rc1?  Somewhere
> >>>> older or else?
> >>> 
> >>> Linus' next branch, it was merged through arm-soc. I didn't notice it
> >>> in time to fix it before we sent to Linus. :(
> >> 
> >> Ok, do you want to take this patch then?  I don't mind taking it through
> >> my tree, but it will have to wait until after 3.16-rc1 is out.  It's up
> >> to you.
> > 
> > I've got a handful of fixes we're queueing for the second batch of
> > merges, and I can add it to there.
> > 
> Reminder to queue this up for fixes for 3.16

I've applied it on top of the fixes branch now. I think I missed it when
I picked up the other fixes as I was only looking for patches sent to
arm@kernel.org.

Thanks for the reminder!

	Arnd
