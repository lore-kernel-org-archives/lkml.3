Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3CMFwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 01:52:25 -0400
Received: from mail.southpole.se ([37.247.8.11]:45607 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab3CMFwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 01:52:23 -0400
Message-ID: <5140143C.1010601@southpole.se>
Date: Wed, 13 Mar 2013 06:53:00 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 16/17] openrisc: default GENERIC_GPIO to false
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com> <1363083150-30964-17-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1363083150-30964-17-git-send-email-acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.2.2(12343) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 53936-13067
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/13 11:12, Alexandre Courbot wrote:
> This is one step towards the removal of the GENERIC_GPIO option.
> OpenRISC mandates the use of GPIOLIB, which enables GENERIC_GPIO anyway,
> so this patch should be a no-op.

Acked-by: Jonas Bonn <jonas@southpole.se>

> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>   arch/openrisc/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
> index 28df179..5366bbf 100644
> --- a/arch/openrisc/Kconfig
> +++ b/arch/openrisc/Kconfig
> @@ -46,7 +46,7 @@ config NO_IOPORT
>   	def_bool y
>   
>   config GENERIC_GPIO
> -	def_bool y
> +	def_bool n
>   
>   config TRACE_IRQFLAGS_SUPPORT
>           def_bool y

