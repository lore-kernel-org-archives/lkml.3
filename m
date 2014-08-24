Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaHXJ3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 05:29:08 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:46904 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbaHXJ3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 05:29:06 -0400
Date: Sun, 24 Aug 2014 11:29:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: x86-ml <x86@kernel.org>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] microcode cleanups
Message-ID: <20140824092900.GA7271@gmail.com>
References: <20140823063702.GA1724@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140823063702.GA1724@nazgul.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> Hi guys,
> 
> please pull a bunch of cleanups to the microcode loader machinery, from
> Henrique de Moraes Holschuh.
> 
> Thanks.
> 
> --
> The following changes since commit 9a3c4145af32125c5ee39c0272662b47307a8323:
> 
>   Linux 3.16-rc6 (2014-07-20 21:04:16 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/microcode_cleanups
> 
> for you to fetch changes up to ebc14ddcc9454c02439b67f6536628289faaa26e:
> 
>   x86, microcode, intel: Fix total_size computation (2014-07-28 16:08:02 +0200)
> 
> ----------------------------------------------------------------
> A bunch of cleanups from Henrique.
> 
> ----------------------------------------------------------------
> Henrique de Moraes Holschuh (5):
>       x86, microcode, amd: Fix missing static declaration
>       x86, microcode, intel: Add missing static declarations
>       x86, microcode, intel: Fix typos
>       x86, microcode, intel: Rename apply_microcode and declare it static
>       x86, microcode, intel: Fix total_size computation
> 
>  arch/x86/include/asm/microcode_intel.h      |  2 +-
>  arch/x86/kernel/cpu/microcode/amd_early.c   |  2 +-
>  arch/x86/kernel/cpu/microcode/intel.c       |  4 ++--
>  arch/x86/kernel/cpu/microcode/intel_early.c | 10 +++++-----
>  4 files changed, 9 insertions(+), 9 deletions(-)

Pulled into the tip:x86/microcode tree, thanks a lot!

	Ingo
