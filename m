Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279AbaFQTDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:03:49 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:35450 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801AbaFQTDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:03:47 -0400
Date: Tue, 17 Jun 2014 15:03:43 -0400
From: Tejun Heo <tj@kernel.org>
To: suravee.suthikulpanit@amd.com
Cc: b.zolnierkie@samsung.com, hdegoede@redhat.com, lho@apm.com, tphan@apm.com,
        stripathi@apm.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ahci: Check and set 64-bit DMA mask for platform
 AHCI driver
Message-ID: <20140617190343.GM31819@htj.dyndns.org>
References: <1402594824-4151-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1402594824-4151-2-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402594824-4151-2-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 12:40:23PM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> The current platform AHCI driver does not set the dma_mask correctly
> for 64-bit DMA capable AHCI controller. This patch checks the AHCI
> capability bit and set the dma_mask and coherent_dma_mask accordingly.
> 
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Applied 1-2 to libata/for-3.17.

Thanks.

-- 
tejun
