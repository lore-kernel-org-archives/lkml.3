Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab3FZOPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:15:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46760 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab3FZOPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:15:32 -0400
Date: Wed, 26 Jun 2013 16:15:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com
Subject: Re: [PATCH 3/4] arm: Add [U]EFI runtime services support
Message-ID: <20130626141528.GF20274@pd.tnic>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-4-git-send-email-leif.lindholm@linaro.org>
 <CACxGe6sH4dAVryBp7TeUmrwsJmnMdLsQm++U4EVDJVNi9pnqYw@mail.gmail.com>
 <20130626135417.GP22026@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130626135417.GP22026@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 02:54:17PM +0100, Matt Fleming wrote:
> On Wed, 26 Jun, at 02:46:09PM, Grant Likely wrote:
> > Eventually we'll need to look at how this interacts with kexec. A
> > kexec'd kernel will need to use the mapping already chosen by a
> > previous kernel, but that's an issue for another patch series.
> 
> FYI, this is exactly what Borislav has been tackling on x86 recently. It
> would be nice if we could find one scheme that suits everyone.

Is this arm 32 or 64-bit? Because we haven't talked about 32-bit on x86
either. From skimming over the code, I'm not sure the same top-down
allocation and 1:1 mapping would work there. But I haven't looked hard
yet so I dunno.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
