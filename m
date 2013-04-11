Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab3DKSQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:16:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:39118 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab3DKSQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:16:50 -0400
Subject: Re: [PATCH 2/5 v11] powerpc: Add iommu domain pointer to device archdata
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1364500442-20927-3-git-send-email-Varun.Sethi@freescale.com>
Date: Thu, 11 Apr 2013 13:16:27 -0500
Cc: <joro@8bytes.org>, <stuart.yoder@freescale.com>, <scottwood@freescale.com>,
        <iommu@lists.linux-foundation.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <benh@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Message-Id: <AC9BAE34-A9CB-4A24-A357-0AA7734CE443@kernel.crashing.org>
References: <1364500442-20927-1-git-send-email-Varun.Sethi@freescale.com> <1364500442-20927-3-git-send-email-Varun.Sethi@freescale.com>
To: Varun Sethi <Varun.Sethi@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 28, 2013, at 2:53 PM, Varun Sethi wrote:

> Add an iommu domain pointer to device (powerpc) archdata.  Devices
> are attached to iommu domains and this pointer provides a mechanism
> to correlate between a device and the associated iommu domain.  This
> field is set when a device is attached to a domain.
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> ---
> - no change in v11.
> - no change in v10.
> - Added CONFIG_IOMMU_API in v9.
> arch/powerpc/include/asm/device.h |    6 ++++++
> 1 files changed, 6 insertions(+), 0 deletions(-)

Acked-by: Kumar Gala <galak@kernel.crashing.org>

- k
