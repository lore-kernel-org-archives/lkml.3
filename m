Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab3CLM4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 08:56:07 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:42228 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab3CLM4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:56:05 -0400
Date: Tue, 12 Mar 2013 13:55:25 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 15/17] avr32: default GENERIC_GPIO to false
Message-ID: <20130312125524.GA13877@samfundet.no>
Mail-Followup-To: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	Linus Walleij <linus.walleij@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Russell King <linux@arm.linux.org.uk>,
	Haavard Skinnemoen <hskinnemoen@gmail.com>,
	Mike Frysinger <vapier@gentoo.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
	Josh Boyer <jwboyer@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Kumar Gala <galak@kernel.crashing.org>,
	Vitaly Bordug <vitb@kernel.crashing.org>,
	Marcelo Tosatti <marcelo@kvack.org>,
	Paul Mundt <lethal@linux-sh.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Alexandre Courbot <gnurou@gmail.com>, linux-kernel@vger.kernel.org
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
 <1363083150-30964-16-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363083150-30964-16-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 12 Mar 2013 19:12:28 +0900 or thereabout, Alexandre Courbot wrote:

$(Subject) is wrong, you state avr32, but it is for blackfin.

> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  arch/blackfin/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
> index 600494c..b947e26 100644
> --- a/arch/blackfin/Kconfig
> +++ b/arch/blackfin/Kconfig
> @@ -56,7 +56,7 @@ config ZONE_DMA
>  	def_bool y
>  
>  config GENERIC_GPIO
> -	def_bool y
> +	def_bool n
>  
>  config FORCE_MAX_ZONEORDER
>  	int
-- 
mvh
Hans-Christian Egtvedt
