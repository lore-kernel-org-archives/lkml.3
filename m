Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaK1Sow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:44:52 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:52630 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaK1Sov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:44:51 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] [RESEND 2] toshiba_acpi: Add missing ID (TOS6207)
Date: Fri, 28 Nov 2014 19:44:10 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Azael Avalos <coproscefalo@gmail.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Darren Hart <dvhart@infradead.org>
References: <1417165432-21691-1-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1417165432-21691-1-git-send-email-linux@rainbow-software.org>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201411281944.11309.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc: Darren Hart

On Friday 28 November 2014 10:03:52 Ondrej Zary wrote:
> toshiba_acpi was always missing TOS6207 ID so it did not load automatically
> on some laptops (such as Portege R100). But it worked fine if loaded
> manually. Commit 135740de7764 ("toshiba_acpi: Convert to use acpi_driver")
> broke that and the driver does not work even when loaded manually since
> then.
>
> Add TOS6207 ID to fix it.
>
> Tested on Toshiba Portege R100.
>
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/platform/x86/toshiba_acpi.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/platform/x86/toshiba_acpi.c
> b/drivers/platform/x86/toshiba_acpi.c index ab6151f..0ce2129 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -186,6 +186,7 @@ static struct toshiba_acpi_dev *toshiba_acpi;
>
>  static const struct acpi_device_id toshiba_device_ids[] = {
>  	{"TOS6200", 0},
> +	{"TOS6207", 0},
>  	{"TOS6208", 0},
>  	{"TOS1900", 0},
>  	{"", 0},


-- 
Ondrej Zary
