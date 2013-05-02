Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3EBIEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:04:05 -0400
Received: from smtp-out-229.synserver.de ([212.40.185.229]:1082 "EHLO
	smtp-out-227.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753754Ab3EBID4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:03:56 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 22215
Message-ID: <51821DC9.2010601@metafoo.de>
Date: Thu, 02 May 2013 10:03:21 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: eunb.song@samsung.com
CC: "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MIPS: Fix build error crash_dump.c file.
References: <21270808.191281367481634509.JavaMail.weblogic@epv6ml12>
In-Reply-To: <21270808.191281367481634509.JavaMail.weblogic@epv6ml12>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2013 10:00 AM, EUNBONG SONG wrote:
> 
> This patch fixes crash_dump.c build error.
> 

When fixing a compile error/warning you should always include the error
message in the commit log.

> Signed-off-by: Eunbong Song <eunb.song@samsung.com>
> ---
>  arch/mips/kernel/crash_dump.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/mips/kernel/crash_dump.c b/arch/mips/kernel/crash_dump.c
> index 35bed0d..3be9e7b 100644
> --- a/arch/mips/kernel/crash_dump.c
> +++ b/arch/mips/kernel/crash_dump.c
> @@ -2,6 +2,7 @@
>  #include <linux/bootmem.h>
>  #include <linux/crash_dump.h>
>  #include <asm/uaccess.h>
> +#include <linux/slab.h>
>  
>  static int __init parse_savemaxmem(char *p)
>  {

