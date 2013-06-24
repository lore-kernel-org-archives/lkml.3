Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab3FXH0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 03:26:52 -0400
Received: from 8bytes.org ([85.214.48.195]:38882 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab3FXH0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 03:26:51 -0400
Date: Mon, 24 Jun 2013 09:26:48 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Borislav Petkov <bp@alien8.de>
Cc: suravee.suthikulpanit@amd.com, iommu@lists.linux-foundation.org,
        ddutile@redhat.com, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] iommu/amd: IOMMU Error Reporting/Handling/Filtering
Message-ID: <20130624072648.GQ11309@8bytes.org>
References: <1369250155-12226-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130621151459.GK11309@8bytes.org>
 <20130621155933.GA24385@pd.tnic>
 <20130621162455.GN11309@8bytes.org>
 <20130621173625.GH22006@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130621173625.GH22006@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Jun 24 09:26:50 2013
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c7f4ba20866720514722
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 07:36:25PM +0200, Borislav Petkov wrote:

> IOW, what specific functionality in EDAC are you actually thinking of?

Okay, my believe until yesterday was that EDAC provides a consistent way
to report hardware errors to userspace. That seems to be wrong. This in
mind I think having a trace-point for that makes sense.

But this trace-point must not be specific to a single IOMMU driver, I
want it generic enough so that it can be used by all common IOMMU
drivers to report hardware misbehaviors to userspace.


Thanks,

	Joerg


