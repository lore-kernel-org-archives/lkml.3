Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3JHFnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 01:43:21 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:53309 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab3JHFnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 01:43:18 -0400
Date: Tue, 8 Oct 2013 07:43:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH v2 13/14] x86: select ARCH_MAY_HAVE_PC_PARPORT
Message-ID: <20131008054314.GD14353@gmail.com>
References: <1381209030-351-1-git-send-email-msalter@redhat.com>
 <1381209030-351-14-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381209030-351-14-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Salter <msalter@redhat.com> wrote:

> Architectures which support CONFIG_PARPORT_PC should select
> ARCH_MAY_HAVE_PC_PARPORT.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: x86@kernel.org
> ---
>  arch/x86/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index ee2fb9d..72fca40 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -22,6 +22,7 @@ config X86_64
>  config X86
>  	def_bool y
>  	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
> +	select ARCH_MAY_HAVE_PC_PARPORT
>  	select HAVE_AOUT if X86_32
>  	select HAVE_UNSTABLE_SCHED_CLOCK
>  	select ARCH_SUPPORTS_NUMA_BALANCING

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
