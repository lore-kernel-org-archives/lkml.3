Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbaI2U4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:56:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39627 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaI2U4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:56:07 -0400
Date: Mon, 29 Sep 2014 13:56:04 -0700
From: Darren Hart <dvhart@infradead.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] dell-smo8800: Add more acpi ids and change description
 of driver
Message-ID: <20140929205604.GA34181@vmdeb7>
References: <1411994748-11229-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411994748-11229-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 02:45:48PM +0200, Pali Rohár wrote:

Please see Documentation/SubmittingPatches, 15) The canonical patch format, and
provide a complete message body.

Have you validated each of the 6 ACPI IDs added to the driver?


> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  drivers/platform/x86/Kconfig        |    4 ++--
>  drivers/platform/x86/dell-smo8800.c |   10 ++++++++--
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 3bbcbf1..ba9ee4f 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -128,10 +128,10 @@ config DELL_WMI_AIO
>  	  be called dell-wmi-aio.
>  
>  config DELL_SMO8800
> -	tristate "Dell Latitude freefall driver (ACPI SMO8800/SMO8810)"
> +	tristate "Dell Latitude freefall driver (ACPI SMO88XX)"
>  	depends on ACPI
>  	---help---
> -	  Say Y here if you want to support SMO8800/SMO8810 freefall device
> +	  Say Y here if you want to support SMO88XX freefall device

"devices" now that multiple are supported.

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
