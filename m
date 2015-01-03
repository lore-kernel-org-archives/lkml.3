Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbbACMFX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 07:05:23 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60354 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbbACMFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 07:05:22 -0500
Date: Sat, 3 Jan 2015 13:05:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86,setup: Rename myisspace to isspace and move it to
 ctype.h
Message-ID: <20150103120520.GB30723@pd.tnic>
References: <1420269005-2290-1-git-send-email-kuleshovmail@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420269005-2290-1-git-send-email-kuleshovmail@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2015 at 01:10:05PM +0600, Alexander Kuleshov wrote:
> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
> ---
>  arch/x86/boot/cmdline.c | 19 +++++++------------
>  arch/x86/boot/ctype.h   |  5 +++++
>  2 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/boot/cmdline.c b/arch/x86/boot/cmdline.c
> index 625d21b..bc1e25f 100644
> --- a/arch/x86/boot/cmdline.c
> +++ b/arch/x86/boot/cmdline.c
> @@ -14,11 +14,6 @@
>  
>  #include "boot.h"
>  
> -static inline int myisspace(u8 c)
> -{
> -	return c <= ' ';	/* Close enough approximation */
> -}
> -

This is called myisspace on purpose so that it doesn't get confused with
the libc version. This patch is unnecessary IMO.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
