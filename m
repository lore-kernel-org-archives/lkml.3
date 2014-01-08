Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbaAHNfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:35:21 -0500
Received: from 8bytes.org ([85.214.48.195]:38144 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756461AbaAHNfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:35:17 -0500
Date: Wed, 8 Jan 2014 14:35:15 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Rob Clark <robdclark@gmail.com>
Cc: iommu@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/msm: Fix link error with !MSM_IOMMU
Message-ID: <20140108133514.GG29041@8bytes.org>
References: <1389134846-1000-1-git-send-email-joro@8bytes.org>
 <20140107225345.GE29041@8bytes.org>
 <CAF6AEGtHR9-oy+xaZM2bbJHnqhrwHiZeAC+asc7+Ds0x_hJeNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGtHR9-oy+xaZM2bbJHnqhrwHiZeAC+asc7+Ds0x_hJeNQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Jan  8 14:35:15 2014
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 52cd541320862745933598
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 08:23:49AM -0500, Rob Clark wrote:
> On Tue, Jan 7, 2014 at 5:53 PM, Joerg Roedel <joro@8bytes.org> wrote:
> > On Tue, Jan 07, 2014 at 11:47:26PM +0100, Joerg Roedel wrote:
> >> The DRM driver for MSM depends on symbols from the MSM
> >> IOMMU driver. Add this dependency to the Kconfig file.
> >>
> >> Fixes this comile error:
> >>
> >>   Kernel: arch/arm/boot/zImage is ready
> >>   ERROR: "msm_iommu_get_ctx" [drivers/gpu/drm/msm/msm.ko]
> >>   undefined!
> >>   make[2]: *** [__modpost] Error 1
> 
> Thanks, I'll pull this into my pull req for 3.14 drm-next.. although,
> after chatting with Stephen Boyd, I think we should eventually be able
> to get rid of this (seems msm_iommu_get_ctx() was mainly for dealing
> with secure playback (?))

It is already in my next-branch. So if you are ok with the approach for
now there is no need for action. If you want it to go through your tree
anyway please let me know and I will drop it from mine.


	Joerg


