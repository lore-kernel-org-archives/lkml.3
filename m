Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491AbaD2NtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:49:12 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:47241 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757593AbaD2NsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:48:04 -0400
Date: Tue, 29 Apr 2014 14:47:28 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Matt Fleming <matt@console-pimps.org>
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
Message-ID: <20140429134726.GH17007@arm.com>
References: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
 <20140429102817.GE17007@arm.com>
 <20140429114356.GK26088@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429114356.GK26088@console-pimps.org>
Thread-Topic: [PATCH v2 00/10] arm64: UEFI support
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 12:43:56PM +0100, Matt Fleming wrote:
> (Pulling in Peter and Stephen)
> 
> On Tue, 29 Apr, at 11:28:17AM, Catalin Marinas wrote:
> > 
> > The patches look fine to me, they've been through several rounds of
> > review already. How do we propose these get merged as the series
> > contains both generic and arm64 patches? And there are dependencies
> > already in linux-next.
> > 
> > Are the EFI patches in -next pulled from some non-rebaseable branch?
> 
> Peter suggsted a plan when he took the generic EFI stuff that's in tip
> (and hence currently in linux-next),
> 
>   It doesn't hurt to inform Stephen, although I think it will simply fall
>   out automatically since he uses git to merge and git will recognize the
>   graph.
> 
>   During the merge window, it means they should not push their patches
>   until Linus has accepted the precondition patches from the tip tree.
>   Since Ingo and I try to push most of the tip tree as early as possible
>   in the merge window, this is usually not a problem.
> 
> So we currently have the prerequisites in tip/x86/efi, and assuming that
> this 10-patch series gets merged into a single branch somewhere, things
> should work automatically for linux-next.
> 
> It may be prudent to negotiate a plan now for when the merge window
> opens because, as Peter mentions above, the stuff in tip/x86/efi needs
> to be merged by Linus first to avoid build breakage with the arm64
> stuff.

Waiting for the tip/x86/efi to be merged first is not a problem. We
also need a stable base for testing the arm64 UEFI series, so I assume
this series can be based onto tip/x86/efi (would such branch be rebased
before hitting mainline?).

Given that Leif's series contains both generic efi and arm64 patches,
what's your preference for merging them? I'm happy to add my ack and
they go via your tree (or the other way around).

Thanks.

-- 
Catalin
