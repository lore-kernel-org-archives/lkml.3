Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3CCW6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 17:58:33 -0500
Received: from 8bytes.org ([85.214.48.195]:42847 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab3CCW6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 17:58:31 -0500
Date: Sun, 3 Mar 2013 23:58:28 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: shuah.khan@hp.com, iommu@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, shuahkhan@gmail.com
Subject: Re: [PATCH 3.2] iommu/amd: Initialize device table after dma_ops
Message-ID: <20130303225828.GA22602@8bytes.org>
References: <1362087590.2822.44.camel@lorien2>
 <1362265235.3768.156.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362265235.3768.156.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sun Mar  3 23:58:29 2013
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5133d59523676609969982
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Sat, Mar 02, 2013 at 11:00:35PM +0000, Ben Hutchings wrote:
> I'm not convinced about this backport, because the order of
> initialisation already changed a lot after 3.2 and before the upstream
> commit.  So I'm going to wait for Joerg to confirm that this makes sense
> before adding it to the patch queue.

The patch looks good, it fixes a race condition during amd_iommu
initialization. I'll also gave the backport a test to be sure it
doesn't break anything.

Thanks,

	Joerg


