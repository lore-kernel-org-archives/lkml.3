Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbaKMIpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 03:45:12 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33284 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116AbaKMIpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 03:45:10 -0500
MIME-Version: 1.0
X-Originating-IP: [95.23.100.213]
In-Reply-To: <04e101cff29f$4021ea00$c065be00$@kernel.org>
References: <1414401440-10972-1-git-send-email-javier.martinez@collabora.co.uk>
	<04e101cff29f$4021ea00$c065be00$@kernel.org>
Date: Thu, 13 Nov 2014 09:45:09 +0100
Message-ID: <CABxcv=kaOa1+6a1n_+GjoH=PgG=LzAnXLU7U_E5NvYYP-0WedA@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: exynos_defconfig: Enable max77802 rtc and clock drivers
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Kukjin Kim <kgene@kernel.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>,
        Kevin Hilman <khilman@linaro.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kukjin,

On Tue, Oct 28, 2014 at 12:06 PM, Kukjin Kim <kgene@kernel.org> wrote:
> Javier Martinez Canillas wrote:
>> Commit 6e80e3d87549 ("ARM: exynos_defconfig: Enable MAX77802")
>> enabled support for the max77802 regulators but the PMIC also
>> has a Real-Time-Clock (RTC) and 2-channel 32kHz clock outputs.
>>
>
> I'll apply this, thanks.
>
> - Kukjin
>

You say that you will apply this patch but I can't find it in any of
your branches.

Best regards,
Javier
