Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab3IXKbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 06:31:32 -0400
Received: from 8bytes.org ([85.214.48.195]:45149 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab3IXKbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 06:31:11 -0400
Date: Tue, 24 Sep 2013 12:31:07 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: iommu@lists.linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] MAINTAINERS: add overall IOMMU section
Message-ID: <20130924103106.GB3815@8bytes.org>
References: <1379099427-29362-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379099427-29362-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Sep 24 12:31:09 2013
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 524169ed20861383242098
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 01:10:27PM -0600, Stephen Warren wrote:
> I believe that Joerg Roedel is at least the path through which
> drivers/iommu changes should be merged. Add a MAINTAINERS entry to
> make this clear, so that he's Cd'd on all relevant patches. This is
> relevant for non-AMD/Intel IOMMUs, where get_maintainers.pl doesn't
> currently remind anyone to Cc Joerg on patches.

Applied to iommu/fixes, thanks Stephen.

I always hesitated a bit to do that, but if it makes me Cc'ed on all
iommu patches from now on it is probably ok ;)


	Joerg


