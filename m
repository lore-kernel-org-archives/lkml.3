Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab3G3SwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:52:18 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:36392 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757691Ab3G3SwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:52:16 -0400
Date: Tue, 30 Jul 2013 20:52:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] urgent fix
Message-ID: <20130730185212.GA21687@gmail.com>
References: <20130729080836.GD2515@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729080836.GD2515@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:
> 
>   Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> 
> for you to fetch changes up to df981edcb9bce00b9c5e4f3cc33f3f98bc9a2394:
> 
>   x86, efi: correct call to free_pages (2013-07-26 15:22:32 +0100)
> 
> ----------------------------------------------------------------
>  * The size of memory that gets freed by free_pages() needs to be
>    specified in pages, not bytes - Roy Franz.
> 
> ----------------------------------------------------------------
> Roy Franz (1):
>       x86, efi: correct call to free_pages
> 
>  arch/x86/boot/compressed/eboot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Pulled into tip:x86/urgent, thanks Matt!

	Ingo
