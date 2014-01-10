Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaAJKDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:03:55 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:40877 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaAJKDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:03:48 -0500
Date: Fri, 10 Jan 2014 10:03:42 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mark.rutland@arm.com, sbkim73@samsung.com, lgirdwood@gmail.com,
        broonie@kernel.org, patches@linaro.org
Subject: Re: [PATCH v2 1/3] mfd: Add support for S2MPA01 device
Message-ID: <20140110100342.GC28141@lee--X1>
References: <1389266554-23463-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389266554-23463-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add the necessary entries required for S2MPA01 multi-function
> device. While at it also convert whitespaces to tabs in core.h.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
> * Fixed nits pointed out by Lee.
> ---
>  drivers/mfd/sec-core.c              |   45 +++++++-
>  include/linux/mfd/samsung/core.h    |   16 ++-
>  include/linux/mfd/samsung/irq.h     |   50 +++++++++
>  include/linux/mfd/samsung/s2mpa01.h |  192 +++++++++++++++++++++++++++++++++++
>  4 files changed, 295 insertions(+), 8 deletions(-)
>  create mode 100644 include/linux/mfd/samsung/s2mpa01.h

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
