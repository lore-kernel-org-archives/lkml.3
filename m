Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaGGIcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:32:22 -0400
Received: from 8bytes.org ([85.214.48.195]:44625 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbaGGIcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:32:20 -0400
Date: Mon, 7 Jul 2014 10:32:17 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, alex.williamson@redhat.com
Subject: Re: [PATCH 0/3] iommu/fsl: Fixes for the PAMU driver.
Message-ID: <20140707083216.GA1958@8bytes.org>
References: <1403618237-26248-1-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403618237-26248-1-git-send-email-Varun.Sethi@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Jul  7 10:32:18 2014
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53ba5b1220862958336385
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 07:27:14PM +0530, Varun Sethi wrote:
> This patch set contains fixes for the PAMU driver. 
> The patches are based on 3.16-rc1.
> 
> Varun Sethi (3):
>   Fix PAMU window size check. 
>   Fix the device domain attach condition.
>   Fix the error condition during iommu group creation.
> 
>  drivers/iommu/fsl_pamu.c        |    8 ++++----
>  drivers/iommu/fsl_pamu_domain.c |   19 +++++++++----------
>  2 files changed, 13 insertions(+), 14 deletions(-)

Applied to iommu/fixes, thanks.


