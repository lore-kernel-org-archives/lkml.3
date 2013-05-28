Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707Ab3E1Cn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 22:43:27 -0400
Received: from relay1.sgi.com ([192.48.179.29]:56516 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758630Ab3E1Cn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 22:43:26 -0400
Date: Mon, 27 May 2013 21:43:23 -0500
From: Russ Anderson <rja@sgi.com>
To: joeyli <jlee@suse.com>
Cc: Dave Jones <davej@redhat.com>, Robin Holt <holt@sgi.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
	info to runtime code
Message-ID: <20130528024323.GA32664@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130522162747.GA20816@sgi.com> <20130523115801.GJ14575@console-pimps.org> <20130523203234.GD20913@sgi.com> <20130524074331.GL14575@console-pimps.org> <20130524161111.GE3672@sgi.com> <20130524170214.GA30179@sgi.com> <20130524210534.GA15466@redhat.com> <1369628832.19026.22.camel@linux-s257.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369628832.19026.22.camel@linux-s257.site>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 12:27:12PM +0800, joeyli wrote:
> Hi Dave, 
> 
> 於 五，2013-05-24 於 17:05 -0400，Dave Jones 提到：
> > On Fri, May 24, 2013 at 12:02:15PM -0500, Russ Anderson wrote:
> >  > On Fri, May 24, 2013 at 11:11:11AM -0500, Robin Holt wrote:
> >  > > Russ,
> >  > > 
> >  > > Can we open a bug for the BIOS folks and see if we can get this addressed?
> >  > 
> >  > I already talked with them.  It is not in an area that we
> >  > normally change, so if there is a bug may be in the Intel
> >  > reference code.  More investigation is needed to track down
> >  > the actual problem, and that could take help from Intel.
> >  > 
> >  > Regardless of that, it is a kernel patch that triggers the
> >  > problem.  This isn't the first time a kernel change does
> >  > the "right thing" but trips across questionable bios/EFI/bootloader
> >  > implementation.  That still makes it a kernel bug.
> >  > 
> >  > I'm still digging to better understand the root problem.
> >  
> > When we rebased the Fedora 18 kernel to 3.9 we had a bunch of reports
> > from people who can no longer boot with what looks like similar symptoms.
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=964335
> > 
> > 	Dave
> > 
> 
> The oops on the above bug is similar to my problem on Acer machine,
> could you please ask the reporter try the eccaf52f patch in urgent
> branch on Matt's efi git tree:
> 
> https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=urgent&id=eccaf52fee8305d5207ff110950a82c100e459bc

I tried that patch, but it does not fix the problem.

Thanks for the suggestion.


-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
