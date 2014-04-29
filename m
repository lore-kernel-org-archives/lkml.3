Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbaD2Ork (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:47:40 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:53304 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676AbaD2Ori (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:47:38 -0400
Date: Tue, 29 Apr 2014 15:47:13 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 00/10] arm64: UEFI support
Message-ID: <20140429144713.GL26088@console-pimps.org>
References: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
 <20140429102817.GE17007@arm.com>
 <20140429114356.GK26088@console-pimps.org>
 <20140429134726.GH17007@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429134726.GH17007@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr, at 02:47:28PM, Catalin Marinas wrote:
> 
> Waiting for the tip/x86/efi to be merged first is not a problem. We
> also need a stable base for testing the arm64 UEFI series, so I assume
> this series can be based onto tip/x86/efi (would such branch be rebased
> before hitting mainline?).
 
tip/x86/efi is unlikely to be rebased. Certainly with dependencies like
this there would have to be a really good reason to rebase it.

> Given that Leif's series contains both generic efi and arm64 patches,
> what's your preference for merging them? I'm happy to add my ack and
> they go via your tree (or the other way around).

I'm happy either way, though if I take them through my tree (and
subsequently through tip) you won't have to worry about the merge window
rigmarole, which is a plus.

So, eveyone happy for me to take these with Catalin's Acked-by?

-- 
Matt Fleming, Intel Open Source Technology Center
