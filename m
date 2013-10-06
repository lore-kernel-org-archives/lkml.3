Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab3JFJ1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 05:27:41 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:47598 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab3JFJ1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 05:27:36 -0400
Date: Sun, 6 Oct 2013 11:27:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] EFI changes
Message-ID: <20131006092732.GA4535@gmail.com>
References: <20131004195550.GA21783@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004195550.GA21783@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> These changes fix a couple of sparse warnings introduced in the last
> pull.
> 
> The following changes since commit 0ce6cda2c75d64175394341ef60e6e1d27dd9c10:
> 
>   x86 efi: bugfix interrupt disabling sequence (2013-09-30 10:23:11 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next
> 
> for you to fetch changes up to c158c3bf59951bbb44bd7ccca9e6665dfd1617c5:
> 
>   boot, efi: Remove redundant memset() (2013-10-04 20:07:47 +0100)
> 
> ----------------------------------------------------------------
>  * Fix a recently introduced sparse warning caused by using 0 instead of
>    NULL - Leif Lindholm
> 
>  * Remove a useless memset from the common EFI stub code - Roy Franz
> 
> ----------------------------------------------------------------
> Leif Lindholm (1):
>       x86/efi: Fix config_table_type array termination
> 
> Roy Franz (1):
>       boot, efi: Remove redundant memset()
> 
>  arch/x86/platform/efi/efi.c            | 2 +-
>  drivers/firmware/efi/efi-stub-helper.c | 2 --
>  2 files changed, 1 insertion(+), 3 deletions(-)

Pulled into tip:x86/efi, thanks Matt!

	Ingo
