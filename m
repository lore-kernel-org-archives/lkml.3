Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaBCPqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:46:19 -0500
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:34890 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753029AbaBCPqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:46:16 -0500
Message-ID: <1391442358.3509.19.camel@linaro1.home>
Subject: Re: [PATCH v5 16/16] ARM: Remove uprobes dependency on kprobes
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        davem@davemloft.net, Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date: Mon, 03 Feb 2014 15:45:58 +0000
In-Reply-To: <1390507559-4697-17-git-send-email-dave.long@linaro.org>
References: <1390507559-4697-1-git-send-email-dave.long@linaro.org>
	 <1390507559-4697-17-git-send-email-dave.long@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-23 at 15:05 -0500, David Long wrote:
> From: "David A. Long" <dave.long@linaro.org>
> 
> Now that arm uprobes support has been made separate from the arm kprobes code
> the Kconfig can be changed to reflect that.
> 
> Signed-off-by: David A. Long <dave.long@linaro.org>
> ---
>  arch/arm/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index fec5a6b..9ddc4ae 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -204,7 +204,6 @@ config NEED_DMA_MAP_STATE
>         def_bool y
>  
>  config ARCH_SUPPORTS_UPROBES
> -	depends on KPROBES
>  	def_bool y
>  
>  config ARCH_HAS_DMA_SET_COHERENT_MASK


Was this patch meant to have other contents? If not, it seems a bit
pointless as all it does is remove a line added in the previous patch,
so should just be folded into that one.

-- 
Tixy


