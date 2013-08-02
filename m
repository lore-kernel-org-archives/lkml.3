Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3HBKlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:41:47 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:52115 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030228Ab3HBKLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:11:17 -0400
Date: Fri, 2 Aug 2013 11:11:12 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] MFD: ucb1x00-core: add CONFIG_PM_SLEEP to suspend/resume
Message-ID: <20130802101112.GB17368@lee--X1>
References: <000501ce8f43$7cc948b0$765bda10$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000501ce8f43$7cc948b0$765bda10$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Aug 2013, Jingoo Han wrote:

> Add CONFIG_PM_SLEEP to suspend/resume functions to fix the build
> warnings when CONFIG_PM_SLEEP is not selected. This is because
> sleep PM callbacks defined by SET_SYSTEM_SLEEP_PM_OPS are only used
> when the CONFIG_PM_SLEEP is enabled.
> 
> drivers/mfd/ucb1x00-core.c:672:12: warning: 'ucb1x00_suspend' defined but not used [-Wunused-function]
> drivers/mfd/ucb1x00-core.c:704:12: warning: 'ucb1x00_resume' defined but not used [-Wunused-function]
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/ucb1x00-core.c |    2 ++
>  1 file changed, 2 insertions(+)

Looks fine to me. Applied, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
