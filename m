Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaA2Uu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 15:50:56 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:46302 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaA2Uux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 15:50:53 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:b13b:1c47:4c90:eb03]
In-Reply-To: <1391016574-25237-4-git-send-email-k.debski@samsung.com>
References: <1391016574-25237-1-git-send-email-k.debski@samsung.com>
	<1391016574-25237-4-git-send-email-k.debski@samsung.com>
Date: Wed, 29 Jan 2014 12:50:53 -0800
Message-ID: <CAOesGMh8qEumWGb_mVuiSTWE=tsEusntG5r9xL3Z+f_WUnBQSw@mail.gmail.com>
Subject: Re: [PATCH v6 3/8] dts: Add usb2phy to Exynos 4
From: Olof Johansson <olof@lixom.net>
To: Kamil Debski <k.debski@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, Jingoo Han <jg1.han@samsung.com>,
        Kumar Gala <galak@codeaurora.org>,
        Matt Porter <matt.porter@linaro.org>, tjakobi@math.uni-bielefeld.de,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 9:29 AM, Kamil Debski <k.debski@samsung.com> wrote:
> Add support to PHY of USB2 of the Exynos 4 SoC.
>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  .../devicetree/bindings/arm/samsung/pmu.txt        |    2 ++
>  arch/arm/boot/dts/exynos4.dtsi                     |   31 ++++++++++++++++++++
>  arch/arm/boot/dts/exynos4210.dtsi                  |   17 +++++++++++
>  arch/arm/boot/dts/exynos4x12.dtsi                  |   17 +++++++++++
>  4 files changed, 67 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/arm/samsung/pmu.txt b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
> index 307e727..a76f91d 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/pmu.txt
> +++ b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
> @@ -3,6 +3,8 @@ SAMSUNG Exynos SoC series PMU Registers
>  Properties:
>   - name : should be 'syscon';
>   - compatible : should contain two values. First value must be one from following list:
> +                  - "samsung,exynos4210-pmu" - for Exynos4210 SoC,
> +                  - "samsung,exynos4x12-pmu" - for Exynos4212 SoC,
>                    - "samsung,exynos5250-pmu" - for Exynos5250 SoC,
>                    - "samsung,exynos5420-pmu" - for Exynos5420 SoC.
>                 second value must be always "syscon".

This and other PMU related bindings/dts changes should probably go in
separate patch(es) instead of being snuck in with USB changes.


-Olof
