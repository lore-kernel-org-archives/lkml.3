Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaFEMZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:25:16 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:57483 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaFEMZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:25:14 -0400
Date: Thu, 5 Jun 2014 13:25:07 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@stlinux.com,
        linux-pm@vger.kernel.org, eduardo.valentin@ti.com, rui.zhang@intel.com
Subject: Re: [STLinux Kernel] [PATCH 1/6] thermal: sti: Supply Device Tree
 documentation
Message-ID: <20140605122507.GA24240@lee--X1>
References: <1401442715-6350-1-git-send-email-lee.jones@linaro.org>
 <1401442715-6350-2-git-send-email-lee.jones@linaro.org>
 <20140605120147.GA7446@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140605120147.GA7446@griffinp-ThinkPad-X1-Carbon-2nd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2014, Peter Griffin wrote:

> Hi Lee,
> 
> > +Example:
> > +
> > +	temp1@fdfe8000 {
> > +		compatible	= "st,stih416-mpe-thermal";
> > +		reg		= <0xfdfe8000 0x10>;
> > +		clock-names	= "thermal";
> > +		clocks		= <&CLK_M_MPETHSENS>;
> > +		interrupts	= <GIC_SPI 23 IRQ_TYPE_NONE>;
> > +	};
> 
> With the renaming of the STI device tree from upper to lower
> case. The clock name in this example also needs updating.

You're right.  Will rebase and fix.

> Once fixed: -
>  Acked-by: Peter Griffin <peter.griffin@linaro.org>
> 
> Regards,
> 
> Peter

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
