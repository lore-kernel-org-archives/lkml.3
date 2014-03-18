Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbaCRUcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:32:09 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:57223 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953AbaCRUcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:32:05 -0400
Date: Tue, 18 Mar 2014 20:31:59 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v3 2/3] mfd: sec-core: Add of_compatible strings for
 clock MFD cells
Message-ID: <20140318203159.GW25478@lee--X1>
References: <1395047958-17953-1-git-send-email-k.kozlowski@samsung.com>
 <1395047958-17953-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395047958-17953-3-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add of_compatible strings for S5M8767 and S2MPS14 clock MFD cells.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/sec-core.c |    3 +++
>  1 file changed, 3 insertions(+)

Applied with Tomasz' Reviewed-by.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
