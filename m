Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaCXM30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 08:29:26 -0400
Received: from mx11.pku.edu.cn ([162.105.129.174]:53830 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752419AbaCXM3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:29:25 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.273
Date: Mon, 24 Mar 2014 20:29:19 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: gxt@mprc.pku.edu.cn, linux-kernel@vger.kernel.org
Message-ID: <1712256630.20489.1395664159391.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <53302268.4030002@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH]_arch/unico?=
 =?utf-8?Q?re32/mm/alignment.c:_in?=
 =?utf-8?Q?clude_"asm/pgtable.h"_to_avoid_compiling_error?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks,

Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>

----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> Need include "asm/pgtable.h" to include "asm-generic/pgtable-nopmd.h",
> so can let 'pmd_t' defined. The related error with allmodconfig:
> 
>     CC      arch/unicore32/mm/alignment.o
>   In file included from arch/unicore32/mm/alignment.c:24:
>   arch/unicore32/include/asm/tlbflush.h:135: error: expected ‘)’ before ‘*’ token
>   arch/unicore32/include/asm/tlbflush.h:154: error: expected ‘)’ before ‘*’ token
>   In file included from arch/unicore32/mm/alignment.c:27:
>   arch/unicore32/mm/mm.h:15: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘*’ token
>   arch/unicore32/mm/mm.h:20: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘*’ token
>   arch/unicore32/mm/mm.h:25: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘*’ token
>   make[1]: *** [arch/unicore32/mm/alignment.o] Error 1
>   make: *** [arch/unicore32/mm] Error 2
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/unicore32/mm/alignment.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/unicore32/mm/alignment.c b/arch/unicore32/mm/alignment.c
> index de7dc5f..24e8360 100644
> --- a/arch/unicore32/mm/alignment.c
> +++ b/arch/unicore32/mm/alignment.c
> @@ -21,6 +21,7 @@
>  #include <linux/sched.h>
>  #include <linux/uaccess.h>
>  
> +#include <asm/pgtable.h>
>  #include <asm/tlbflush.h>
>  #include <asm/unaligned.h>
>  
> -- 
> 1.7.9.5

