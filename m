Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab3EBKQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:16:35 -0400
Received: from 8bytes.org ([85.214.48.195]:37381 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab3EBKQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:16:33 -0400
Date: Thu, 2 May 2013 12:16:29 +0200
From: "joro@8bytes.org" <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>
Subject: Re: [PATCH 1/2 v15] iommu/fsl: Add additional iommu attributes
 required by the PAMU driver.
Message-ID: <20130502101629.GA24440@8bytes.org>
References: <1366803351-17429-1-git-send-email-Varun.Sethi@freescale.com>
 <C5ECD7A89D1DC44195F34B25E172658D4CBC45@039-SN2MPN1-011.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D4CBC45@039-SN2MPN1-011.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu May  2 12:16:31 2013
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51823cff23677273815918
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 05:09:32PM +0000, Sethi Varun-B16395 wrote:
> Would you take this patchset for 3.10 merge?

Not this time. The final patch came in very late and is pretty big too.
For code of that size I would like to have a few weeks more testing in
next and probably also a non-Freescale Reviewed-by.


	Joerg


