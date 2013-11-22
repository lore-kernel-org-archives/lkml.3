Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3KVDAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 22:00:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab3KVDAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 22:00:47 -0500
Date: Fri, 22 Nov 2013 10:59:44 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [patch 2/9 v3] efi: add a wrapper function efi_map_region_fixed
Message-ID: <20131122025944.GF3874@dhcp-16-126.nay.redhat.com>
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
 <20131121061753.223578092@dhcp-16-126.nay.redhat.com>
 <20131121163947.GL26009@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121163947.GL26009@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  }
> >  
> > +/*
> > + * kexec kernel will use efi_map_region_fixed to map efi
> > + * runtime memory ranges. md->virt_addr is the original virtual
> > + * address which had been mapped in kexec 1st kernel.
> > + */
> 
> Why not stretch this comment to the full 80 cols?

Since stretch them to 80 cols I still need 3 lines so I want the
length to be more close to the length of context code lines, so
It looks better to my eys :)

I can change to 80 cols as you said below, thanks.

> 
> /*
>  * kexec kernel will use efi_map_region_fixed to map efi runtime memory ranges.
>  * md->virt_addr is the original virtual address which had been mapped in kexec
>  * 1st kernel.
>  */
> 

--
Thanks for review
Dave
