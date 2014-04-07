Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbaDGRjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:39:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:47453 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbaDGRjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:39:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,811,1389772800"; 
   d="scan'208";a="515993082"
Date: Mon, 7 Apr 2014 10:30:16 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, tpowa@archlinux.org
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
Message-ID: <20140407173016.GU32556@tassilo.jf.intel.com>
References: <52E4CF03.8030208@archlinux.org>
 <5339F739.2060207@archlinux.org>
 <20140331233450.GI32556@tassilo.jf.intel.com>
 <5339FC62.8060207@archlinux.org>
 <20140405011332.GR32556@tassilo.jf.intel.com>
 <5340134B.4010705@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5340134B.4010705@archlinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 05, 2014 at 04:29:31PM +0200, Thomas Bächler wrote:
> Am 05.04.2014 03:13, schrieb Andi Kleen:
> > On Tue, Apr 01, 2014 at 01:38:10AM +0200, Thomas Bächler wrote:
> >> Am 01.04.2014 01:34, schrieb Andi Kleen:
> >>>> This problem persists in v3.14, i.e. I still have to revert
> >>>> 83460ec8dcac14142e7860a01fa59c267ac4657c in order to get a working
> >>>> kernel on i686. I would really appreciate if someone would actually read
> >>>> my original mail from about 3 months ago and write an answer.
> >>>
> >>> Can you resend it please?
> >>
> >> It's available here: https://lkml.org/lkml/2014/1/26/22
> >>
> >> For convenience, here is a copy-and-paste of the full text:
> > 
> > I did some experiments know and I can't find any 32bit modules 
> > that do not load with 32bit MODVERSIONS on or off with 
> > a current tree.
> > 
> > Do you have a specific config?
> > Specific compiler version?
> 
> Using gcc 4.8 from Arch Linux with the configuration at [1] and Linux 3.14.

I tested this configuration (with gcc 4.8 on FC20/19) and it loads
ext4 and all the other modules without any problems.

Base tree: 

commit e06df6a7eae1ab1ef4deb076aeeaed90e948e5c0
Merge: c0fc3cb 9dd721c
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Mar 31 12:34:49 2014 -0700

Must be something really archlinux specific. Please do some debugging.
Also please double check that all your test procedures are correct.

-Andi
