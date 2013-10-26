Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab3JZGsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 02:48:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60819 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab3JZGsR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 02:48:17 -0400
Subject: Re: [PATCH 3/3] ARM: dts: Add TMON driver support to bcm281xx
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1382745629-1123-4-git-send-email-wendy.ng@broadcom.com>
Date: Sat, 26 Oct 2013 01:48:32 -0500
Cc: "Rob Herring" <rob.herring@calxeda.com>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Eduardo Valentin" <eduardo.valentin@ti.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Christian Daudt" <bcm@fixthebug.org>,
        "Markus Mayer" <mmayer@broadcom.com>,
        "Tim Kryger" <tim.kryger@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <282032D7-DE51-4313-BED7-4D2B2D2DE1C0@codeaurora.org>
References: <1382745629-1123-1-git-send-email-wendy.ng@broadcom.com> <1382745629-1123-4-git-send-email-wendy.ng@broadcom.com>
To: Wendy Ng <wendy.ng@broadcom.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 25, 2013, at 7:00 PM, Wendy Ng wrote:

> 
> +	tmon: tmon@34008000 {
> +		compatible = "brcm,bcm11351-tmon", "brcm,kona-tmon";
> +		reg = <0x34008000 0x0024>;
> +		clocks = <&tmon_1m_clk>;
> +		interrupts = <GIC_SPI 183 IRQ_TYPE_LEVEL_HIGH>;
> +		#thermal-sensor-cells = <0>;

Where is #thermal-sensor-cells documented?

> +		status = "disabled";
> +	};
> +

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

