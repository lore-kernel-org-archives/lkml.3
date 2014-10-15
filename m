Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaJOO7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:59:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbaJOO7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:59:35 -0400
Date: Wed, 15 Oct 2014 10:59:24 -0400
From: Dave Jones <davej@redhat.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        aubrey.li@linux.intel.com
Subject: Re: x86: Make Atom PMC driver configurable.
Message-ID: <20141015145924.GA21199@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Felipe Balbi <balbi@ti.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
	aubrey.li@linux.intel.com
References: <20141015144603.GA19944@redhat.com>
 <20141015145245.GB11511@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015145245.GB11511@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 09:52:45AM -0500, Felipe Balbi wrote:
 > Hi,
 > 
 > On Wed, Oct 15, 2014 at 10:46:03AM -0400, Dave Jones wrote:
 > > The Atom PMC driver is always built-in, regardless of whether
 > > the kernel being built is going to be run on an Atom (or even Intel) CPU.
 > > 
 > > Signed-off-by: Dave Jones <davej@redhat.com>
 > > 
 > > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
 > > index f2327e88e07c..04280177c1e2 100644
 > > --- a/arch/x86/Kconfig
 > > +++ b/arch/x86/Kconfig
 > > @@ -2485,7 +2485,7 @@ config X86_DMA_REMAP
 > >  	depends on STA2X11
 > >  
 > >  config PMC_ATOM
 > > -	def_bool y
 > > +	tristate "Intel Atom SOC power management controller driver"
 > 
 > looks like you should still have this as default y just to make sure you
 > a simple defconfig still enables this as it did before.
 
I could, but why should this be default y ? There's no real
justification to inflict this on everyone, given atom is at best
a niche area of x86.

	Dave

