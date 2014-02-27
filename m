Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaB0IjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:39:05 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:65448 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaB0IjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 03:39:02 -0500
Date: Thu, 27 Feb 2014 08:38:56 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 8/8] devicetree: bindings: Document PM8921/8058 PMICs
Message-ID: <20140227083856.GB9195@lee--X1>
References: <1393441166-32692-1-git-send-email-sboyd@codeaurora.org>
 <1393441166-32692-9-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393441166-32692-9-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> PM8921 and PM8058 are PMICs found paired with MSM8960 and MSM8660
> devices respectively. They contain subdevices such as keypads,
> RTC, regulators, clocks, etc.
> 
> Cc: <devicetree@vger.kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  .../devicetree/bindings/mfd/qcom,pm8xxx.txt        | 63 ++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt

This patch has been on the MLs for some time now and hasn't received
any feedback from the DT guys.

Patch looks good (despite the lack IRQ defines), applied.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
