Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaBOAnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 19:43:09 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55729 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752896AbaBOAnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 19:43:05 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI, APEI: Remove X86 redundant dependency for APEI Generic Hardware Error Source.
Date: Sat, 15 Feb 2014 01:57:48 +0100
Message-ID: <1611441.dxrnOY2zmW@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392049416-31240-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1392049416-31240-1-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 10, 2014 05:23:36 PM Tomasz Nowicki wrote:
> ACPI_APEI is already dependent on X86, hence, there is no need to
> define such dependency for ACPI_APEI_GHES again.
> 
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>

Tony, Boris, if you're fine with this, I'll take it for 3.15.

> ---
>  drivers/acpi/apei/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
> index 786294b..1d7ca6e 100644
> --- a/drivers/acpi/apei/Kconfig
> +++ b/drivers/acpi/apei/Kconfig
> @@ -13,7 +13,7 @@ config ACPI_APEI
>  
>  config ACPI_APEI_GHES
>  	bool "APEI Generic Hardware Error Source"
> -	depends on ACPI_APEI && X86
> +	depends on ACPI_APEI
>  	select ACPI_HED
>  	select IRQ_WORK
>  	select GENERIC_ALLOCATOR
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
