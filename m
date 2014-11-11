Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaKKKX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:23:29 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:37238 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaKKKX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:23:27 -0500
MIME-Version: 1.0
X-Originating-IP: [95.23.100.213]
In-Reply-To: <CABxcv==YZjO9p3aNyuRpe3DYS+=BcY_N2esuTg0hGASb_b_OdA@mail.gmail.com>
References: <1413839151-10875-1-git-send-email-javier.martinez@collabora.co.uk>
	<1413839151-10875-3-git-send-email-javier.martinez@collabora.co.uk>
	<CABxcv==YZjO9p3aNyuRpe3DYS+=BcY_N2esuTg0hGASb_b_OdA@mail.gmail.com>
Date: Tue, 11 Nov 2014 11:23:26 +0100
Message-ID: <CABxcv=mMqh5UD0_Wz3rNaFbZD3BH_2Z+7srzccd=-5_ndo_a1Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] ARM: EXYNOS: Call regulator core suspend prepare
 and finish functions
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>, Mark Brown <broonie@kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
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

On Thu, Oct 30, 2014 at 11:06 AM, Javier Martinez Canillas
<javier@dowhile0.org> wrote:
> Hello Kukjin,
>
> On Mon, Oct 20, 2014 at 11:05 PM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
>> The regulator framework has a set of helpers functions to be used when
>> the system is entering and leaving from suspend but these are not called
>> on Exynos platforms. This means that the .set_suspend_* function handlers
>> defined by regulator drivers are not called when the system is suspended.
>>
>> Suggested-by: Doug Anderson <dianders@chromium.org>
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> Reviewed-by: Doug Anderson <dianders@chromium.org>
>> ---
>>  arch/arm/mach-exynos/suspend.c | 23 +++++++++++++++++++++++
>>  1 file changed, 23 insertions(+)
>>
>
> Any comments on this patch?
>

Just a gentle reminder about this patch.

Best regards,
Javier
