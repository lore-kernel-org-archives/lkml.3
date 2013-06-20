Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab3FTOl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:41:57 -0400
Received: from 8bytes.org ([85.214.48.195]:35205 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757898Ab3FTOl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:41:56 -0400
Date: Thu, 20 Jun 2013 16:41:53 +0200
From: "joro@8bytes.org" <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH 2/5 v11] powerpc: Add iommu domain pointer to device
 archdata
Message-ID: <20130620144152.GB3589@8bytes.org>
References: <1364500442-20927-1-git-send-email-Varun.Sethi@freescale.com>
 <1364500442-20927-3-git-send-email-Varun.Sethi@freescale.com>
 <AC9BAE34-A9CB-4A24-A357-0AA7734CE443@kernel.crashing.org>
 <C5ECD7A89D1DC44195F34B25E172658D5CB5D4@039-SN2MPN1-011.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D5CB5D4@039-SN2MPN1-011.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun 20 16:41:55 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c314b320861838917563
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 02:29:30PM +0000, Sethi Varun-B16395 wrote:
> Hi Joerg,
> My PAMU driver patches depend on this patch which was Ack by Kumar. Should I resubmit this patch as well?

Yes, please. Add the collected Acked-bys and submit everything that is
missing in v3.10-rc6.


	Joerg


