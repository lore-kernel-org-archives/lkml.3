Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbaF3QJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:09:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52662 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbaF3QJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:09:19 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH v4] clk: qcom: Add support for IPQ8064's global clock controller (GCC)
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1403034411-13781-1-git-send-email-galak@codeaurora.org>
Date: Mon, 30 Jun 2014 11:08:33 -0500
Cc: devicetree@vger.kernel.org, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org, agross@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6639D384-040E-498A-8C0B-B3FAF47692ED@codeaurora.org>
References: <1403034411-13781-1-git-send-email-galak@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 17, 2014, at 2:46 PM, Kumar Gala <galak@codeaurora.org> wrote:

> Add a driver for the global clock controller found on IPQ8064 based
> platforms. This should allow most non-multimedia device drivers to probe
> and control their clocks.
> 
> This is currently missing clocks for USB HSIC and networking devices.
> 
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> Signed-off-by: Andy Gross <agross@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> v4:
> * Fix usb utmi freq clk table
> * Fix numbering issue in dt-bindings/clock/qcom,gcc-ipq806x.h
> 
> v3:
> * Based on APQ8084 clk patches
> * Added USB3 and SATA clks
> * Minor clean ups (made hex numbers lowercase)
> 
> v2:
> * dropped audio clock from commit message
> * changed Kconfig symbol to IPQ_GCC_806X
> * Fixed PXO/CXO clk freq to 25Mhz
> 
> .../devicetree/bindings/clock/qcom,gcc.txt         |    1 +
> drivers/clk/qcom/Kconfig                           |    8 +
> drivers/clk/qcom/Makefile                          |    1 +
> drivers/clk/qcom/gcc-ipq806x.c                     | 2424 ++++++++++++++++++++
> include/dt-bindings/clock/qcom,gcc-ipq806x.h       |  293 +++
> include/dt-bindings/reset/qcom,gcc-ipq806x.h       |  132 ++
> 6 files changed, 2859 insertions(+)
> create mode 100644 drivers/clk/qcom/gcc-ipq806x.c
> create mode 100644 include/dt-bindings/clock/qcom,gcc-ipq806x.h
> create mode 100644 include/dt-bindings/reset/qcom,gcc-ipq806x.h

Mike,

Any update on pulling this in?

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

