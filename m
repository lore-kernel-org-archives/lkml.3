Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751008AbaETVHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:07:30 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54599 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750735AbaETVH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:07:28 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: wsa@the-dreams.de, mika.westerberg@linux.intel.com, awilliam@redhat.com,
        lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V3 1/5] ACPICA: Export acpi_buffer_to_resource symbol
Date: Tue, 20 May 2014 23:24:24 +0200
Message-ID: <1782070.yxHZNBOPJ3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400590764-11108-2-git-send-email-tianyu.lan@intel.com>
References: <1400590764-11108-1-git-send-email-tianyu.lan@intel.com> <1400590764-11108-2-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 20, 2014 08:59:20 PM Lan Tianyu wrote:
> The acpi_buffer_to_resource is needed in i2c module
> to convert aml buffer to struct acpi_resource
> 
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

This isn't necessary on top of current linux-next I believe?  If so,
please do not resend it any more.

> ---
>  drivers/acpi/acpica/rscreate.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/acpi/acpica/rscreate.c b/drivers/acpi/acpica/rscreate.c
> index 75d3690..5828649 100644
> --- a/drivers/acpi/acpica/rscreate.c
> +++ b/drivers/acpi/acpica/rscreate.c
> @@ -112,6 +112,7 @@ acpi_buffer_to_resource(u8 *aml_buffer,
>  
>  	return (status);
>  }
> +ACPI_EXPORT_SYMBOL(acpi_buffer_to_resource);
>  
>  /*******************************************************************************
>   *
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
