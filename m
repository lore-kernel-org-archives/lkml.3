Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaDOIIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:08:40 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:49855 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998AbaDOIIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:08:36 -0400
Message-ID: <1397549314.1985.7.camel@x220>
Subject: Re: [PATCH] [TRIVIAL] Kconfig: Remove useless "default N" lines
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: Martin Walch <walch.martin@web.de>, Richard Weinberger <richard@nod.at>,
        linux-kernel@vger.kernel.org
Date: Tue, 15 Apr 2014 10:08:34 +0200
In-Reply-To: <1392122327.13064.14.camel@x220>
References: <1392122327.13064.14.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2014 08:08:35.0136 (UTC) FILETIME=[E6178400:01CF5881]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

On Tue, 2014-02-11 at 13:38 +0100, Paul Bolle wrote:
> A number of Kconfig entries default to (uppercase) "N". It was clearly
> intended to use "default n". But since (lowercase) "n" is the default
> anyway, these lines might as well be removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>[...]
> 
>  arch/arc/Kconfig                          | 1 -
>  arch/cris/arch-v32/drivers/Kconfig        | 2 --
>  drivers/misc/mic/Kconfig                  | 2 --
>  drivers/staging/android/Kconfig           | 2 --
>  drivers/staging/bcm/Kconfig               | 1 -
>  drivers/staging/frontier/Kconfig          | 1 -
>  drivers/staging/media/go7007/Kconfig      | 3 ---
>  drivers/staging/rtl8187se/Kconfig         | 1 -
>  drivers/staging/rtl8188eu/Kconfig         | 1 -
>  drivers/staging/rtl8192e/rtl8192e/Kconfig | 1 -
>  drivers/staging/rtl8192u/Kconfig          | 1 -
>  drivers/staging/rtl8712/Kconfig           | 2 --
>  drivers/staging/rtl8821ae/Kconfig         | 1 -

This file wasn't touched by our commit c7dcec7dd463 ("Kconfig: Remove
useless "default N" lines"). Any idea why?

>  drivers/staging/usbip/Kconfig             | 4 ----
>  drivers/usb/core/Kconfig                  | 1 -
>  drivers/usb/host/Kconfig                  | 3 ---
>  16 files changed, 27 deletions(-)
> 
> [...]
>
> diff --git a/drivers/staging/rtl8821ae/Kconfig b/drivers/staging/rtl8821ae/Kconfig
> index 2aa5dac..4679fd8 100644
> --- a/drivers/staging/rtl8821ae/Kconfig
> +++ b/drivers/staging/rtl8821ae/Kconfig
> @@ -6,6 +6,5 @@ config R8821AE
>  	select WEXT_PRIV
>  	select EEPROM_93CX6
>  	select CRYPTO
> -	default N
>  	---help---
>  	  If built as a module, it will be called r8821ae.ko.

So this "default N" statement is still present in v3.15-rc1.

Paul Bolle

