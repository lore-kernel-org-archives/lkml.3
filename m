Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaJJROn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 13:14:43 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:34448 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaJJROl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 13:14:41 -0400
MIME-Version: 1.0
In-Reply-To: <1409672443-4289-4-git-send-email-gdjakov@mm-sol.com>
References: <1409672443-4289-1-git-send-email-gdjakov@mm-sol.com>
	<1409672443-4289-4-git-send-email-gdjakov@mm-sol.com>
Date: Fri, 10 Oct 2014 10:14:34 -0700
Message-ID: <CAJAp7OhV82HyDQSRW4F2z6UD6WZzuopBoUZMeT2pYBdGq-Dqcg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ARM: dts: qcom: Add SDHC nodes for APQ8084 platform
From: Bjorn Andersson <bjorn@kryo.se>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 8:40 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:
> Enable support for the two SD host controllers on the APQ8084 platform
> by adding the required nodes to the DT files.
> On the IFC6540 board, the first controller is connected to the onboard
> eMMC and the second is connected to a micro-SD card slot.
>
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>

Hi Georgi,

This looks sane, but...

> ---
>  arch/arm/boot/dts/qcom-apq8084-ifc6540.dts |   11 +++++++++++
>  arch/arm/boot/dts/qcom-apq8084.dtsi        |   23 +++++++++++++++++++++++
>  2 files changed, 34 insertions(+)
>
> diff --git a/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
> index e41cb8a..c9ff108 100644
> --- a/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
> +++ b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
[..]
> +               sdhci@f98a4900 {
> +                       cd-gpios = <&tlmm 122 GPIO_ACTIVE_LOW>;
> +                       bus-width = <4>;

...why do you add this node and leave it disabled in the dts?

> +               };
>         };
>  };

Regards,
Bjorn
