Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187Ab3KYFaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 00:30:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab3KYFaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 00:30:01 -0500
Date: Mon, 25 Nov 2013 13:28:58 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [patch 5/9 v3] efi: export more efi table variable to sysfs
Message-ID: <20131125052858.GA6330@dhcp-16-126.nay.redhat.com>
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
 <20131121061754.887381332@dhcp-16-126.nay.redhat.com>
 <20131121165742.GN26009@pd.tnic>
 <20131122024850.GC3874@dhcp-16-126.nay.redhat.com>
 <20131123131518.GC24148@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131123131518.GC24148@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/13 at 02:15pm, Borislav Petkov wrote:
> On Fri, Nov 22, 2013 at 10:48:50AM +0800, Dave Young wrote:
> > > 	efi.config_table = (unsigned long)efi.systab->tables;
> > > 	efi.fw_vendor	 = (unsigned long)efi.systab->fw_vendor;
> > > 	efi.runtime	 = (unsigned long)efi.systab->runtime;
> > 
> > Hmm, UEFI spec mentions the them like below so I use the order:
> 
> I'm sure by now you know you should not really trust the UEFI spec, or
> any other spec for that matter :)
> 
> > Several fields of the EFI System Table must be converted from
> > physical pointers to virtual pointers using the ConvertPointer()
> > service. These fields include FirmwareVendor, RuntimeServices,
> > and ConfigurationTable.
> > 
> > But since you like the reverse I can change it in next version.
> 
> The reverse was simply a suggestion. The vertical alignment was more
> what I aimed at because it makes this chunk much more readable IMO.
> 

Got your point about alignment, will update.

--
Thanks
Dave
