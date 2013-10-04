Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3JDOuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 10:50:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38516 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab3JDOuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 10:50:03 -0400
Date: Fri, 4 Oct 2013 16:50:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@console-pimps.org>, Dave Young <dyoung@redhat.com>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20131004145001.GA4627@pd.tnic>
References: <20130924025209.GA5561@dhcp-16-126.nay.redhat.com>
 <2d27a1bc-eabf-4d45-8303-27ae58511b11@email.android.com>
 <20131002100426.GB20568@pd.tnic>
 <524C3F38.6050507@zytor.com>
 <20131002170522.GA20647@pd.tnic>
 <524C58A3.4090704@zytor.com>
 <20131002184229.GE20568@pd.tnic>
 <524C6A14.40905@zytor.com>
 <20131004094247.GA6796@nazgul.tnic>
 <89e0284e-89b5-42ad-8120-128ef1bf0152@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <89e0284e-89b5-42ad-8120-128ef1bf0152@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 07:43:37AM -0700, H. Peter Anvin wrote:
> We can do that... but it is different from what Windows does to my
> understanding and it also has the potential of severe pathologies...
> e.g. a window at the top of the address space being mapped.

Right, so after Matt and I talked about it a bit on IRC, we actually
don't really care how we do the mappings if we spell them out later to
kexec over proc or somewhere else, as you wanted.

So we can do the VA address space saving scheme first and change it
later, if there are issues. We'll see.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
