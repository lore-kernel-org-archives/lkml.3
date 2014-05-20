Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaETQ2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:28:35 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:25769 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752045AbaETQ2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:28:34 -0400
Date: Tue, 20 May 2014 17:28:14 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EFI changes for arm64
Message-ID: <20140520162814.GB28293@arm.com>
References: <20140430200332.GO26088@console-pimps.org>
 <20140519105042.GE4798@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519105042.GE4798@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 11:50:42AM +0100, Matt Fleming wrote:
> On Wed, 30 Apr, at 09:03:32PM, Matt Fleming wrote:
> > I pulled the arm64 EFI changes into the following topic branch. Catalin
> > was happy for this to go through tip, which definitely makes things
> > easier for the next merge window because of the dependency these patches
> > have on tip/x86/efi.
> > 
> > The following changes since commit e33655a386ed3b26ad36fb97a47ebb1c2ca1e928:
> > 
> >   efivars: Add compatibility code for compat tasks (2014-04-17 13:53:53 +0100)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git arm64-efi
> > 
> > for you to fetch changes up to 345c736edd07b657a8c48190baed2719b85d0938:
> > 
> >   efi/arm64: ignore dtb= when UEFI SecureBoot is enabled (2014-04-30 19:57:06 +0100)
> 
> Ping?

Alternatively, I can merge the arm64-efi tree and wait for tip x86/efi
to go in before sending my pull request. Peter, Ingo, do you have any
preference?

Either way, I'd like to see this branch in -next to make sure there are
no (significant) conflicts before the merging window.

Thanks.

-- 
Catalin
