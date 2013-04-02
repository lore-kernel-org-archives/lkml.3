Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab3DBOkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:40:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52460 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171Ab3DBOkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:40:40 -0400
Date: Tue, 2 Apr 2013 16:40:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: suravee.suthikulpanit@amd.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] iommu/amd: Add logic to decode AMD IOMMU event flag
Message-ID: <20130402144037.GE5488@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Joerg Roedel <joro@8bytes.org>, suravee.suthikulpanit@amd.com,
	iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1364428283-2548-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130402143335.GB15687@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130402143335.GB15687@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 04:33:36PM +0200, Joerg Roedel wrote:
> Hi Suravee,
> 
> On Wed, Mar 27, 2013 at 06:51:23PM -0500, suravee.suthikulpanit@amd.com wrote:
> > From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> > 
> > Add logic to decode AMD IOMMU event flag based on information from AMD IOMMU specification.
> > This should simplify debugging IOMMU errors.  Also, dump DTE information in additional cases.
> 
> The patch in general makes sense to have, but I have a couple of
> comments.

While you guys are at it, can someone fix this too pls (ASUS board with
a PD on it).

[    0.220342] [Firmware Bug]: AMD-Vi: IOAPIC[9] not in IVRS table
[    0.220398] [Firmware Bug]: AMD-Vi: IOAPIC[10] not in IVRS table
[    0.220451] [Firmware Bug]: AMD-Vi: No southbridge IOAPIC found in IVRS table
[    0.220506] AMD-Vi: Disabling interrupt remapping due to BIOS Bug(s)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
