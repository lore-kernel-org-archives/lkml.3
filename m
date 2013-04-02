Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab3DBPDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:03:09 -0400
Received: from 8bytes.org ([85.214.48.195]:53816 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932291Ab3DBPDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:03:07 -0400
Date: Tue, 2 Apr 2013 17:03:04 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Borislav Petkov <bp@alien8.de>, suravee.suthikulpanit@amd.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] iommu/amd: Add logic to decode AMD IOMMU event flag
Message-ID: <20130402150302.GF15687@8bytes.org>
References: <1364428283-2548-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130402143335.GB15687@8bytes.org>
 <20130402144037.GE5488@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402144037.GE5488@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  2 17:03:05 2013
X-DSPAM-Confidence: 0.9980
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 515af32923674059911085
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 04:40:37PM +0200, Borislav Petkov wrote:
> While you guys are at it, can someone fix this too pls (ASUS board with
> a PD on it).
> 
> [    0.220342] [Firmware Bug]: AMD-Vi: IOAPIC[9] not in IVRS table
> [    0.220398] [Firmware Bug]: AMD-Vi: IOAPIC[10] not in IVRS table
> [    0.220451] [Firmware Bug]: AMD-Vi: No southbridge IOAPIC found in IVRS table
> [    0.220506] AMD-Vi: Disabling interrupt remapping due to BIOS Bug(s)

That is actually a BIOS problem. I wonder whether it would help to turn this
into a WARN_ON to get the board vendors to release working BIOSes.
Opinions?


	Joerg


