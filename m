Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab3I0QC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:02:57 -0400
Received: from 8bytes.org ([85.214.48.195]:51604 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab3I0QC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:02:56 -0400
Date: Fri, 27 Sep 2013 18:02:53 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Rob Clark <robdclark@gmail.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 3/3] Fix compile error in drivers/gpu/drm/msm/msm_drv.c
 with IOMMU disabled
Message-ID: <20130927160253.GE20372@8bytes.org>
References: <1380120582-9068-1-git-send-email-joro@8bytes.org>
 <1380120582-9068-3-git-send-email-joro@8bytes.org>
 <CAF6AEGsf3eM1pXhgWeiV8kJOQyvhRSmp7RkETRgBWSzBPEwjGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGsf3eM1pXhgWeiV8kJOQyvhRSmp7RkETRgBWSzBPEwjGQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Sep 27 18:02:54 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5245ac2e20861615111635
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Fri, Sep 27, 2013 at 11:28:36AM -0400, Rob Clark wrote:
> But I am not the right one to merge this one.  And, well, if there is
> a way to make this work without msm_iommu_get_ctx(), I am interested
> in some hints ;-)
> 
> Of the other two, 1/3 looks fine and I'll pull that in.  And I'll see
> if I can come up with a better way for 2/3

Yeah, patch 2/3 was not meant very seriously, it was more a way to say
that someone should fix it who knows the best way how to do it ;)
Thanks for your review and taking 1/3.


	Joerg


