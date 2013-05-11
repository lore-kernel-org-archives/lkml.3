Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3EKV0L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 17:26:11 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:35308 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab3EKV0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 17:26:08 -0400
MIME-Version: 1.0
In-Reply-To: <003101ce4e1b$4acc0050$e06400f0$@samsung.com>
References: <003101ce4e1b$4acc0050$e06400f0$@samsung.com>
Date: Sat, 11 May 2013 14:26:07 -0700
X-Google-Sender-Auth: MX1wYeSkeCW-Gejtgo6AWFzWpRM
Message-ID: <CAD=FV=UjohPBxChbE2R4b8JWCbxZRXVx_9WuMYPgHTehMP6vvg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: dts: Document DP clock in samsung,exynos5-dp binding
From: Doug Anderson <dianders@chromium.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Paul <seanpaul@chromium.org>,
        =?ISO-8859-1?Q?St=E9phane_Marchesin?= <marcheu@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jingoo,

On Sat, May 11, 2013 at 12:43 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> The exynos5-dp node needs a clock specified using the common clock
> framework.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> Tested on Exynos5250
>
>  .../devicetree/bindings/video/exynos_dp.txt        |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)

Thanks for updating the bindings.  This looks good.

Reviewed-by: Doug Anderson <dianders@chromium.org>
