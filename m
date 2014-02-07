Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaBGOoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:44:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50399 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbaBGOox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:44:53 -0500
Date: Fri, 7 Feb 2014 15:44:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>
Cc: Matt Fleming <matt@console-pimps.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: 3.13.0: crash on boot
Message-ID: <20140207144447.GJ24395@pd.tnic>
References: <20140131083707.GA9968@oktetlabs.ru>
 <CAErSpo6PaX2BcTqF4GD5ez3wDaPizUCNZJEjy_5EozAd3epoaA@mail.gmail.com>
 <20140203144120.GA15384@console-pimps.org>
 <20140204133046.GA24536@oktetlabs.ru>
 <20140205013206.GA5711@pd.tnic>
 <20140207090043.GB24536@oktetlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140207090043.GB24536@oktetlabs.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 01:00:45PM +0400, Alexandra N. Kossovsky wrote:
> I asked.  He installed an update.  No difference.

Ok.

> > Btw, did this box boot any kernels successfully in EFI mode at all?
> 
> Yes.  It booted, for example, the same 3.13 kernel from Debian - without
> debug options.

Huh, what debug options?

I see

[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.13.0-debug-amd64 root=UUID=c5078 393-d2ff-435d-82e8-e85990b3c9e2 ro console=tty1 console=ttyS2,115200n8 intel_iommu=on nmi_watchdog=nopanic

which fails.

Which one doesn't fail?

Also, does "intel_iommu=off" change anything?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
