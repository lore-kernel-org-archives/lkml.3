Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab3EXVGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 17:06:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564Ab3EXVGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 17:06:10 -0400
Date: Fri, 24 May 2013 17:05:34 -0400
From: Dave Jones <davej@redhat.com>
To: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Message-ID: <20130524210534.GA15466@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Russ Anderson <rja@sgi.com>, Robin Holt <holt@sgi.com>,
	Matt Fleming <matt@console-pimps.org>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	matt.fleming@intel.com, linux-efi@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>
References: <20130522162747.GA20816@sgi.com>
 <20130523115801.GJ14575@console-pimps.org>
 <20130523203234.GD20913@sgi.com>
 <20130524074331.GL14575@console-pimps.org>
 <20130524161111.GE3672@sgi.com>
 <20130524170214.GA30179@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524170214.GA30179@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 12:02:15PM -0500, Russ Anderson wrote:
 > On Fri, May 24, 2013 at 11:11:11AM -0500, Robin Holt wrote:
 > > Russ,
 > > 
 > > Can we open a bug for the BIOS folks and see if we can get this addressed?
 > 
 > I already talked with them.  It is not in an area that we
 > normally change, so if there is a bug may be in the Intel
 > reference code.  More investigation is needed to track down
 > the actual problem, and that could take help from Intel.
 > 
 > Regardless of that, it is a kernel patch that triggers the
 > problem.  This isn't the first time a kernel change does
 > the "right thing" but trips across questionable bios/EFI/bootloader
 > implementation.  That still makes it a kernel bug.
 > 
 > I'm still digging to better understand the root problem.
 
When we rebased the Fedora 18 kernel to 3.9 we had a bunch of reports
from people who can no longer boot with what looks like similar symptoms.

https://bugzilla.redhat.com/show_bug.cgi?id=964335

	Dave

