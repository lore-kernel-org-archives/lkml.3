Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaEFR7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:59:14 -0400
Received: from 8bytes.org ([85.214.48.195]:33000 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbaEFR7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:59:12 -0400
Date: Tue, 6 May 2014 19:59:05 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Shaik Ameer Basha <shaik.samsung@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        "supash.ramaswamy" <supash.ramaswamy@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, sunil joshi <joshi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: Re: [PATCH v12 00/31] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Message-ID: <20140506175904.GB12376@8bytes.org>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
 <26065037.GxQQuIURPg@wuerfel>
 <CAOD6ATqZ5UwRwSKiPDQLrgmX=UUrJVE7ybM_RhXz_CEUjM3W7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOD6ATqZ5UwRwSKiPDQLrgmX=UUrJVE7ybM_RhXz_CEUjM3W7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue May  6 19:59:10 2014
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 536922ee20861145049544
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 04:27:10PM +0530, Shaik Ameer Basha wrote:
> This series is going on for quite a long time and most of the patches here
> doesn't depend on dt bindings. As Exynos IOMMU h/w is introducing new versions
> very frequently, maintaining and reviewing all these patches again and
> again is quite a hard job.
> 
> If it is acceptable, I can post one more series with the subset of
> above patches,
> which doesn't depend on dt-bindings. As all the patches which doesn't depend on
> DT bindings are already tested,  I hope merging these subset of patches may help
> in reducing the rework and review effort every time.
> 
> Once we finalize the generic DT bindings for the IOMMU devices, the driver
> can be updated with the proposed DT bindings in mind.

Sounds reasonable to me if the patch subset is self-contained. When
Arnd is OK with that and no one else has objections I can take the
dt-independend parts.


	Joerg


