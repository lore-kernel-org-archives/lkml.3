Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbbANKXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 05:23:21 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46313 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbbANKXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 05:23:20 -0500
Message-ID: <54B64375.3070406@ti.com>
Date: Wed, 14 Jan 2015 15:52:45 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Kevin Hilman <khilman@deeprootsystems.com>
CC: Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: arm: mach-davinci: cdce949.c:  Remove unused function
References: <1417906928-5728-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1417906928-5728-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rickard,

On Sunday 07 December 2014 04:32 AM, Rickard Strandqvist wrote:
> Remove the function cdce_set_rate() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  arch/arm/mach-davinci/cdce949.c              |   37 --------------------------
>  arch/arm/mach-davinci/include/mach/cdce949.h |    2 --
>  2 files changed, 39 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/cdce949.c b/arch/arm/mach-davinci/cdce949.c
> index abafb92..bccac4a 100644
> --- a/arch/arm/mach-davinci/cdce949.c
> +++ b/arch/arm/mach-davinci/cdce949.c
> @@ -212,43 +212,6 @@ static struct cdce_output output_list[] = {
>  	[5]	= { cdce_y5_freqs, ARRAY_SIZE(cdce_y5_freqs) },
>  };
>  
> -int cdce_set_rate(struct clk *clk, unsigned long rate)

Without this function, this driver is of no use. I can see that CDCE949
support has remained unused for long time. I would rather see the entire
support including cdce949.c and cdce949.h and their references removed.

Thanks,
Sekhar

