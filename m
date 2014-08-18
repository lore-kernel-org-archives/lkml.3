Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaHRQxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 12:53:09 -0400
Received: from 8bytes.org ([81.169.241.247]:38759 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbaHRQxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 12:53:07 -0400
Date: Mon, 18 Aug 2014 18:53:05 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] iommu/msm: Switch to using managed resources
Message-ID: <20140818165305.GD9809@8bytes.org>
References: <1407154057-25440-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407154057-25440-1-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 05:37:37PM +0530, Pramod Gurav wrote:
> This switches the driver to using managed resources to simplify error
> handling and to do away with remove function.
> 
> CC: Stepan Moskovchenko <stepanm@codeaurora.org>
> CC: Joerg Roedel <joro@8bytes.org>
> CC: Stephen Boyd <sboyd@codeaurora.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>  drivers/iommu/msm_iommu_dev.c |   76 +++++++++++------------------------------
>  1 file changed, 19 insertions(+), 57 deletions(-)

How have you tested this?


	Joerg

