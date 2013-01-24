Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab3AXT5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:57:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60287 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab3AXT5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:57:43 -0500
Date: Thu, 24 Jan 2013 21:00:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, joro@8bytes.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4] IOMMU, AMD Family15h Model10-1Fh erratum 746
 Workaround
Message-ID: <20130124200034.GM13463@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	suravee.suthikulpanit@amd.com, iommu@lists.linux-foundation.org,
	joro@8bytes.org, linux-kernel@vger.kernel.org
References: <1359055073-29732-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1359055073-29732-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 01:17:53PM -0600, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> The IOMMU may stop processing page translations due to a perceived lack
> of credits for writing upstream peripheral page service request (PPR)
> or event logs. If the L2B miscellaneous clock gating feature is enabled
> the IOMMU does not properly register credits after the log request has
> completed, leading to a potential system hang.
> 
> BIOSes are supposed to disable L2B micellaneous clock gating by setting
> L2_L2B_CK_GATE_CONTROL[CKGateL2BMiscDisable](D0F2xF4_x90[2]) = 1b. This
> patch corrects that for those which do not enable this workaround.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Acked-by: Borislav Petkov <bp@suse.de>

Thanks for the good work.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
