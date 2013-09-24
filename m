Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab3IXT2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 15:28:34 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59375 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab3IXT2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 15:28:33 -0400
Date: Tue, 24 Sep 2013 12:28:30 -0700
From: David Brown <davidb@codeaurora.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        "'Stephen Boyd'" <sboyd@codeaurora.org>,
        "'Joerg Roedel'" <joro@8bytes.org>, "'Suman Anna'" <s-anna@ti.com>
Subject: Re: [PATCH] iommu: remove unnecessary platform_set_drvdata()
Message-ID: <20130924192830.GA18207@codeaurora.org>
References: <001501ce9eda$5660b2c0$03221840$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <001501ce9eda$5660b2c0$03221840$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 10:53:01AM +0900, Jingoo Han wrote:
>The driver core clears the driver data to NULL after device_release
>or on probe failure. Thus, it is not needed to manually clear the
>device driver data to NULL.
>
>Signed-off-by: Jingoo Han <jg1.han@samsung.com>
>---
> drivers/iommu/msm_iommu_dev.c |    2 --

With the splitting:

Acked-by: David Brown <davidb@codeaurora.org>

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
