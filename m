Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaAJJwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 04:52:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:22571 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbaAJJwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:52:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,637,1384329600"; 
   d="scan'208";a="463092181"
Date: Fri, 10 Jan 2014 10:52:09 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: micky <micky_ching@realsil.com.cn>, wwang <wei_wang@realsil.com.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Jingoo Han <jg1.han@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "'Borislav Petkov'" <bp@alien8.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Message-ID: <20140110095209.GU6003@zurbaran>
References: <alpine.DEB.2.02.1311290958560.30673@ionos.tec.linutronix.de>
 <5299FF38.7060203@gmail.com>
 <alpine.DEB.2.02.1312021145190.30673@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1312021219090.30673@ionos.tec.linutronix.de>
 <529D92D6.8050409@gmail.com>
 <20131209221721.GB8612@zurbaran>
 <52A670E4.5050501@realsil.com.cn>
 <52A674E0.2080407@realsil.com.cn>
 <20131210082955.GG8612@zurbaran>
 <52CFA095.3000709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CFA095.3000709@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Francis,

On Fri, Jan 10, 2014 at 08:26:13AM +0100, Francis Moreau wrote:
> Hi.
> 
> On 12/10/2013 09:29 AM, Samuel Ortiz wrote:
> > Hi Micky,
> > 
> > On Tue, Dec 10, 2013 at 09:56:48AM +0800, micky wrote:
> >> Hi Francis:
> >> On 12/10/2013 09:39 AM, wwang wrote:
> >>> which is based on Thomas' patch.
> >>
> >> Can you help us test this patch, we disable irq while suspend here.
> > I already pushed a patch from Thomas to mfd-fixes that seems to fix the
> > resume breakage:
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/sameo/mfd-fixes.git/commit/?id=19e49e445e198197c5e243f92d333d076e23d032
> > 
> 
> I still can see any traces of this fix in Linus' tree.
> 
> Shouldn't this get merged before 3.13 is out ?
Yes, it should. I just sent a pull request to Linus for that.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
