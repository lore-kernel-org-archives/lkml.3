Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaHTUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:25:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:2085 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbaHTUZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:25:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,904,1400050800"; 
   d="scan'208";a="579501715"
Message-ID: <1408566324.26863.14.camel@rzwisler-mobl1.amr.corp.intel.com>
Subject: Re: [PATCH] x86: remove obsolete comment in uapi/e820.h
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Date: Wed, 20 Aug 2014 14:25:24 -0600
In-Reply-To: <1400521824-21040-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1400521824-21040-1-git-send-email-ross.zwisler@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-19 at 11:50 -0600, Ross Zwisler wrote:
> A comment introduced by this commit:
> 
> 028b785888c5 x86 boot: extend some internal memory map arrays to handle
> 	larger EFI input
> 
> had to do with some nested preprocessor directives.  The directives were
> split into separate files by this commit:
> 
> af170c5061dd  UAPI: (Scripted) Disintegrate arch/x86/include/asm
> 
> The comment explaining their interaction was retained and is now present
> in arch/x86/include/uapi/asm/e820.h.  This comment is no longer correct,
> so delete it.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> ---
>  arch/x86/include/uapi/asm/e820.h | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/e820.h b/arch/x86/include/uapi/asm/e820.h
> index bbae024..d993e33 100644
> --- a/arch/x86/include/uapi/asm/e820.h
> +++ b/arch/x86/include/uapi/asm/e820.h
> @@ -21,11 +21,6 @@
>   * this size.
>   */
>  
> -/*
> - * Odd: 'make headers_check' complains about numa.h if I try
> - * to collapse the next two #ifdef lines to a single line:
> - *	#if defined(__KERNEL__) && defined(CONFIG_EFI)
> - */
>  #ifndef __KERNEL__
>  #define E820_X_MAX E820MAX
>  #endif

Ping.  :)


