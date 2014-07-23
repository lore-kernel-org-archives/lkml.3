Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbaGWWqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:46:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47604 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbaGWWqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:46:37 -0400
Message-ID: <53D03B30.2020509@ti.com>
Date: Wed, 23 Jul 2014 17:46:08 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Vutla, Lokesh" <lokeshvutla@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "paul@pwsan.com" <paul@pwsan.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Nori, Sekhar" <nsekhar@ti.com>, "J, KEERTHY" <j-keerthy@ti.com>,
        "Menon, Nishanth" <nm@ti.com>, "Quadros, Roger" <rogerq@ti.com>
Subject: Re: [PATCH 1/2] ARM: DRA7: Add support for soc_is_dra74x() and soc_is_dra72x()
 varients
References: <1405499774-19770-1-git-send-email-lokeshvutla@ti.com> <1405499774-19770-2-git-send-email-lokeshvutla@ti.com>
In-Reply-To: <1405499774-19770-2-git-send-email-lokeshvutla@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 03:36 AM, Vutla, Lokesh wrote:
> From: Rajendra Nayak <rnayak@ti.com>
> 
> Use the corresponding compatibles to identify the devices.
> 
> Signed-off-by: Rajendra Nayak <rnayak@ti.com>
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> ---
>  arch/arm/mach-omap2/soc.h |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/soc.h b/arch/arm/mach-omap2/soc.h
> index 01ca808..5e1be94 100644
> --- a/arch/arm/mach-omap2/soc.h
> +++ b/arch/arm/mach-omap2/soc.h
> @@ -245,6 +245,8 @@ IS_AM_SUBCLASS(437x, 0x437)
>  #define soc_is_omap54xx()		0
>  #define soc_is_omap543x()		0
>  #define soc_is_dra7xx()			0
> +#define soc_is_dra74x()			0
> +#define soc_is_dra72x()			0
>  
>  #if defined(MULTI_OMAP2)
>  # if defined(CONFIG_ARCH_OMAP2)
> @@ -393,7 +395,12 @@ IS_OMAP_TYPE(3430, 0x3430)
>  
>  #if defined(CONFIG_SOC_DRA7XX)
>  #undef soc_is_dra7xx
> +#undef soc_is_dra74x
> +#undef soc_is_dra72x
>  #define soc_is_dra7xx()	(of_machine_is_compatible("ti,dra7"))
> +#define soc_is_dra74x()	(of_machine_is_compatible("ti,dra74"))
> +#define soc_is_dra72x()	(of_machine_is_compatible("ti,dra72"))
> +
nit, can you remove this extra blank line when you repost.

regards
Suman
>  #endif
>  
>  /* Various silicon revisions for omap2 */
> 

