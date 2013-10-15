Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912Ab3JOXH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 19:07:56 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49489 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933756Ab3JOXHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 19:07:54 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH] ACPI: remove /proc/acpi/event from ACPI_BUTTON help
Date: Wed, 16 Oct 2013 01:19:44 +0200
Message-ID: <1437541.HIvFumZpN0@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1381615860-1882-1-git-send-email-krzysiek@podlesie.net>
References: <1381615860-1882-1-git-send-email-krzysiek@podlesie.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 13, 2013 12:11:00 AM Krzysztof Mazur wrote:
> The commit 1696d9dc57e062ce5200f6a42a6aaada15b434bb
> ("ACPI: Remove the old /proc/acpi/event interface")
> removed the old /proc/acpi/event interface but did not remove
> /proc/acpi/event from ACPI_BUTTON help.
> 
> Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>

I've queued this up as a fix for 3.12.

Thanks!

> ---
>  drivers/acpi/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 22327e6..4e9e98b 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -123,9 +123,9 @@ config ACPI_BUTTON
>  	default y
>  	help
>  	  This driver handles events on the power, sleep, and lid buttons.
> -	  A daemon reads /proc/acpi/event and perform user-defined actions
> -	  such as shutting down the system.  This is necessary for
> -	  software-controlled poweroff.
> +	  A daemon reads events from input devices or via netlink and
> +	  perform user-defined actions such as shutting down the system.
> +	  This is necessary for software-controlled poweroff.
>  
>  	  To compile this driver as a module, choose M here:
>  	  the module will be called button.
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
