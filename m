Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbaELTEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 15:04:22 -0400
Received: from 8bytes.org ([85.214.48.195]:41921 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbaELTEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 15:04:21 -0400
Date: Mon, 12 May 2014 21:04:18 +0200
From: Joerg Roedel <joro@8bytes.org>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kim.naru@amd.com, jay.cornwall@amd.com
Subject: Re: [PATCH] iommu/amd: Take mmap_sem when calling get_user_pages
Message-ID: <20140512190417.GA10562@8bytes.org>
References: <1398724066-3730-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398724066-3730-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon May 12 21:04:20 2014
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53711b3420864353836608
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 05:27:46PM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Jay Cornwall <jay.cornwall@amd.com>
> 
> get_user_pages requires caller to hold a read lock on mmap_sem.
> 
> Signed-off-by: Jay Cornwall <jay.cornwall@amd.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Applied, thanks Jay and Suravee.

