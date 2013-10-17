Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762527Ab3JQS2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 14:28:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48668 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758204Ab3JQS2d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 14:28:33 -0400
Subject: Re: [PATCHv6 2/4] ARM: msm: Add support for APQ8074 Dragonboard
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1382034310-31147-1-git-send-email-rvaswani@codeaurora.org>
Date: Thu, 17 Oct 2013 13:28:29 -0500
Cc: David Brown <davidb@codeaurora.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <86B14DE9-F72B-4B4F-AD7F-AA53792435AE@codeaurora.org>
References: <1382034310-31147-1-git-send-email-rvaswani@codeaurora.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 17, 2013, at 1:25 PM, Rohit Vaswani wrote:

> This patch adds basic board support for APQ8074 Dragonboard
> which belongs to the Snapdragon 800 family.
> For now, just support a basic machine with device tree.
> 
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
> arch/arm/boot/dts/Makefile                     |  3 ++-
> arch/arm/boot/dts/qcom-apq8074-dragonboard.dts |  6 +++++
> arch/arm/boot/dts/qcom-msm8974.dtsi            | 33 ++++++++++++++++++++++++++
> arch/arm/mach-msm/Kconfig                      | 11 ++++++++-
> arch/arm/mach-msm/board-dt.c                   |  9 +++++++
> 5 files changed, 60 insertions(+), 2 deletions(-)
> create mode 100644 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
> create mode 100644 arch/arm/boot/dts/qcom-msm8974.dtsi

Acked-by: Kumar Gala <galak@codeaurora.org>

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

