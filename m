Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab3DXSBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 14:01:53 -0400
Received: from 8bytes.org ([85.214.48.195]:56482 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab3DXSBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 14:01:52 -0400
Date: Wed, 24 Apr 2013 20:01:49 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] iommu: add a function to find an iommu group by id
Message-ID: <20130424180114.GB3167@8bytes.org>
References: <1364167429-6432-1-git-send-email-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364167429-6432-1-git-send-email-aik@ozlabs.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Apr 24 20:01:51 2013
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51781e0f23671203117066
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 10:23:49AM +1100, Alexey Kardashevskiy wrote:
> As IOMMU groups are exposed to the user space by their numbers,
> the user space can use them in various kernel APIs so the kernel
> might need an API to find a group by its ID.
> 
> As an example, QEMU VFIO on PPC64 platform needs it to associate
> a logical bus number (LIOBN) with a specific IOMMU group in order
> to support in-kernel handling of DMA map/unmap requests.
> 
> The patch adds the iommu_group_get_by_id(id) function which performs
> such search.
> 
> v2: fixed reference counting.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Applied to core branch, thanks Alexey.


