Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbaIQPYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:24:07 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:60785 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbaIQPYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:24:04 -0400
MIME-Version: 1.0
In-Reply-To: <1410954633-27025-2-git-send-email-javier.martinez@collabora.co.uk>
References: <1410954633-27025-1-git-send-email-javier.martinez@collabora.co.uk>
	<1410954633-27025-2-git-send-email-javier.martinez@collabora.co.uk>
Date: Wed, 17 Sep 2014 08:24:03 -0700
X-Google-Sender-Auth: Pu_0KDwBSEEoe_Bo62WCFiuPFsc
Message-ID: <CAD=FV=WctxZpkun4z8yZ89GrKoMZvvzcEPSLa9nrxEmjh_W1uw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: dts: Add rtc_src clk for s3c-rtc on exynos Peach boards
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Daniel Drake <drake@endlessm.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Wed, Sep 17, 2014 at 4:50 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> commit 546b117fdf17 ("rtc: s3c: add support for RTC of Exynos3250 SoC")
> added an "rtc_src" DT property for the Samsung's S3C Real Time Clock
> controller that specifies the 32.768 kHz clock that uses the RTC as its
> source clock. In the case of the Peach Pit and Pi machines, the Maxim
> 77802 32kHz AP clock is used as the source clock.
>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  arch/arm/boot/dts/exynos5420-peach-pit.dts | 5 ++++-
>  arch/arm/boot/dts/exynos5800-peach-pi.dts  | 5 ++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)

Reviewed-by: Doug Anderson <dianders@chromium.org>
