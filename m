Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaIIFHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 01:07:55 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:65249 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaIIFHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 01:07:54 -0400
Date: Tue, 9 Sep 2014 07:07:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] EFI urgent fixes
Message-ID: <20140909050749.GB6770@gmail.com>
References: <20140908215535.GD18582@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908215535.GD18582@console-pimps.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> Folks,
> 
> Please queue up the following fixes, mainly for regressions introduced
> in the merge window or -rc2.

So the rule for post-rc1 merges is to fix regressions 'only', not 
'mainly'!

> ----------------------------------------------------------------
> Mark Rustad (1):
>       efi: Resolve some shadow warnings

That's not a critical regression.

> 
> Mark Salter (1):
>       efi/arm64: Fix fdt-related memory reservation

That's a regression fix.

> Mathias Krause (4):
>       x86/efi: Remove unused efi_call* macros
>       x86/efi: Unexport add_efi_memmap variable
>       x86/efi: Update comment regarding required phys mapped EFI services
>       x86/efi: Mark initialization code as such

Neither of these 4 changes is a critical regression!

> Matt Fleming (1):
>       x86/efi: Fixup GOT in all boot code paths

That's a regression fix.

> Yinghai Lu (1):
>       x86/efi: Only load initrd above 4g on second try

This revert is a regression fix too.

So please only put the 3 regression fixes into efi-urgent, the 
rest can go into the v3.18 pile.

Thanks,

	Ingo
