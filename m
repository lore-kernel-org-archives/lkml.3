Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab3ITKHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 06:07:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297Ab3ITKHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 06:07:50 -0400
Date: Fri, 20 Sep 2013 18:07:25 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH 00/11] EFI runtime services virtual mapping
Message-ID: <20130920100725.GD21922@dhcp-16-126.nay.redhat.com>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20130920072904.GA21922@dhcp-16-126.nay.redhat.com>
 <20130920081940.GC21922@dhcp-16-126.nay.redhat.com>
 <20130920093352.GB9574@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130920093352.GB9574@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/13 at 11:33am, Borislav Petkov wrote:
> On Fri, Sep 20, 2013 at 04:19:40PM +0800, Dave Young wrote:
> > Actually the ovmf testing is "qemu-system-x86_64 -kernel ", boot from grub
> > fails as well. Nothing printed on serial. I guess '-kernel' is using efi stub
> > to boot?
> 
> Yes.
> 
> Which OVMF are you using? Mine is pretty recent: svn revision 14530 from August.

It's a fresh clone at 2013-09-12.

> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
