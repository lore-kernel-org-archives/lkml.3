Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaB0Iet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:34:49 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:52614 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaB0Ieq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 03:34:46 -0500
Date: Thu, 27 Feb 2014 08:34:38 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 3/8] mfd: pm8921: Migrate to irqdomains
Message-ID: <20140227083438.GW9195@lee--X1>
References: <1393441166-32692-1-git-send-email-sboyd@codeaurora.org>
 <1393441166-32692-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393441166-32692-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014, Stephen Boyd wrote:

> Convert this driver to use irqdomains so that the PMIC's child
> devices can be converted to devicetree.
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/mfd/Kconfig               |   1 +
>  drivers/mfd/pm8921-core.c         | 198 +++++++++++++++-----------------------
>  include/linux/mfd/pm8xxx/irq.h    |  36 -------
>  include/linux/mfd/pm8xxx/pm8921.h |  30 ------
>  4 files changed, 76 insertions(+), 189 deletions(-)
>  delete mode 100644 include/linux/mfd/pm8xxx/irq.h
>  delete mode 100644 include/linux/mfd/pm8xxx/pm8921.h

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
