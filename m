Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaFPPQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:16:23 -0400
Received: from 8bytes.org ([85.214.48.195]:40164 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbaFPPQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:16:22 -0400
Date: Mon, 16 Jun 2014 17:16:19 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] iommu: Expose IOMMU information in sysfs
Message-ID: <20140616151619.GA31771@8bytes.org>
References: <20140612215954.2754.30263.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612215954.2754.30263.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Jun 16 17:16:20 2014
X-DSPAM-Confidence: 0.9978
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 539f0a4420861436816434
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 04:12:18PM -0600, Alex Williamson wrote:
> Alex Williamson (3):
>       iommu: Add sysfs support for IOMMUs
>       iommu/intel: Make use of IOMMU sysfs support
>       iommu/amd: Add sysfs support

I like the general approach. But why do you only enable the x86 iommus?
Some ARM IOMMUs and PAMU would certainly also benefit from a sysfs
representation of which device is translated by which IOMMU.


	Joerg


