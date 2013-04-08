Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965282Ab3DHOuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:50:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37047 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965236Ab3DHOug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:50:36 -0400
Date: Mon, 8 Apr 2013 16:50:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] iommu/amd: Add logic to decode AMD IOMMU event flag
Message-ID: <20130408145003.GC4723@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
	"iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1364947610-3327-1-git-send-email-suravee.suthikulpanit@amd.com>
 <02D2024799561B48A732D1A51CB969E81959AF3E@sausexdag04.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <02D2024799561B48A732D1A51CB969E81959AF3E@sausexdag04.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 02:33:32PM +0000, Suthikulpanit, Suravee wrote:
> Joerg,
> 
> Do you have any more feedback about this patch?
> 
> Thanks,
> 
> Suravee
> ________________________________________
> From: suravee.suthikulpanit@amd.com [suravee.suthikulpanit@amd.com]
> Sent: Tuesday, April 02, 2013 7:06 PM
> To: iommu@lists.linux-foundation.org; joro@8bytes.org
> Cc: linux-kernel@vger.kernel.org; Suthikulpanit, Suravee
> Subject: [PATCH V3] iommu/amd: Add logic to decode AMD IOMMU event flag
> 
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> Add logic to decode AMD IOMMU event flag based on information from AMD IOMMU specification.
> This should simplify debugging IOMMU errors.  Also, dump DTE information in additional cases.
> 
> This is an example:
> AMD-Vi: Event logged [IO_PAGE_FAULT device=51:00.0 domain=0x0000 address=0x0000000000000000 flags=0x0fff]
> AMD-Vi: Flags details: Guest NX=1 User Intr Present Write No-Perm Rsrv-Bit Translation
> AMD-Vi: Type of error: (0x7)
> AMD-Vi: (Note: Please refer to AMD IOMMU specification for details.)

Independent from Joerg's feedback on this, I have only one question:
you're not seriously considering on dumping this "Note:..." line above
on *every* IO-PF, right?

I very positively assume that people who stare at that output should, as
a first prerequisite, know where to find those fields' descriptions. :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
