Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab3J2PV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:21:28 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64170 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949Ab3J2PV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 11:21:26 -0400
Date: Tue, 29 Oct 2013 08:21:22 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, mturquette@linaro.org, dwmw2@infradead.org,
        anton@enomsg.org, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        rob.herring@calxeda.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] mfd: as3722: add clock driver as mfd-sub device for
 the ams AS3722
Message-ID: <20131029152122.GD4231@lee--X1>
References: <1383049205-29620-1-git-send-email-ldewangan@nvidia.com>
 <1383049205-29620-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1383049205-29620-2-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Oct 2013, Laxman Dewangan wrote:

> Device ams AS3722 supports the one 32KHz clock output. The clock control
> support is provided through clock driver.
> 
> Add clock driver as mfd sub device to probe the clock driver.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  Documentation/devicetree/bindings/mfd/as3722.txt |    9 +++++++++
>  drivers/mfd/as3722.c                             |    3 +++

You need to seperate the DT binding from the drivers/mfd changes.

The MFD changes are fine of course.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
