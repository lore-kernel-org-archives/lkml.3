Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516Ab3HNJaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:30:14 -0400
Received: from 8bytes.org ([85.214.48.195]:50071 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab3HNJaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:30:12 -0400
Date: Wed, 14 Aug 2013 11:30:01 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Grant Grundler <grundler@chromium.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/exynos: remove dead code (set_prefbuf)
Message-ID: <20130814093000.GA4491@8bytes.org>
References: <1372781307-7906-1-git-send-email-grundler@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372781307-7906-1-git-send-email-grundler@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Aug 14 11:30:10 2013
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 520b4e2220862027911972
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 09:08:27AM -0700, Grant Grundler wrote:
> exynos_sysmmu_set_prefbuf() is not called any where.
> 
> Signed-off-by: Grant Grundler <grundler@chromium.org>
> ---
>  drivers/iommu/exynos-iommu.c | 44 --------------------------------------------
>  1 file changed, 44 deletions(-)

Applied to arm/exynos, thanks.


