Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab3DBPaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:30:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53621 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341Ab3DBPaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:30:01 -0400
Date: Tue, 2 Apr 2013 17:29:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: suravee.suthikulpanit@amd.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] iommu/amd: Add logic to decode AMD IOMMU event flag
Message-ID: <20130402152956.GE4391@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Joerg Roedel <joro@8bytes.org>, suravee.suthikulpanit@amd.com,
	iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1364428283-2548-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130402143335.GB15687@8bytes.org>
 <20130402144037.GE5488@pd.tnic>
 <20130402150302.GF15687@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130402150302.GF15687@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 05:03:04PM +0200, Joerg Roedel wrote:
> On Tue, Apr 02, 2013 at 04:40:37PM +0200, Borislav Petkov wrote:
> > While you guys are at it, can someone fix this too pls (ASUS board with
> > a PD on it).
> > 
> > [    0.220342] [Firmware Bug]: AMD-Vi: IOAPIC[9] not in IVRS table
> > [    0.220398] [Firmware Bug]: AMD-Vi: IOAPIC[10] not in IVRS table
> > [    0.220451] [Firmware Bug]: AMD-Vi: No southbridge IOAPIC found in IVRS table
> > [    0.220506] AMD-Vi: Disabling interrupt remapping due to BIOS Bug(s)
> 
> That is actually a BIOS problem. I wonder whether it would help to turn this
> into a WARN_ON to get the board vendors to release working BIOSes.
> Opinions?

Good luck trying to get ASUS to fix anything in their BIOS :(.

Can't we detect the SB IOAPIC some other way in this case?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
