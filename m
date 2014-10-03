Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613AbaJCXxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:53:14 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:12725 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759246AbaJCXxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 19:53:09 -0400
Date: Fri, 3 Oct 2014 16:53:21 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v5 0/4] Qualcomm SPMI PMIC pin controller drivers
Message-ID: <20141003235320.GC28481@sonymobile.com>
References: <1412181058-29179-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1412181058-29179-1-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 01 Oct 09:30 PDT 2014, Ivan T. Ivanov wrote:

> Changes since v4:
> 
> - Use PMIC name in compatible string.
> - PINCTRL_QCOM_SPMI_PMIC from Kconfig symbol.
> - Remove pmic string from drivers file names.
> - Fixed coding style issues.
> - Use qcom-spmi-gpio and qcom-spmi-mpp from dirver names,
>   to be similar to qcom-spmi-iadc, qcom-spmi-vadc and 
>   qcom-spmi-temp-alarm drivers.
> 
> Short description:
> 
> Patches adds pin control drivers for Multi-Purpose Pin (MPP) and
> General-purpose pin (GPIO) controllers found in Qualcomm SPMI based
> PMIC chips.
> 
> MPP's are enhanced GPIO's with analog circuits, which support 
> analog and digital input/output.
> 
> v4: https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg725568.html
> 
> Bjorn Andersson (1):
>   pinctrl: Device tree bindings for Qualcomm PMIC GPIO block
> 
> Ivan T. Ivanov (3):
>   pinctrl: Device tree bindings for Qualcomm PMIC MPP block
>   pinctrl: Qualcomm SPMI PMIC GPIO pin controller driver
>   pinctrl: Qualcomm SPMI PMIC MPP pin controller driver
> 
>  .../devicetree/bindings/pinctrl/qcom,pmic-gpio.txt | 215 +++++
>  .../devicetree/bindings/pinctrl/qcom,pmic-mpp.txt  | 162 ++++
>  drivers/pinctrl/qcom/Kconfig                       |  13 +
>  drivers/pinctrl/qcom/Makefile                      |   2 +
>  drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           | 937 ++++++++++++++++++++
>  drivers/pinctrl/qcom/pinctrl-spmi-mpp.c            | 953 +++++++++++++++++++++
>  include/dt-bindings/pinctrl/qcom,pmic-gpio.h       | 142 +++
>  include/dt-bindings/pinctrl/qcom,pmic-mpp.h        |  44 +
>  8 files changed, 2468 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pmic-gpio.txt
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pmic-mpp.txt
>  create mode 100644 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
>  create mode 100644 drivers/pinctrl/qcom/pinctrl-spmi-mpp.c
>  create mode 100644 include/dt-bindings/pinctrl/qcom,pmic-gpio.h
>  create mode 100644 include/dt-bindings/pinctrl/qcom,pmic-mpp.h
> 

This looks good and I gave it a spin on one of our 8974 devices and verified
that gpio_keys works :)

Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Regards,
Bjorn
