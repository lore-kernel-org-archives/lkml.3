Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaEDSVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 14:21:34 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:64918 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaEDSVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 14:21:32 -0400
Date: Sun, 4 May 2014 20:21:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] EFI urgent fix
Message-ID: <20140504182127.GA15846@gmail.com>
References: <20140503055134.GV26088@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140503055134.GV26088@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> Folks, please pull the following patch from Dave that fixes some bugs in
> the EFI earlyprintk code when using ",keep".
> 
> The following changes since commit 47514c996fac5e6f13ef3a4c5e23f1c5cffabb7b:
> 
>   efi: Pass correct file handle to efi_file_{read,close} (2014-04-10 21:20:03 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> 
> for you to fetch changes up to 5f35eb0e29ca26da82febe49d7698dbeb8882ea0:
> 
>   x86/efi: earlyprintk=efi,keep fix (2014-05-03 06:39:06 +0100)
> 
> ----------------------------------------------------------------
>  * Fix earlyprintk=efi,keep support by switching to an ioremap() mapping
>    of the framebuffer when early_ioremap() is no longer available and
>    dropping __init from functions that may be invoked after
>    free_initmem() - Dave Young
> 
> ----------------------------------------------------------------
> Dave Young (1):
>       x86/efi: earlyprintk=efi,keep fix
> 
>  arch/x86/platform/efi/early_printk.c | 83 +++++++++++++++++++++++++++---------
>  1 file changed, 64 insertions(+), 19 deletions(-)

Pulled into tip:x86/urgent, thanks a lot Matt!

	Ingo
