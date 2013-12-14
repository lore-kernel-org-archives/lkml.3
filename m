Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3LNScf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 13:32:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53882 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab3LNSce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 13:32:34 -0500
Message-ID: <52ACA42C.9050800@zytor.com>
Date: Sat, 14 Dec 2013 10:32:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>, linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
Subject: Re: [PATCH 09/10] x86: select ARCH_MIGHT_HAVE_PC_SERIO
References: <1387040376-26906-1-git-send-email-msalter@redhat.com> <1387040376-26906-10-git-send-email-msalter@redhat.com>
In-Reply-To: <1387040376-26906-10-git-send-email-msalter@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2013 08:59 AM, Mark Salter wrote:
> Architectures which might use an i8042 for serial IO to keyboard,
> mouse, etc should select ARCH_MIGHT_HAVE_PC_SERIO.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: x86@kernel.org
> ---
>  arch/x86/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index e903c71..b7f0903 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -23,6 +23,7 @@ config X86
>  	def_bool y
>  	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
>  	select ARCH_MIGHT_HAVE_PC_PARPORT
> +	select ARCH_MIGHT_HAVE_PC_SERIO
>  	select HAVE_AOUT if X86_32
>  	select HAVE_UNSTABLE_SCHED_CLOCK
>  	select ARCH_SUPPORTS_NUMA_BALANCING
> 

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

