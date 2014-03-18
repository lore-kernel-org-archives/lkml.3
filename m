Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbaCRJMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 05:12:53 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:34992 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbaCRJMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 05:12:51 -0400
Date: Tue, 18 Mar 2014 09:12:44 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, broonie@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 2/3] regulator: Add support for S2MPA01 regulator
Message-ID: <20140318091244.GI25478@lee--X1>
References: <1394797919-24642-1-git-send-email-sachin.kamat@linaro.org>
 <1394797919-24642-2-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394797919-24642-2-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add support for S2MPA01 voltage and current regulator.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Acked-by: Mark Brown <broonie@linaro.org>
> ---
> Changes since v3:
> Removed a redundant array and instead used a simple variable
> to check return value of devm_regulator_register.
> ---
>  drivers/regulator/Kconfig   |    7 +
>  drivers/regulator/Makefile  |    1 +
>  drivers/regulator/s2mpa01.c |  481 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 489 insertions(+)
>  create mode 100644 drivers/regulator/s2mpa01.c

Applied, thanks.

Mark,
  I will follow-up with a pull-request, necessary for conflict
  limitation in Kconfig and Makefile

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
