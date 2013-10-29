Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab3J2GsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 02:48:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab3J2GsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 02:48:02 -0400
Date: Tue, 29 Oct 2013 14:47:20 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org,
        fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Message-ID: <20131029064720.GA16009@dhcp-16-126.nay.redhat.com>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
 <20131008164831.GD16793@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008164831.GD16793@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  /*
>   * This function will switch the EFI runtime services to virtual mode.
>   * Essentially, look through the EFI memmap and map every region that
> @@ -862,10 +906,10 @@ void efi_memory_uc(u64 addr, unsigned long size)
>  void __init efi_enter_virtual_mode(void)

Boris, could you update the comment? it says below:
 update that memory descriptor with the virtual address obtained
 from ioremap().

Logiclly your patch should update it, then my patch update it again with
the case of mapping to fixed address for kexec.

Thanks
Dave
