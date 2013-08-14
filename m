Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab3HNNP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:15:56 -0400
Received: from 8bytes.org ([85.214.48.195]:50629 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535Ab3HNNPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:15:54 -0400
Date: Wed, 14 Aug 2013 15:15:49 +0200
From: "'Joerg Roedel'" <joro@8bytes.org>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-samsung-soc@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Varun Sethi'" <Varun.Sethi@freescale.com>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] iommu/exynos: Follow kernel coding style for
 __sysmmu_enable return type
Message-ID: <20130814131547.GA5889@8bytes.org>
References: <1374766502-14823-1-git-send-email-a.motakis@virtualopensystems.com>
 <1374766502-14823-2-git-send-email-a.motakis@virtualopensystems.com>
 <003101ce89ed$52317330$f6945990$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003101ce89ed$52317330$f6945990$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Aug 14 15:15:52 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 520b830820866830314263
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KyongHo,

On Fri, Jul 26, 2013 at 07:46:01PM +0900, Cho KyongHo wrote:
> __sysmmu_enable() must return 1 if it is called with the same page table.
> I have fixed it exynos_iommu_attach_device() to always return zero on success
> in the next patchset which I will post today.
> 
> Thank you.

When you are fine with these patches please put them on-top of your
patch-set when you re-submit. I will take them from there then.


	Joerg


