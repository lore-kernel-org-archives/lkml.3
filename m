Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750988AbaIJEwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:52:46 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:41143 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaIJEwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:52:44 -0400
MIME-Version: 1.0
In-Reply-To: <1408533593-32346-6-git-send-email-javier.martinez@collabora.co.uk>
References: <1408533593-32346-1-git-send-email-javier.martinez@collabora.co.uk>
	<1408533593-32346-6-git-send-email-javier.martinez@collabora.co.uk>
Date: Tue, 9 Sep 2014 21:52:43 -0700
X-Google-Sender-Auth: 1fPGjtgsbUxUr02n-CCALt86MOE
Message-ID: <CAD=FV=WdMx=7oLChYz-y2cY=MBpJmT7KXBq_hMV7FS16VT+85w@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] ARM: dts: Add Peach Pit and Pi dts entry for
 ISL29018 sensor
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Wed, Aug 20, 2014 at 4:19 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> The Exynos5420 based Peach Pit and the Exynos5800 based Peach Pi
> machines have an i2c ISL29018 light sensor. This patch adds the
> device nodes needed to support this device.
>
> These DTS snippets were taken from the downstream Chrome OS 3.8
> kernel Device Tree for Peach Pit and Pi boards.
>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  arch/arm/boot/dts/exynos5420-peach-pit.dts | 6 ++++++
>  arch/arm/boot/dts/exynos5800-peach-pi.dts  | 6 ++++++
>  2 files changed, 12 insertions(+)

I would note that the downstream dts file has this i2c bus at 400kHz.
...but that's not a problem with your patch.  Perhaps you could submit
that as a separate patch?

Reviewed-by: Doug Anderson <dianders@chromium.org>
