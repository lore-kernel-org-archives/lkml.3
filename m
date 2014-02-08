Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaBHOsz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 09:48:55 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49661 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751272AbaBHOsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 09:48:54 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: linux-acpi@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 1/2] ACPI / processor: Replace hard-coded "ACPI0007" with ACPI_PROCESSOR_DEVICE_HID
Date: Sat, 08 Feb 2014 16:03:29 +0100
Message-ID: <3206968.bZnklzZdTg@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1391863586-3157-1-git-send-email-hanjun.guo@linaro.org>
References: <1391863586-3157-1-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 08, 2014 08:46:25 PM Hanjun Guo wrote:
> Replace "ACPI0007" with ACPI_PROCESSOR_DEVICE_HID to improve code
> readability.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  drivers/acpi/processor_core.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
> index a4eea9a..849cfd6 100644
> --- a/drivers/acpi/processor_core.c
> +++ b/drivers/acpi/processor_core.c
> @@ -390,5 +390,6 @@ void __init acpi_early_processor_set_pdc(void)
>  	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
>  			    ACPI_UINT32_MAX,
>  			    early_init_pdc, NULL, NULL, NULL);
> -	acpi_get_devices("ACPI0007", early_init_pdc, NULL, NULL);
> +	acpi_get_devices(ACPI_PROCESSOR_DEVICE_HID,
> +				early_init_pdc, NULL, NULL);

Please don't break this line (I know it will exceed 80 characters).

>  }
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
