Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbaE2Mur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 08:50:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41830 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646AbaE2Muq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 08:50:46 -0400
Date: Thu, 29 May 2014 14:50:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>, matt.fleming@intel.com,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH] export efi.flags to sysfs
Message-ID: <20140529125038.GC21718@pd.tnic>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
 <20140527133411.GG10994@redhat.com>
 <20140528021359.GC2820@darkstar.nay.redhat.com>
 <20140528124029.GF14863@redhat.com>
 <20140529020837.GB2068@darkstar.nay.redhat.com>
 <20140529124520.GC14570@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140529124520.GC14570@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 08:45:20AM -0400, Vivek Goyal wrote:
> I am curious that what's the meaning of 1:1 mapping here? So far I
> thought that means virt and physical addresses are same but that does
> not seem to be the case. So what does it mean?

1:1 mapping in the EFI's case (and maybe in any other case I'm aware of)
is taking the physical addresses of the EFI regions and mapping them at
the exact same addresses in the EFI page table.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
