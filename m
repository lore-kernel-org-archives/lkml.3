Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3KWNPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 08:15:25 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36735 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab3KWNPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 08:15:22 -0500
Date: Sat, 23 Nov 2013 14:15:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [patch 5/9 v3] efi: export more efi table variable to sysfs
Message-ID: <20131123131518.GC24148@pd.tnic>
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
 <20131121061754.887381332@dhcp-16-126.nay.redhat.com>
 <20131121165742.GN26009@pd.tnic>
 <20131122024850.GC3874@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131122024850.GC3874@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 10:48:50AM +0800, Dave Young wrote:
> > 	efi.config_table = (unsigned long)efi.systab->tables;
> > 	efi.fw_vendor	 = (unsigned long)efi.systab->fw_vendor;
> > 	efi.runtime	 = (unsigned long)efi.systab->runtime;
> 
> Hmm, UEFI spec mentions the them like below so I use the order:

I'm sure by now you know you should not really trust the UEFI spec, or
any other spec for that matter :)

> Several fields of the EFI System Table must be converted from
> physical pointers to virtual pointers using the ConvertPointer()
> service. These fields include FirmwareVendor, RuntimeServices,
> and ConfigurationTable.
> 
> But since you like the reverse I can change it in next version.

The reverse was simply a suggestion. The vertical alignment was more
what I aimed at because it makes this chunk much more readable IMO.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
