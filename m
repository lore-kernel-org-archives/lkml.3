Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab3ILTOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:14:11 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:60827 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab3ILTN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:13:59 -0400
Message-ID: <5232126F.90907@twiddle.net>
Date: Thu, 12 Sep 2013 12:13:51 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        vgupta@synopsys.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
        jejb@parisc-linux.org, benh@kernel.crashing.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH] Kconfig cleanup (PARPORT_PC dependencies)
References: <1379012038-31764-1-git-send-email-msalter@redhat.com>
In-Reply-To: <1379012038-31764-1-git-send-email-msalter@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 11:53 AM, Mark Salter wrote:
> diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
> index 082d9b4..0f8fa2c 100644
> --- a/arch/alpha/Kconfig
> +++ b/arch/alpha/Kconfig
> @@ -520,6 +520,9 @@ config EISA
>  config ARCH_MAY_HAVE_PC_FDC
>  	def_bool y
>  
> +config ARCH_MAY_HAVE_PC_PARPORT
> +	def_bool y
> +

Acked-by: Richard Henderson <rth@twiddle.net>


r~
