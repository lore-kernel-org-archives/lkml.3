Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab3A1O0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 09:26:41 -0500
Received: from 8bytes.org ([85.214.48.195]:52803 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756Ab3A1O0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 09:26:39 -0500
Date: Mon, 28 Jan 2013 15:26:37 +0100
From: Joerg Roedel <joro@8bytes.org>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, bp@alien8.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4] IOMMU, AMD Family15h Model10-1Fh erratum 746
 Workaround
Message-ID: <20130128142637.GY25591@8bytes.org>
References: <1359055073-29732-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359055073-29732-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Jan 28 15:26:38 2013
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51068a9e22971644417130
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 01:17:53PM -0600, Suthikulpanit, Suravee wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
> Changelog:
> v4:
>       * Fix style and spacing
> 
> v3:
>       * Add proper commit message
>       * Change logic to avoid unnecessary indentaion
> 
> v2:
>       * Fix logic that check the processor model.
>       * Clear write enable bit after apply workaround
>       * Change function name
> 
>  drivers/iommu/amd_iommu_init.c |   34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)

Applied to iommu/fixes, thanks guys.


