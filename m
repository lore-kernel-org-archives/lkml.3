Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3F0OiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:38:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60380 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3F0OiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:38:08 -0400
Date: Thu, 27 Jun 2013 15:38:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matt Fleming <matt@console-pimps.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
Message-ID: <20130627143801.GB12900@srcf.ucam.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
 <51CA2B03.4080106@wwwdotorg.org>
 <CACxGe6vsBKnbipR-Zd1T9Ox1J2ugFmShrGXGUzPa_=D9TJvFQw@mail.gmail.com>
 <20130626135311.GA9078@rocoto.smurfnet.nu>
 <20130626135933.GQ22026@console-pimps.org>
 <1372257499.2168.5.camel@dabdike>
 <20130627013219.GA346@srcf.ucam.org>
 <20130627090050.GC18151@rocoto.smurfnet.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627090050.GC18151@rocoto.smurfnet.nu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 11:00:50AM +0200, Leif Lindholm wrote:
> On Thu, Jun 27, 2013 at 02:32:19AM +0100, Matthew Garrett wrote:
> > We can probably get away with that now, but it does risk us ending up 
> > with some firmware that expects to run in physical mode (boards designed 
> > for Linux) and some firmware that expects to run in virtual mode (boards 
> > designed for Windows). The degree of lockdown in the Windows ecosystem 
> > at present means it's not a real problem at the moment, but if that ever 
> > changes we're going to risk incompatibility.
> 
> Is there anything preventing calling SetVirtualAddressMap() with a
> 1:1 map?

No, but we've seen bugs as a result on some x86 systems. As far as the 
spec, though, you're fine.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
