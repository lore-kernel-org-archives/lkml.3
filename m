Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292AbaFQPWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:22:00 -0400
Received: from 8bytes.org ([85.214.48.195]:42190 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933191AbaFQPV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:21:57 -0400
Date: Tue, 17 Jun 2014 17:21:54 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: iommu@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/24]  drivers/iommu: check actual error on iommu_init
Message-ID: <20140617152154.GE31771@8bytes.org>
References: <53A050BF.3000101@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A050BF.3000101@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Jun 17 17:21:55 2014
X-DSPAM-Confidence: 0.9983
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53a05d1320869736716365
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 10:29:19PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> kset_create_and_add() has been fixed to return the actual error
> code ptr rather than NULL, so update iommu_init() to check the
> return value via IS_ERR() accordingly.
> 
> Cc: Joerg Roedel <joro@8bytes.org>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Acked-by: Joerg Roedel <joro@8bytes.org>


