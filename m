Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3DLIE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 04:04:56 -0400
Received: from 8bytes.org ([85.214.48.195]:41067 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab3DLIEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 04:04:52 -0400
Date: Fri, 12 Apr 2013 10:04:49 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: iommu@lists.linux-foundation.org, Borislav Petkov <bp@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] iommu/amd: Add ioapic and hpet ivrs override
Message-ID: <20130412080448.GM6858@8bytes.org>
References: <1365538384-12426-1-git-send-email-joro@8bytes.org>
 <1365538384-12426-8-git-send-email-joro@8bytes.org>
 <20130409202941.GJ6858@8bytes.org>
 <51672DB7.4010403@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51672DB7.4010403@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Apr 12 10:04:50 2013
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5167c02223675852723513
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 04:40:07PM -0500, Suthikulpanit, Suravee wrote:
> On 4/9/2013 3:29 PM, Joerg Roedel wrote:
> >On Tue, Apr 09, 2013 at 10:13:02PM +0200, Joerg Roedel wrote:
> >>Add two new kernel commandline parameters ivrs_ioapic and
> >>ivrs_hpet to override the Id->DeviceId mapping from the IVRS
> >>ACPI table. This can be used to work around broken BIOSes to
> >>get interrupt remapping working on AMD systems.
> >>
> >>Signed-off-by: Joerg Roedel <joro@8bytes.org>
> >Forgot to add:
> >
> >Tested-by: Borislav Petkov <bp@suse.de>
> I also tested on some other systems here and the patch works also.

Cool, thanks for testing. I'll add your

Tested-by: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>


	Joerg


