Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaHSLJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:09:40 -0400
Received: from 8bytes.org ([81.169.241.247]:43847 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaHSLJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:09:39 -0400
Date: Tue, 19 Aug 2014 13:09:37 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: iommu <iommu@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [PATCH] iommu/vt-d: Don't store SIRTP request
Message-ID: <20140819110937.GA26492@8bytes.org>
References: <53E8A555.5010905@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E8A555.5010905@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 01:13:25PM +0200, Jan Kiszka wrote:
> Don't store the SIRTP request bit in the register state. It will
> otherwise become sticky and could request an Interrupt Remap Table
> Pointer update on each command register write.
> 
> Found while starting to emulate IR in QEMU, not by observing problems on
> real hardware.
> 
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  drivers/iommu/intel_irq_remapping.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied, thanks Jan.
