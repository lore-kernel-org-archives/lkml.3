Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbaDHUB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 16:01:26 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49537 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757352AbaDHUBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 16:01:25 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH V3] ACPI: Update the ownership and developers for ACPI in Kconfig
Date: Tue, 08 Apr 2014 22:17:23 +0200
Message-ID: <2622157.PU8Gid8IGF@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1396961988-27557-1-git-send-email-hanjun.guo@linaro.org>
References: <1396961988-27557-1-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 08, 2014 08:59:48 PM Hanjun Guo wrote:
> The UEFI Forum included the ACPI spec in its portfolio in October 2013
> and will host future spec iterations, following the ACPI v5.0a release.
> 
> A UEFI Forum working group named ACPI Specification Working Group (ASWG)
> has been established to handle future ACPI developments, any UEFI member
> can join the group and contribute to ACPI specification.
> 
> So update the ownership and developers for ACPI in Kconfig accordingly,
> and add another website link to ACPI specification too.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>

Applied, thanks!

> ---
>  drivers/acpi/Kconfig |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index c205653..ab686b3 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -31,10 +31,14 @@ menuconfig ACPI
>  	  ACPI CA, see:
>  	  <http://acpica.org/>
>  
> -	  ACPI is an open industry specification co-developed by
> -	  Hewlett-Packard, Intel, Microsoft, Phoenix, and Toshiba.
> +	  ACPI is an open industry specification originally co-developed by
> +	  Hewlett-Packard, Intel, Microsoft, Phoenix, and Toshiba. Currently,
> +	  it is developed by the ACPI Specification Working Group (ASWG) under
> +	  the UEFI Forum and any UEFI member can join the ASWG and contribute
> +	  to the ACPI specification.
>  	  The specification is available at:
>  	  <http://www.acpi.info>
> +	  <http://www.uefi.org/acpi/specs>
>  
>  if ACPI
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
