Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbaCCQ3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:29:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:25372 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbaCCQ3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:29:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,578,1389772800"; 
   d="scan'208";a="465581165"
Date: Mon, 3 Mar 2014 08:25:32 -0800
From: "David E. Box" <david.e.box@linux.intel.com>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 2/2] x86: IOSF: Change IOSF_MBI Kconfig to default y
Message-ID: <20140303162532.GA15959@linux.intel.com>
References: <1393641652-7222-1-git-send-email-david.e.box@linux.intel.com>
 <1393641652-7222-3-git-send-email-david.e.box@linux.intel.com>
 <53142A31.2010209@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53142A31.2010209@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 03:07:29PM +0800, Li, Aubrey wrote:
> On 2014/3/1 10:40, David E. Box wrote:
> > From: "David E. Box" <david.e.box@linux.intel.com>
> > 
> > Make the IOSF Mailbox driver built in as it provides core functionality needed
> > for new Intel SOC platforms to access the device registers on the SOC.
> > 
> > Signed-off-by: David E. Box <david.e.box@linux.intel.com>
> > ---
> >  arch/x86/Kconfig |    7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index d3b1f8b..e34b252 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -2385,12 +2385,9 @@ config X86_DMA_REMAP
> >  	depends on STA2X11
> >  
> >  config IOSF_MBI
> > -	bool
> > +	bool "Intel IOSF Mailbox Driver support"
> 
> One concern here is, IOSF is not architectural for all of X86, can we
> change this as "Intel Atom IOSF Mailbox Driver support"? Or if you can
> confirm we'll use IOSF in the future onchip product, can we change this
> as "Intel SOC IOSF Mailbox Driver support"?
> 

Ok. The latter would be more appropriate.

david box
