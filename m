Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3L3Biv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 20:38:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876Ab3L3Bit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 20:38:49 -0500
Date: Mon, 30 Dec 2013 09:38:01 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com,
        akpm@linux-foundation.org, mingo@kernel.org, msalter@redhat.com,
        leif.lindholm@linaro.org
Subject: Re: [PATCH v7 09/12] efi: passing kexec necessary efi data via
 setup_data
Message-ID: <20131230013801.GA3827@dhcp-16-126.nay.redhat.com>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
 <1387533742-18018-10-git-send-email-dyoung@redhat.com>
 <20131221160416.GD29501@console-pimps.org>
 <20131223020958.GB3760@dhcp-16-126.nay.redhat.com>
 <20131223080741.GB28919@console-pimps.org>
 <20131225031259.GB6333@dhcp-16-126.nay.redhat.com>
 <20131225033205.GC6333@dhcp-16-126.nay.redhat.com>
 <20131229130546.GA2618@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131229130546.GA2618@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/13 at 01:05pm, Matt Fleming wrote:
> On Wed, 25 Dec, at 11:32:05AM, Dave Young wrote:
> > 
> > Matt, if you want to remove the map[0] please fold below one line
> > patch? I have no strong opinion.
> > 
> > Index: linux/arch/x86/include/asm/efi.h
> > ===================================================================
> > --- linux.orig/arch/x86/include/asm/efi.h
> > +++ linux/arch/x86/include/asm/efi.h
> > @@ -139,7 +139,6 @@ struct efi_setup_data {
> >  	u64 tables;
> >  	u64 smbios;
> >  	u64 reserved[8];
> > -	efi_memory_desc_t map[0];
> >  };
> >  
> >  extern u64 efi_setup;
> 
> Thanks Dave, I will fold this in. I would suggest updating your
> kexec-tools patches so that the two structures are in sync.

Sure, since it is removed in kernel I will update kexec-tools.

Thanks
Dave
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center
