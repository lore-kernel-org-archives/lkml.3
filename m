Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab3LJHHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:07:34 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:55843 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab3LJHHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:07:32 -0500
MIME-Version: 1.0
In-Reply-To: <1386373528-13045-3-git-send-email-tim.kryger@linaro.org>
References: <1386373528-13045-1-git-send-email-tim.kryger@linaro.org>
	<1386373528-13045-3-git-send-email-tim.kryger@linaro.org>
Date: Mon, 9 Dec 2013 23:07:30 -0800
Message-ID: <CAEPRUYquqJ+y7+ZV12_uKnRq+XkoYZ7M7JNbsZBCPzVRGgGJ8w@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: dts: bcm28155-ap: Enable all the i2c busses
From: Christian Daudt <bcm@fixthebug.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied to armsoc/for-3.14/dt
 thanks,
   csd


On Fri, Dec 6, 2013 at 3:45 PM, Tim Kryger <tim.kryger@linaro.org> wrote:
> Enable all available i2c busses.
>
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Christian Daudt <csd@broadcom.com>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> ---
>  arch/arm/boot/dts/bcm28155-ap.dts | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
> index 08e47c2..bab302d 100644
> --- a/arch/arm/boot/dts/bcm28155-ap.dts
> +++ b/arch/arm/boot/dts/bcm28155-ap.dts
> @@ -27,6 +27,26 @@
>                 status = "okay";
>         };
>
> +       i2c@3e016000 {
> +               status="okay";
> +               clock-frequency = <400000>;
> +       };
> +
> +       i2c@3e017000 {
> +               status="okay";
> +               clock-frequency = <400000>;
> +       };
> +
> +       i2c@3e018000 {
> +               status="okay";
> +               clock-frequency = <400000>;
> +       };
> +
> +       i2c@3500d000 {
> +               status="okay";
> +               clock-frequency = <400000>;
> +       };
> +
>         sdio1: sdio@3f180000 {
>                 max-frequency = <48000000>;
>                 status = "okay";
> --
> 1.8.0.1
>
