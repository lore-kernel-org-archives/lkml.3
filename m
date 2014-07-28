Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaG1G5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:57:52 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:57848 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaG1G5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:57:50 -0400
Date: Mon, 28 Jul 2014 07:57:44 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v2 1/3] regulator: s2mpxxx: Move regulator min/step
 voltages in common place
Message-ID: <20140728065744.GD5273@lee--X1>
References: <1405422173-15050-1-git-send-email-amit.daniel@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405422173-15050-1-git-send-email-amit.daniel@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Amit Daniel Kachhap wrote:

> This is a cleanup patch and moves min/step voltages in a common samsung
> header file so that they can be used by other s2mpxxx PMIC drivers. Only
> few required macros are added currently and others can be added if needed.
> 
> Cc: Sangbeom Kim <sbkim73@samsung.com>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
> Changes since v1:
> * Added Cc to maintainers.
> * Added Krzysztof reviewed-by.
> 
>  drivers/regulator/s2mpa01.c         | 32 ++++++++++++------------
>  drivers/regulator/s2mps11.c         | 50 ++++++++++++++++++-------------------
>  include/linux/mfd/samsung/core.h    | 21 ++++++++++++++++
>  include/linux/mfd/samsung/s2mpa01.h | 12 ---------
>  include/linux/mfd/samsung/s2mps11.h |  9 -------
>  include/linux/mfd/samsung/s2mps14.h | 10 --------
>  6 files changed, 62 insertions(+), 72 deletions(-)

For the MFD changes:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
