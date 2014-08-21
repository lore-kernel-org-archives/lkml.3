Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaHUPis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:38:48 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:63918 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaHUPir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:38:47 -0400
Date: Thu, 21 Aug 2014 16:38:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lgirdwood@gmail.com, broonie@kernel.org,
        a.zummo@towertech.it, mturquette@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com
Subject: Re: [PATCH v3 2/5] MFD: RK808: Add new mfd driver for RK808
Message-ID: <20140821153836.GO4266@lee--X1>
References: <1408627817-16171-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408627817-16171-1-git-send-email-zyw@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2014, Chris Zhong wrote:
> The RK808 chip is a power management IC for multimedia and handheld
> devices. It contains the following components:
> 
> - Regulators
> - RTC
> 
> The rk808 core driver is registered as a platform driver and provides
> communication through I2C with the host device for the different
> components.
> 
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> 
> ---
> 
> Changes in v3: None

Why haven't you fixed up my review comments?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
