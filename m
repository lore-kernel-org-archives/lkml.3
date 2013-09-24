Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab3IXMoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:44:08 -0400
Received: from 8bytes.org ([85.214.48.195]:45402 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab3IXMoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:44:05 -0400
Date: Tue, 24 Sep 2013 14:44:02 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: joe@perches.com, festevam@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: No need to pass '0x' when '%pa' is used
Message-ID: <20130924124401.GB5150@8bytes.org>
References: <1377177942-24965-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377177942-24965-1-git-send-email-fabio.estevam@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Sep 24 14:44:04 2013
X-DSPAM-Confidence: 0.9987
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5241891420861633738235
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 10:25:42AM -0300, Fabio Estevam wrote:
> Commit 6197ca82 (iommu: Use %pa and %zx instead of casting) introduced the 
> usage of '%pa', but still kept the '0x', which leads to printing '0x0x'.
> 
> Remove the '0x' when '%pa' is used.

Applied to core branch, thanks.


