Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab3KFItr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:49:47 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:46915 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921Ab3KFItp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:49:45 -0500
Date: Wed, 6 Nov 2013 08:49:21 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efi earlyprintk fix
Message-ID: <20131106084921.GA22856@console-pimps.org>
References: <20131103121647.GA4770@dhcp-16-126.nay.redhat.com>
 <20131104103739.GD21688@console-pimps.org>
 <20131104125853.GB5118@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104125853.GB5118@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Nov, at 08:58:53PM, Dave Young wrote:
> On 11/04/13 at 10:37am, Matt Fleming wrote:
> > On Sun, 03 Nov, at 08:16:47PM, Dave Young wrote:
> > > 
> > > there's below one line shift problem:
> > > 
> > >                      ACPI=0xdabfe000  ACPI 2.0=0xdabfe014  SMBIOS=0xdaa9e000
> > > [    0.000000] efi:  
> > > 
> > > In fact check efi_y and the lfb_height should be compared at the begin of the
> > > loop of early_efi_write
> >  
> > Hmm... this is interesting. I can't produce this on any of my machines.
> > Where did you see this? What hardware?
> 
> It's my laptop Thinkpad T420, the screen scolls very fast, I use boot_delay=500
> to verify it with my patch for moving boot_delay param an early param.

Dave, how are you booting your laptop? Are you using grub? Does the
earlyprintk output start at the bottom of the screen? Do you set any
parameters for efifb?

-- 
Matt Fleming, Intel Open Source Technology Center
