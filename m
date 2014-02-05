Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaBEBIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 20:08:12 -0500
Received: from outbound-mail02.westnet.com.au ([203.10.1.243]:4872 "EHLO
	outbound-mail02.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751678AbaBEBIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 20:08:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBACKM8VKVhxBY/2dsb2JhbAANTMI6gR+DGQEBAQR5EAsYCSUPAkYGDQEFAgEBtAiiIxeOdQeEOASuCw
X-IronPort-AV: E=Sophos;i="4.95,783,1384272000"; 
   d="scan'208";a="391823944"
X-WN-REMOTEIP: 149.135.16.88
X-WN-ENVELOPESENDER: gerg@uclinux.org
X-WN-MID: 391823944
X-WN-SMTPAUTHID: gregungerer
Message-ID: <52F18CF5.40301@uclinux.org>
Date: Wed, 05 Feb 2014 10:59:33 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] m68k: Sort arch/m68k/include/asm/Kbuild
References: <1391544954-7422-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1391544954-7422-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/14 06:15, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>

> ---
>  arch/m68k/include/asm/Kbuild |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
> index 7cc8c364924d..df4d46fc321b 100644
> --- a/arch/m68k/include/asm/Kbuild
> +++ b/arch/m68k/include/asm/Kbuild
> @@ -1,4 +1,3 @@
> -
>  generic-y += bitsperlong.h
>  generic-y += clkdev.h
>  generic-y += cputime.h
> @@ -6,6 +5,7 @@ generic-y += device.h
>  generic-y += emergency-restart.h
>  generic-y += errno.h
>  generic-y += exec.h
> +generic-y += hash.h
>  generic-y += hw_irq.h
>  generic-y += ioctl.h
>  generic-y += ipcbuf.h
> @@ -18,6 +18,7 @@ generic-y += local.h
>  generic-y += mman.h
>  generic-y += mutex.h
>  generic-y += percpu.h
> +generic-y += preempt.h
>  generic-y += resource.h
>  generic-y += scatterlist.h
>  generic-y += sections.h
> @@ -31,5 +32,3 @@ generic-y += trace_clock.h
>  generic-y += types.h
>  generic-y += word-at-a-time.h
>  generic-y += xor.h
> -generic-y += preempt.h
> -generic-y += hash.h
> 

