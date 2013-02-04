Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab3BDGqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 01:46:08 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:55682 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3BDGqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 01:46:06 -0500
MIME-Version: 1.0
In-Reply-To: <1359935387-19065-1-git-send-email-amit.daniel@samsung.com>
References: <1359935387-19065-1-git-send-email-amit.daniel@samsung.com>
Date: Mon, 4 Feb 2013 12:16:05 +0530
Message-ID: <CAK9yfHx+9uu_aJTaFC2jLuFej_SvggWGDddDm-qKoetVfdfLYg@mail.gmail.com>
Subject: Re: [PATCH V3] regulator: add device tree support for s5m8767
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        amit.kachhap@gmail.com, Thomas Abraham <thomas.abraham@linaro.org>,
        kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 February 2013 05:19, Amit Daniel Kachhap <amit.daniel@samsung.com> wrote:
> This device tree support is added for PMIC block of S5m8767 multi
> function driver. The usage detail is added in the device tree
> documentation section. This change is tested on exynos5250 based
> arndale platform by regulator voltage set/get API's.
>
> Reviewed-by: Thomas Abraham <thomas.abraham@linaro.org>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Tested this patch using [1] on Exynos4412 based Origen board and it works fine.
Feel free to add Tested-by: Sachin Kamat <sachin.kamat@linaro.org> if needed.

[1] http://patches.linaro.org/14445/

-- 
With warm regards,
Sachin
