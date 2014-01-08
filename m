Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbaAHVg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:36:56 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60379 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529AbaAHVgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:36:54 -0500
Date: Wed, 8 Jan 2014 21:36:49 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 3/7] mfd: pm8921: Migrate to irqdomains
Message-ID: <20140108213649.GB18611@lee--X1>
References: <1389206270-3728-1-git-send-email-sboyd@codeaurora.org>
 <1389206270-3728-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389206270-3728-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Jan 2014, Stephen Boyd wrote:

> Convert this driver to use irqdomains so that the PMIC's child
> devices can be converted to devicetree.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/mfd/pm8921-core.c         | 198 +++++++++++++++-----------------------
>  include/linux/mfd/pm8xxx/irq.h    |  36 -------
>  include/linux/mfd/pm8xxx/pm8921.h |  30 ------
>  3 files changed, 75 insertions(+), 189 deletions(-)
>  delete mode 100644 include/linux/mfd/pm8xxx/irq.h
>  delete mode 100644 include/linux/mfd/pm8xxx/pm8921.h

I'm still a little dubious over the lack of an irq_create_mapping()
call, but if you say you've tested it and it works I guess something
else must be going on in its place.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
