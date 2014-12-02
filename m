Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbaLBBzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 20:55:35 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42755 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077AbaLBBzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 20:55:33 -0500
Message-ID: <1417485331.2585.26.camel@HansenPartnership.com>
Subject: Re: [PATCH] arch: uapi: asm: mman.h: Support MADV_FREE for madvise()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Carlos O'Donell" <carlos@systemhalted.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Chen Gang <gang.chen.5i5j@gmail.com>, Minchan Kim <minchan@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "ink@jurassic.park.msu.ru" <ink@jurassic.park.msu.ru>,
        "mattst88@gmail.com" <mattst88@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "jejb@parisc-linux.org" <jejb@parisc-linux.org>,
        "deller@gmx.de" <deller@gmx.de>, "chris@zankel.net" <chris@zankel.net>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Date: Mon, 01 Dec 2014 17:55:31 -0800
In-Reply-To: <CAE2sS1hDXqLvF9yY5-3d4pmDPiQy8aQ1fYov3_+BKM8uQ3ZSwA@mail.gmail.com>
References: <547CD304.20407@gmail.com>
	 <CAMo8BfKg=eb7wA2O+cKO+oLDDERh2CKBS7dyAvfqvCESEHWYEg@mail.gmail.com>
	 <CAMuHMdXHAZFujShNnAHY8BRv85ncrtcRvRgPS0Br0T9gSxZ+1A@mail.gmail.com>
	 <CAE2sS1hDXqLvF9yY5-3d4pmDPiQy8aQ1fYov3_+BKM8uQ3ZSwA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-01 at 17:01 -0500, Carlos O'Donell wrote:
> On Mon, Dec 1, 2014 at 4:35 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Mon, Dec 1, 2014 at 9:52 PM, Max Filippov <jcmvbkbc@gmail.com> wrote:
> >> On Mon, Dec 1, 2014 at 11:43 PM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
> >>> At present, kernel supports madvise(MADV_FREE), so can benefit to all
> >>> related architectures (can grep MADV_WILLNEED or MADV_REMOVE in "arch/"
> >>> to know about all related architectures).
> >>
> >> A similar patch has been posted a while ago:
> >>
> >> http://www.spinics.net/lists/linux-mm/msg81538.html
> >
> > Would it be possible to use the same number everywhere?
> 
> Yes please. It's ridiculous that we still need patches like this.
> 
> I proposed unifying all this two years ago, but didn't follow up.
> 
> From glibc's perspective it would be simpler if we started using the
> same number everywhere.
> 
> http://www.spinics.net/lists/linux-api/msg02064.html

Please co-ordinate with Andrew then because he's intent on merging this
patch:

http://marc.info/?l=linux-mm-commits&m=141747572930808

James


