Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbbA0OYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:24:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51544 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbbA0OYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:24:34 -0500
Date: Tue, 27 Jan 2015 15:24:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rob Herring <robherring2@gmail.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
Message-ID: <20150127142430.GA15236@amd>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <201412041857.49341@pali>
 <CAL_JsqJ9i0jwaL1cyeomQG=bhhcnEgdGWYOqkcwidyk5xOUukg@mail.gmail.com>
 <201501262016.52079@pali>
 <CAL_JsqL_EEg7tC-q8wV5v8jAfPSiri4z19iJfz2r7zntRwPyOg@mail.gmail.com>
 <20150127132127.GA869@amd>
 <CAL_JsqKM+2PtX_EpWXyOQHVXwf=jqVj8SroUGPO1Y2=Zj8_kMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqKM+2PtX_EpWXyOQHVXwf=jqVj8SroUGPO1Y2=Zj8_kMg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2015-01-27 08:16:45, Rob Herring wrote:
> On Tue, Jan 27, 2015 at 7:21 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > On Mon 2015-01-26 14:33:21, Rob Herring wrote:
> >> On Mon, Jan 26, 2015 at 1:16 PM, Pali Rohár <pali.rohar@gmail.com> wrote:

> >> This goes in the commit message.
> >>
> >> These would be non-standard fields which are not upstream. I don't
> >> know that we care in that case...
> >
> > Other devices are going to care about boot reason, too, and we might
> > as well be compatible...
> 
> What other devices? Where is bootreason in the list of ATAGS:
> 
> #define ATAG_MEM        0x54410002
> #define ATAG_VIDEOTEXT  0x54410003
> #define ATAG_RAMDISK    0x54410004
> #define ATAG_INITRD     0x54410005
> #define ATAG_INITRD2    0x54420005
> #define ATAG_SERIAL     0x54410006
> #define ATAG_REVISION   0x54410007
> #define ATAG_VIDEOLFB   0x54410008
> #define ATAG_CMDLINE    0x54410009
> #define ATAG_ACORN      0x41000101
> #define ATAG_MEMCLK     0x41000402

Anyone, whose charging involves userspace.

But the fact that it is needed on n900 should be enough.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
