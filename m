Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab3EHV5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:57:11 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39482 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab3EHV5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:57:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: GBGamer <npmazzuca@gmail.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        GBGamer <nicholas@mazzucastuff.com>
Subject: Re: [PATCH] ACPI: battery: Changed leading spaces to tab
Date: Thu, 09 May 2013 00:05:35 +0200
Message-ID: <4297619.TAqcfu2p5L@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1368029369-2115-1-git-send-email-nicholas@mazzucastuff.com>
References: <1368029369-2115-1-git-send-email-nicholas@mazzucastuff.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 08, 2013 09:09:29 AM GBGamer wrote:
> Fixed coding style problems in battery.c

First off, patches without a sign-off are not applicable.

Second, ->

> ---
>  drivers/acpi/battery.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index e710045..3c1784b 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -663,9 +663,9 @@ static void acpi_battery_quirks(struct acpi_battery *battery)
>  	if (test_bit(ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY, &battery->flags))
>  		return ;
>  
> -        if (battery->full_charge_capacity == 100 &&
> -            battery->rate_now == ACPI_BATTERY_VALUE_UNKNOWN &&
> -            battery->capacity_now >=0 && battery->capacity_now <= 100) {
> +	if (battery->full_charge_capacity == 100 &&
> +		battery->rate_now == ACPI_BATTERY_VALUE_UNKNOWN &&
> +		battery->capacity_now >=0 && battery->capacity_now <= 100) {

-> this isn't entirely correct, because the indentation pattern used in the
kernel for continuations of if () conditionals is one tab and four spaces
(whereas you've used two tabs).

>  		set_bit(ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY, &battery->flags);
>  		battery->full_charge_capacity = battery->design_capacity;
>  		battery->capacity_now = (battery->capacity_now *

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
