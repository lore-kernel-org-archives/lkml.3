Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaIJEtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:49:01 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:61153 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaIJEs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:48:57 -0400
MIME-Version: 1.0
In-Reply-To: <1408533593-32346-5-git-send-email-javier.martinez@collabora.co.uk>
References: <1408533593-32346-1-git-send-email-javier.martinez@collabora.co.uk>
	<1408533593-32346-5-git-send-email-javier.martinez@collabora.co.uk>
Date: Tue, 9 Sep 2014 21:48:56 -0700
X-Google-Sender-Auth: VbhB7XAYazztFrhTuv1GxdESQ9A
Message-ID: <CAD=FV=VMRHoNs3wDGRi4snwowc8F6xAD27uv57r51Rd7hEEeOA@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ARM: dts: Add thermistor dts fragment used by
 exynos based Peach boards
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

Javier / Naveen,

On Wed, Aug 20, 2014 at 4:19 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>
> This patch creates a thermistor fragment carrying the NTC Thermistor
> nodes as children of the IIO based ADC.
>
> This fragment is included in exynos5420-peach-pit.dts and
> exynos5800-peach-pi.dts.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  arch/arm/boot/dts/cros-adc-thermistors.dtsi | 44 +++++++++++++++++++++++++++++
>  arch/arm/boot/dts/exynos5420-peach-pit.dts  |  6 ++++
>  arch/arm/boot/dts/exynos5800-peach-pi.dts   |  6 ++++
>  3 files changed, 56 insertions(+)

Reviewed-by: Doug Anderson <dianders@chromium.org>
