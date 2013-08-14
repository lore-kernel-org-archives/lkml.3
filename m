Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab3HNK40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:56:26 -0400
Received: from 8bytes.org ([85.214.48.195]:50387 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932385Ab3HNK4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:56:21 -0400
Date: Wed, 14 Aug 2013 12:56:16 +0200
From: "'Joerg Roedel'" <joro@8bytes.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Cho KyongHo <pullip.cho@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 04/16] iommu/exynos: allocate lv2 page table from own
 slab
Message-ID: <20130814105615.GG4491@8bytes.org>
References: <002801ce941a$fb6369e0$f22a3da0$@samsung.com>
 <2544843.sndV7usHTj@amdc1227>
 <20130809145849.790a9800f4f9893b30e54a1c@samsung.com>
 <2101296.S6JDU5igl3@flatron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2101296.S6JDU5igl3@flatron>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Aug 14 12:56:20 2013
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 520b625420861551717623
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 09:55:30AM +0200, Tomasz Figa wrote:
> Oh, this is a valid point, but it was more a nitpick about the coding 
> style. Single path error handling (with goto) is widely used in the kernel 
> in cases when more than one thing has to be undone and so I suggested this 
> method of error handling here as well.

I agree with that review from Tomasz, the error-handling should look
similar to all the other places in the kernel and use goto.


	Joerg


