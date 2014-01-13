Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaAMKS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:18:28 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60664 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbaAMKSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:18:25 -0500
Date: Mon, 13 Jan 2014 11:18:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an
 arbitrary pagetable
Message-ID: <20140113101822.GA5388@pd.tnic>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
 <1389473370-1940-2-git-send-email-bp@alien8.de>
 <20140113053240.GA11237@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140113053240.GA11237@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 01:32:40PM +0800, Dave Young wrote:
> pr_info? This is for debug purpose, maybe pr_debug is better?

I hate pr_debug as it depends on other defines I have to have defined
properly in order just so I get output.

> How about do not limit to only if (pgd) case, instead do something
> like below: set dump_to_dmesg as a module parameter

X86_PTDUMP is not a module.

And even though the idea to make the efi pagetable dumpable with a
kernel cmdline parameter doesn't sound all that bad, I'd like to hold
off on adding yet another efi= cmdline option and only do so until it is
really needed.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
