Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3BDONZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 09:13:25 -0500
Received: from 8bytes.org ([85.214.48.195]:33935 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab3BDONY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 09:13:24 -0500
Date: Mon, 4 Feb 2013 15:13:18 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Sami Liedes <sliedes@nvidia.com>
Cc: iommu@lists.linux-foundation.org, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/tegra: Add missing spinlock initialization
Message-ID: <20130204141316.GA2427@8bytes.org>
References: <1359981110-9924-1-git-send-email-sliedes@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359981110-9924-1-git-send-email-sliedes@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Feb  4 15:13:22 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 510fc20222971530818173
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 02:31:48PM +0200, Sami Liedes wrote:
> Fix tegra_smmu_probe() to initialize client_lock spinlocks in
> per-address-space structures.
> 
> Signed-off-by: Sami Liedes <sliedes@nvidia.com>

Applied to arm/tegra, thanks.


