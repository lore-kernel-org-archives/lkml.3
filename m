Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaGKImP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 04:42:15 -0400
Received: from 8bytes.org ([85.214.48.195]:54553 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbaGKImO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:42:14 -0400
Date: Fri, 11 Jul 2014 10:42:09 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Oded Gabbay <oded.gabbay@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: Re: [PATCH 38/83] hsa/radeon: Workaround for a bug in amd_iommu
Message-ID: <20140711084209.GA1958@8bytes.org>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
 <1405029279-6894-10-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405029279-6894-10-git-send-email-oded.gabbay@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jul 11 10:42:11 2014
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53bfa36320862332416787
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 12:53:54AM +0300, Oded Gabbay wrote:
> This patch creates a workaround for a bug in amd_iommu driver, where
> the driver doesn't save all necessary information when going to
> suspend.  The workaround removes a device from the IOMMU device list
> on suspend and register a resumed device in the IOMMU device list.
> 
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>

Which bug do you workaround here? It needs to be fixed in the AMD IOMMU
driver instead of being wrapped in KFD.


	Joerg


