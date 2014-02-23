Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaBWTn5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 14:43:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaBWTnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 14:43:55 -0500
Date: Sun, 23 Feb 2014 20:45:49 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: James Smart <james.smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/22] lpfc: Use pci_enable_msix_range()
Message-ID: <20140223194548.GA16635@dhcp-26-207.brq.redhat.com>
References: <a34533b1-77d9-45bc-ad66-aab336972b95@CMEXHTCAS2.ad.emulex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a34533b1-77d9-45bc-ad66-aab336972b95@CMEXHTCAS2.ad.emulex.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 11:47:02AM -0500, James Smart wrote:
> Alexander,
> 
> I've reworked this patch to layer on top of our rev 8.3.45 patches
> that were just posted to linux-scsi. There were some conflicts due to
> new additions.  Additionally, there were two other uses of pci_enable_msiXXX
> that needed to be addressed.  The changes in this patch also address the
> change requested by:
> "[PATCH 11/22] lpfc: Remove superfluous call to pci_disable_msix()"
> 
> To avoid creating merge conflicts - either by your patches going in then
> scsi git tree trying to merge or by scsi git tree going in and your patches
> trying to merge - I recommend that you eliminate your lpfc patches from the
> kernel and apply the patch below once scsi git with the updated lpfc driver
> has actually merged.

Hi James,

Thank you for the review and for the updated patch - it is embarrassing 
I have not addressed all pci_enable_msix()'s.

I will keep the two patches separate to ease bisecting -
I am going to repost the patches on top of scsi tree.

Cheers!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
