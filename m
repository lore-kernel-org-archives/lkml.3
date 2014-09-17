Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbaIQW5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:57:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49003 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbaIQW5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:57:13 -0400
Date: Wed, 17 Sep 2014 15:57:11 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        Georgi Djakov <gdjakov@mm-sol.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>
Subject: Re: [PATCH] mmc: sdhci-msm: Make tuning block table endian agnostic
Message-ID: <20140917225711.GD10233@codeaurora.org>
References: <1409752622-7564-1-git-send-email-sboyd@codeaurora.org>
 <5407F364.9030303@samsung.com>
 <CAPDyKFp0LwK=DABHaP-Ke=QZFP8bY5MO9RnYmUBqeEdDKp63BA@mail.gmail.com>
 <5408D81C.7070602@codeaurora.org>
 <5408E074.7090008@samsung.com>
 <20140904220126.GC28256@codeaurora.org>
 <54175E06.1030203@codeaurora.org>
 <CAPDyKFomqt5OMBvnFw6+h=R-PP7pywMb0XbFe1sheSXV=VENug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFomqt5OMBvnFw6+h=R-PP7pywMb0XbFe1sheSXV=VENug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18, Ulf Hansson wrote:
> 2014-09-15 23:45 GMT+02:00 Stephen Boyd <sboyd@codeaurora.org>:
> > On 09/04/14 15:01, Stephen Boyd wrote:
> >>
> >> ----8<----
> >> From: Stephen Boyd <sboyd@codeaurora.org>
> >> Subject: [PATCH] mmc: Consolidate emmc tuning blocks
> >>
> >> The same tuning block array exists in the dw_mmc h.c and sdhci-msm.c
> >> files. Move these into mmc.c so that they can be shared across
> >> drivers.
> >>
> >> Reported-by: Jaehoon Chung <jh80.chung@samsung.com>
> >> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> >> ---
> >
> > Hi Ulf,
> >
> > Can this and the previous patch be picked up for 3.18?
> 
> Sure, seems reasonable. Though I am having a bit hard to follow the
> mail and patches here. Could you please repost the patches and please
> do not reply to previous mail threads while doing that.
> 

Ok. No problem.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
