Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaEZJkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:40:03 -0400
Received: from 8bytes.org ([85.214.48.195]:34854 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbaEZJkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:40:02 -0400
Date: Mon, 26 May 2014 11:39:59 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove duplicate checking code
Message-ID: <20140526093959.GH17056@8bytes.org>
References: <1400225980-12797-1-git-send-email-vaughan.cao@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400225980-12797-1-git-send-email-vaughan.cao@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon May 26 11:40:00 2014
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53830bf020861888918340
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 03:39:40PM +0800, Vaughan Cao wrote:
> amd_iommu_rlookup_table[devid] != NULL is already guaranteed by check_device
> called before, it's fine to attach device at this point.
> 
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
> ---
>  drivers/iommu/amd_iommu.c | 6 ------
>  1 file changed, 6 deletions(-)

Applied, thanks.

