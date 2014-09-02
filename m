Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaIBPyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:54:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40910 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbaIBPyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:54:37 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v2 0/3] ARM: dts: qcom: Add initial IFC6540 board support
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1409672443-4289-1-git-send-email-gdjakov@mm-sol.com>
Date: Tue, 2 Sep 2014 10:54:30 -0500
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        iivanov@mm-sol.com
Content-Transfer-Encoding: 8BIT
Message-Id: <18B16782-6CB7-4F62-A0AA-422A796A7F9E@codeaurora.org>
References: <1409672443-4289-1-git-send-email-gdjakov@mm-sol.com>
To: Georgi Djakov <gdjakov@mm-sol.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 2, 2014, at 10:40 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:

> Add basic support for the IFC6540 single-board computer boards, that are
> based on the APQ8084 SoC. The first patch adds the initial device tree.
> The second enables the serial console. The third adds the SDHC nodes and
> enables the eMMC.
> 
> Should go through the qcom/arm-soc tree.
> 
> Changes since v1:
> - This time add linux-arm-msm list to the CC.
> - Include a third patch for enabling the eMMC.
> 
> Georgi Djakov (3):
>  ARM: dts: qcom: Add initial IFC6540 board device tree
>  ARM: dts: qcom: Enable serial port on IFC6540 boards
>  ARM: dts: qcom: Add SDHC nodes for APQ8084 platform
> 
> arch/arm/boot/dts/Makefile                 |    1 +
> arch/arm/boot/dts/qcom-apq8084-ifc6540.dts |   23 +++++++++++++++++++++++
> arch/arm/boot/dts/qcom-apq8084.dtsi        |   23 +++++++++++++++++++++++
> 3 files changed, 47 insertions(+)
> create mode 100644 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
> 
> -- 
> 1.7.9.5
> 

Thanks, there is really no reason for these to be 3 patches, can you squash them down into one.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

