Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaFWJih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:38:37 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:47922 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbaFWJif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:38:35 -0400
Date: Mon, 23 Jun 2014 02:38:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Chen Gang <gang.chen.5i5j@gmail.com>
cc: Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/score/include/uapi/asm/ptrace.h: Add prefix 'SCORE_'
 for related macros
In-Reply-To: <53A66000.4010208@gmail.com>
Message-ID: <alpine.DEB.2.02.1406230237330.8821@chino.kir.corp.google.com>
References: <53A66000.4010208@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2014, Chen Gang wrote:

> diff --git a/arch/score/include/uapi/asm/ptrace.h b/arch/score/include/uapi/asm/ptrace.h
> index f59771a..7a0ead9 100644
> --- a/arch/score/include/uapi/asm/ptrace.h
> +++ b/arch/score/include/uapi/asm/ptrace.h
> @@ -4,16 +4,16 @@
>  #define PTRACE_GETREGS		12
>  #define PTRACE_SETREGS		13
>  
> -#define PC		32
> -#define CONDITION	33
> -#define ECR		34
> -#define EMA		35
> -#define CEH		36
> -#define CEL		37
> -#define COUNTER		38
> -#define LDCR		39
> -#define STCR		40
> -#define PSR		41
> +#define SCORE_PC		32
> +#define SCORE_CONDITION		33
> +#define SCORE_ECR		34
> +#define SCORE_EMA		35
> +#define SCORE_CEH		36
> +#define SOCRE_CEL		37

SOCRE?

> +#define SCORE_COUNTER		38
> +#define SCORE_LDCR		39
> +#define SCORE_STCR		40
> +#define SCORE_PSR		41
>  
>  #define SINGLESTEP16_INSN	0x7006
>  #define SINGLESTEP32_INSN	0x840C8000

This is a uapi header file, what was done to ensure this doesn't introduce 
userspace breakage?
