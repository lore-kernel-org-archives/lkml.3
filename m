Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbaFEMBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:01:53 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:56225 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaFEMBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:01:51 -0400
Date: Thu, 5 Jun 2014 13:01:47 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@stlinux.com,
        linux-pm@vger.kernel.org, eduardo.valentin@ti.com, rui.zhang@intel.com
Subject: Re: [STLinux Kernel] [PATCH 1/6] thermal: sti: Supply Device Tree
 documentation
Message-ID: <20140605120147.GA7446@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1401442715-6350-1-git-send-email-lee.jones@linaro.org>
 <1401442715-6350-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401442715-6350-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

> +Example:
> +
> +	temp1@fdfe8000 {
> +		compatible	= "st,stih416-mpe-thermal";
> +		reg		= <0xfdfe8000 0x10>;
> +		clock-names	= "thermal";
> +		clocks		= <&CLK_M_MPETHSENS>;
> +		interrupts	= <GIC_SPI 23 IRQ_TYPE_NONE>;
> +	};

With the renaming of the STI device tree from upper to lower
case. The clock name in this example also needs updating.

Once fixed: -
 Acked-by: Peter Griffin <peter.griffin@linaro.org>

Regards,

Peter
