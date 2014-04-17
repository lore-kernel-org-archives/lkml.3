Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945907AbaDQNeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:34:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756759AbaDQNej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:34:39 -0400
Date: Thu, 17 Apr 2014 14:36:18 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 0/2] ahci: Tweaks to the driver's PCI function
Message-ID: <20140417123618.GB2270@dhcp-26-207.brq.redhat.com>
References: <cover.1397736364.git.agordeev@redhat.com>
 <20140417132806.GA15326@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417132806.GA15326@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 09:28:06AM -0400, Tejun Heo wrote:
> On Thu, Apr 17, 2014 at 02:13:48PM +0200, Alexander Gordeev wrote:
> > Changes since v1:
> > 	- ahci_is_mrsm() open-coded inside ahci_init_interrupt()
> > 	- changelog elaborated
> > 
> > Cc: linux-ide@vger.kernel.org
> > 
> > Alexander Gordeev (2):
> >   ahci: Ensure "MSI Revert to Single Message" mode is not enforced
> >   ahci: Use pci_enable_msi_exact() instead of pci_enable_msi_range()
> > 
> >  drivers/ata/ahci.c |   19 ++++++++++++++-----
> >  drivers/ata/ahci.h |    1 +
> >  2 files changed, 15 insertions(+), 5 deletions(-)
> 
> Applied to libata/for-3.15-fixes.

Oh-oh.
It seems the changelog's demo patch portion applied to the source.


> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
