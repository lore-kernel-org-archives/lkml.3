Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab3EKVZU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 17:25:20 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:45172 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab3EKVZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 17:25:17 -0400
MIME-Version: 1.0
In-Reply-To: <003001ce4e1b$24a28fc0$6de7af40$@samsung.com>
References: <003001ce4e1b$24a28fc0$6de7af40$@samsung.com>
Date: Sat, 11 May 2013 14:25:15 -0700
X-Google-Sender-Auth: 0MS2bEuZakTHYntVZzCgcqEfLLE
Message-ID: <CAD=FV=V=exRoo1VAF5W7May_DFOWb6h_KL7BkqK3G2qmBQgUeA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: dts: add DP clock reference to exynos5250 device tree
From: Doug Anderson <dianders@chromium.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?St=E9phane_Marchesin?= <marcheu@chromium.org>,
        Sean Paul <seanpaul@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jingoo,

On Sat, May 11, 2013 at 12:42 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> The transition to common clock happened; however, DP (Display Port)
> clock node was not added. Thus, DP (Display Port) clock node should
> be added to the device tree.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> Tested on Exynos5250
>
>  arch/arm/boot/dts/exynos5250.dtsi |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

Clock number matches clock bindings for 5250 and clock name matches dp
driver, so this looks good.

Reviewed-by: Doug Anderson <dianders@chromium.org>
