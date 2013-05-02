Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab3EBVHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:07:47 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55559 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757189Ab3EBVHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:07:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: dl9pf@gmx.de
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH] Fix section to __init. Align with usage in acpixf.h . Fixes warning during compilation with clang.
Date: Thu, 02 May 2013 23:16:02 +0200
Message-ID: <27929805.ykWc87giNE@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1367314744-9659-1-git-send-email-dl9pf@gmx.de>
References: <1367314744-9659-1-git-send-email-dl9pf@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 30, 2013 11:39:04 AM dl9pf@gmx.de wrote:
> From: Jan-Simon Möller <dl9pf@gmx.de>
> 
> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>

I've queued this up for the v3.10-rc2 push.

Thanks,
Rafael


> ---
>  include/acpi/acpiosxf.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
> index 5b3d2bd..64b8c76 100644
> --- a/include/acpi/acpiosxf.h
> +++ b/include/acpi/acpiosxf.h
> @@ -77,7 +77,7 @@ struct acpi_signal_fatal_info {
>  /*
>   * OSL Initialization and shutdown primitives
>   */
> -acpi_status __initdata acpi_os_initialize(void);
> +acpi_status __init acpi_os_initialize(void);
>  
>  acpi_status acpi_os_terminate(void);
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
