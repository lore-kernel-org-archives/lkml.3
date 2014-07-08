Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbaGHLUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 07:20:15 -0400
Received: from 8bytes.org ([85.214.48.195]:47180 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801AbaGHLUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 07:20:13 -0400
Date: Tue, 8 Jul 2014 13:20:10 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: linux-next: build failure after merge of the iommu tree
Message-ID: <20140708112009.GI1958@8bytes.org>
References: <20140708140246.72b72682@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708140246.72b72682@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Jul  8 13:20:10 2014
X-DSPAM-Confidence: 0.9980
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53bbd3ea20861288814077
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Jul 08, 2014 at 02:02:46PM +1000, Stephen Rothwell wrote:
> Caused by commit c61959ecbbc6 ("iommu: Add sysfs support for IOMMUs").
> CONFIG_IOMMU_API is not set for this build.  Forgotten "static
> inline"s :-(
> 
> I have used the iommu tree from next-20140707 for today.

I have committed the patch from Alex and published a new next branch. It
should be fixed now.


Thanks,

	Joerg


