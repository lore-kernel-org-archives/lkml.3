Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab3L3Oi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 09:38:26 -0500
Received: from 8bytes.org ([85.214.48.195]:56662 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963Ab3L3OiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 09:38:23 -0500
Date: Mon, 30 Dec 2013 15:38:20 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        josh@joshtriplett.org
Subject: Re: [PATCH 1/3] drivers: iommu: Mark functions as static in dmar.c
Message-ID: <20131230143819.GE2799@8bytes.org>
References: <6d0cb39e3d1128669e7740943efce3996ab0d8ab.1387265904.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6d0cb39e3d1128669e7740943efce3996ab0d8ab.1387265904.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Dec 30 15:38:21 2013
X-DSPAM-Confidence: 0.9981
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 52c1855d20861084140347
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 12:01:46PM +0530, Rashika Kheria wrote:
> Mark the functions check_zero_address() and dmar_get_fault_reason() as
> static in dmar.c because they are not used outside this file.
> 
> This eliminates the following warnings in dmar.c:
> drivers/iommu/dmar.c:491:12: warning: no previous prototype for ‘check_zero_address’ [-Wmissing-prototypes]
> drivers/iommu/dmar.c:1116:13: warning: no previous prototype for ‘dmar_get_fault_reason’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Applied all, thanks.


