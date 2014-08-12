Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbaHLR0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:26:48 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:54484 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbaHLR0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:26:46 -0400
MIME-Version: 1.0
In-Reply-To: <1407861868-20097-4-git-send-email-javier.martinez@collabora.co.uk>
References: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk>
	<1407861868-20097-4-git-send-email-javier.martinez@collabora.co.uk>
Date: Tue, 12 Aug 2014 10:26:45 -0700
X-Google-Sender-Auth: RyhRmWyAUDnTro3WpS1-M3YzUKU
Message-ID: <CAD=FV=XNsQ_8h-d8epU_gzWRH=A49a8iuirWCUe4TO6VGCvDSw@mail.gmail.com>
Subject: Re: [PATCH 3/6] ARM: dts: Create cros-tps65090 fragment
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Tue, Aug 12, 2014 at 9:44 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> The tps65090 PMU is a component used in many ChromeOS devices
> so instead of having the same device tree definitions in many
> files, create a .dtsi fragment that can be included in DTS.
>
> This fragment is based on the DT definitions for Peach boards.
>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  arch/arm/boot/dts/cros-tps65090.dtsi | 81 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 81 insertions(+)
>  create mode 100644 arch/arm/boot/dts/cros-tps65090.dtsi

I'd probably skip this patch (just have duplication in pit vs. pi), or
make it "peach" specific (like exynos-peach-tps65090.dtsi?).  This is
really board-specific info and trying to guess what the various FETs
are going to be for for all peach variants doesn't seem great.

-Doug
