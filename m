Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaFEP01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:26:27 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39875 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaFEP0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:26:25 -0400
Date: Thu, 5 Jun 2014 16:26:20 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@stlinux.com,
        linux-pm@vger.kernel.org, eduardo.valentin@ti.com, rui.zhang@intel.com
Subject: Re: [STLinux Kernel] [PATCH 4/6] thermal: sti: Add support for ST's
 Memory Mapped based Thermal controller
Message-ID: <20140605152620.GD7446@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1401442715-6350-1-git-send-email-lee.jones@linaro.org>
 <1401442715-6350-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401442715-6350-5-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 30 May 2014, Lee Jones wrote:

> This is the traditional way of obtaining a device driver's register
> address space.  The aim of this driver is to supply controller specific
> information to the ST Thermal Core.
> 
> Signed-off-by: Ajit Pal Singh <ajitpal.singh@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/thermal/st/Kconfig             |   4 +
>  drivers/thermal/st/Makefile            |   1 +
>  drivers/thermal/st/st_thermal_memmap.c | 209 +++++++++++++++++++++++++++++++++
>  3 files changed, 214 insertions(+)
>  create mode 100644 drivers/thermal/st/st_thermal_memmap.c

For the rest of the series [4 to 6]: 
 Acked-by: Peter Griffin <peter.griffin@linaro.org>> 

regards,

Peter.
