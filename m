Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaK2FNI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 00:13:08 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41333 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaK2FNG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 00:13:06 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Lee Jones <lee.jones@linaro.org>, "Chanwoo Choi" <cw00.choi@samsung.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20141125155918.GO4241@x1>
Cc: broonie@kernel.org, a.zummo@towertech.it, lgirdwood@gmail.com,
        sbkim73@samsung.com, sameo@linux.intel.com, geunsik.lim@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com,
        k.kozlowski@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <1416301183-10478-1-git-send-email-cw00.choi@samsung.com>
 <20141125155918.GO4241@x1>
Message-ID: <20141129051302.8497.54128@quantum>
User-Agent: alot/0.3.5
Subject: Re: [GIT PULL] Immutable branch between MFD, Regulator and Clk, due for v3.19
Date: Fri, 28 Nov 2014 21:13:02 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Lee Jones (2014-11-25 07:59:18)
> Mark, Mike,
> 
> Please merge this into your trees for v3.19.
> 
> The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:
> 
>   Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/ib-mfd-regulator-clk-v3.19
> 
> for you to fetch changes up to 159a5e920446aed12fe373ecc3c7b3dc667091ae:
> 
>   mfd: s2mps11: Add binding documentation for Samsung S2MPS13 PMIC (2014-11-25 15:55:12 +0000)

Pulled.

Thanks,
Mike

> 
> ----------------------------------------------------------------
> Immutable branch between MFD, Regulator and Clk, due for v3.19
> 
> ----------------------------------------------------------------
> Chanwoo Choi (4):
>       mfd: sec-core: Add support for S2MPS13 device
>       regulator: s2mps11: Add support S2MPS13 regulator device
>       clk: s2mps11: Add the support for S2MPS13 PMIC clock
>       mfd: s2mps11: Add binding documentation for Samsung S2MPS13 PMIC
> 
>  Documentation/devicetree/bindings/mfd/s2mps11.txt |  22 +--
>  drivers/clk/clk-s2mps11.c                         |  24 +++
>  drivers/mfd/sec-core.c                            |  29 ++++
>  drivers/mfd/sec-irq.c                             |  23 ++-
>  drivers/regulator/Kconfig                         |  10 +-
>  drivers/regulator/s2mps11.c                       | 102 +++++++++++-
>  include/linux/mfd/samsung/core.h                  |   2 +
>  include/linux/mfd/samsung/s2mps13.h               | 186 ++++++++++++++++++++++
>  8 files changed, 374 insertions(+), 24 deletions(-)
>  create mode 100644 include/linux/mfd/samsung/s2mps13.h
> 
> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
