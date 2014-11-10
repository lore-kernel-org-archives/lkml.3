Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaKJQI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:08:56 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:61454 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaKJQIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:08:54 -0500
Date: Mon, 10 Nov 2014 17:08:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] microcode fixes for tip/x86/urgent
Message-ID: <20141110160848.GA24585@gmail.com>
References: <20141110153137.GD4359@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110153137.GD4359@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> Hi guys,
> 
> please queue those two fixes for early microcode loading on 32-bit for
> x86/urgent.
> 
> Thanks.
> 
> ---
> The following changes since commit e6023367d779060fddc9a52d1f474085b2b36298:
> 
>   x86, kaslr: Prevent .bss from overlaping initrd (2014-11-01 22:20:50 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/microcode_fixes_for_3.18
> 
> for you to fetch changes up to c0a717f23dccdb6e3b03471bc846fdc636f2b353:
> 
>   x86, microcode, AMD: Fix ucode patch stashing on 32-bit (2014-11-10 13:50:55 +0100)
> 
> ----------------------------------------------------------------
> Two fixes for early microcode loader on 32-bit:
> 
> * access the dis_ucode_ldr chicken bit properly
> * fix patch stashing on AMD on 32-bit
> 
> ----------------------------------------------------------------
> Borislav Petkov (2):
>       x86, microcode: Fix accessing dis_ucode_ldr on 32-bit
>       x86, microcode, AMD: Fix ucode patch stashing on 32-bit
> 
>  arch/x86/kernel/cpu/microcode/amd_early.c  | 24 ++++++++++++++----------
>  arch/x86/kernel/cpu/microcode/core_early.c |  2 +-
>  2 files changed, 15 insertions(+), 11 deletions(-)

Pulled, thanks Boris!

	Ingo
