Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaIXLSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:18:55 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:65112 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaIXLSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:18:52 -0400
MIME-Version: 1.0
In-Reply-To: <1410229968-11638-2-git-send-email-aaron.lu@intel.com>
References: <1410229968-11638-1-git-send-email-aaron.lu@intel.com>
	<1410229968-11638-2-git-send-email-aaron.lu@intel.com>
Date: Wed, 24 Sep 2014 13:18:52 +0200
Message-ID: <CACRpkdaJjqs9WNcVvjsSWhzLD2QpcyR11MVm4xhm4GqB28eOCA@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio / CrystalCove: support virtual GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lejun Zhu <lejun.zhu@intel.com>,
        Radivoje Jovanovic <radivoje.jovanovic@intel.com>,
        =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <dg@emlix.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 4:32 AM, Aaron Lu <aaron.lu@intel.com> wrote:

> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index c1d4105e1c1d..383ade1a211b 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -27,7 +27,7 @@
>   */
>
>  #ifndef ARCH_NR_GPIOS
> -#define ARCH_NR_GPIOS          256
> +#define ARCH_NR_GPIOS          512
>  #endif

I have applied another patch from Mika for this, so remove this
hunk of the patch.

Yours,
Linus Walleij
