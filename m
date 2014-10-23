Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708AbaJWMwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:52:01 -0400
Received: from 8bytes.org ([81.169.241.247]:43452 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932652AbaJWMv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:51:56 -0400
Date: Thu, 23 Oct 2014 14:51:54 +0200
From: =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 1/1] IOMMU-MSM: Deletion of unnecessary checks before the
 function call "clk_disable"
Message-ID: <20141023125153.GC10053@8bytes.org>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <5447F0B1.9010707@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5447F0B1.9010707@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 08:00:17PM +0200, SF Markus Elfring wrote:
>  drivers/iommu/msm_iommu.c     | 3 +--
>  drivers/iommu/msm_iommu_dev.c | 6 ++----
>  2 files changed, 3 insertions(+), 6 deletions(-)

Applied to arm/msm, thanks.

