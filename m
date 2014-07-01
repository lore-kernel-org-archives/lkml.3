Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbaGACHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 22:07:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:35582 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbaGACHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 22:07:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,578,1400050800"; 
   d="scan'208";a="536877490"
Message-ID: <1404180423.8366.15.camel@rzhang1-toshiba>
Subject: Re: [PATCH 0/6] thermal: sti: Add new Thermal driver
From: Zhang Rui <rui.zhang@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, eduardo.valentin@gmail.com, ajitpal.singh@st.com,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com
Date: Tue, 01 Jul 2014 10:07:03 +0800
In-Reply-To: <1401442715-6350-1-git-send-email-lee.jones@linaro.org>
References: <1401442715-6350-1-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Eduardo,

what do you think of this patch set?

thanks,
rui

On Fri, 2014-05-30 at 10:38 +0100, Lee Jones wrote:
> This patchset adds full support for 2 types of Thermal Controllers
> produced by STMicroelectronics.  One is a more traditional memory
> mapped variant, the other is controlled solely by system configuration
> registers.
> 
>  Documentation/devicetree/bindings/thermal/st-thermal.txt |  42 ++++++++++++++++
>  arch/arm/boot/dts/stih416.dtsi                           |  18 +++++++
>  arch/arm/configs/multi_v7_defconfig                      |   2 +
>  drivers/thermal/Kconfig                                  |   5 ++
>  drivers/thermal/Makefile                                 |   1 +
>  drivers/thermal/st/Kconfig                               |  12 +++++
>  drivers/thermal/st/Makefile                              |   3 ++
>  drivers/thermal/st/st_thermal.c                          | 313 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/thermal/st/st_thermal.h                          | 104 ++++++++++++++++++++++++++++++++++++++
>  drivers/thermal/st/st_thermal_memmap.c                   | 209 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/thermal/st/st_thermal_syscfg.c                   | 179 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  11 files changed, 888 insertions(+)
> 


