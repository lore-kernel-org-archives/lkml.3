Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab3IUPN3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 11:13:29 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:33828 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3IUPN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 11:13:27 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: linux-samsung-soc@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Tomasz Figa <t.figa@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Padmavathi Venna <padma.v@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] ARM: dts: exynos5250: add sclk_pcm_in to audss clock controller
Date: Sat, 21 Sep 2013 17:13:21 +0200
Message-ID: <1544025.3hYklZrZrS@flatron>
User-Agent: KMail/4.11.1 (Linux/3.11.1-gentoo; KDE/4.11.1; x86_64; ; )
In-Reply-To: <1379711637-5226-4-git-send-email-abrestic@chromium.org>
References: <1379711637-5226-1-git-send-email-abrestic@chromium.org> <1379711637-5226-4-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Friday 20 of September 2013 14:13:55 Andrew Bresticker wrote:
> The parent of sclk_pcm in the AudioSS block is div_pcm0.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
>  arch/arm/boot/dts/exynos5250.dtsi | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
> b/arch/arm/boot/dts/exynos5250.dtsi index 7d7cc77..bedc7a8 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -88,6 +88,8 @@
>  		compatible = "samsung,exynos5250-audss-clock";
>  		reg = <0x03810000 0x0C>;
>  		#clock-cells = <1>;
> +		clocks = <&clock 160>;
> +		clock-names = "sclk_pcm_in";

IMHO it would be reasonable to explicitly specify all the input clocks 
here.

Best regards,
Tomasz

