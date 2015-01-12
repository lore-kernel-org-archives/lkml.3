Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbbALQAC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:00:02 -0500
Received: from 8bytes.org ([81.169.241.247]:46253 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbbALQAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:00:00 -0500
Date: Mon, 12 Jan 2015 16:59:57 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        John Bridgman <John.Bridgman@amd.com>,
        "Elifaz, Dana" <Dana.Elifaz@amd.com>
Subject: Re: [PATCH] iommu/amd: Track when amd_iommu_v2 init is complete
Message-ID: <20150112155957.GE6343@8bytes.org>
References: <1419106352-6486-1-git-send-email-oded.gabbay@amd.com>
 <5495DB96.6070608@amd.com>
 <5497F130.7040508@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5497F130.7040508@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oded,

On Mon, Dec 22, 2014 at 12:23:44PM +0200, Oded Gabbay wrote:
> The drm guys suggested we move iommu/ subsystem before gpu/
> subsystem in drivers/Makefile instead of the above patch (and the
> complementing patch-set in amdkfd).
> I did that and it works, so please see this patch as discarded for now.
> I will send a new patch-set shortly.

Yeah, this is still a hack, but a better solution than tracking the
initialization order manually.


	Joerg

