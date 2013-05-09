Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab3EII0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:26:22 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47624 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3EII0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:26:20 -0400
Message-ID: <518B5DA9.7010006@zankel.net>
Date: Thu, 09 May 2013 01:26:17 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Max Filippov <jcmvbkbc@gmail.com>, linux-xtensa@linux-xtensa.org,
        linux-kernel@vger.kernel.org
Subject: [merged] Re: [PATCH 3/3] xtensa: Switch to asm-generic/linkage.h
References: <1367920653-18626-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1367920653-18626-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should make it to Linus' tree shortly.

Thanks,
-Chris
On 05/07/2013 02:57 AM, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  arch/xtensa/include/asm/Kbuild    |    1 +
>  arch/xtensa/include/asm/linkage.h |   16 ----------------
>  2 files changed, 1 insertions(+), 16 deletions(-)
>  delete mode 100644 arch/xtensa/include/asm/linkage.h
>
> diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
> index 095f0a2..1b98264 100644
> --- a/arch/xtensa/include/asm/Kbuild
> +++ b/arch/xtensa/include/asm/Kbuild
> @@ -15,6 +15,7 @@ generic-y += irq_regs.h
>  generic-y += kdebug.h
>  generic-y += kmap_types.h
>  generic-y += kvm_para.h
> +generic-y += linkage.h
>  generic-y += local.h
>  generic-y += local64.h
>  generic-y += percpu.h
> diff --git a/arch/xtensa/include/asm/linkage.h b/arch/xtensa/include/asm/linkage.h
> deleted file mode 100644
> index bf2128a..0000000
> --- a/arch/xtensa/include/asm/linkage.h
> +++ /dev/null
> @@ -1,16 +0,0 @@
> -/*
> - * include/asm-xtensa/linkage.h
> - *
> - * This file is subject to the terms and conditions of the GNU General Public
> - * License.  See the file "COPYING" in the main directory of this archive
> - * for more details.
> - *
> - * Copyright (C) 2001 - 2005 Tensilica Inc.
> - */
> -
> -#ifndef _XTENSA_LINKAGE_H
> -#define _XTENSA_LINKAGE_H
> -
> -/* Nothing to do here ... */
> -
> -#endif	/* _XTENSA_LINKAGE_H */

