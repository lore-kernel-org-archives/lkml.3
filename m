Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaA2NZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 08:25:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaA2NZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 08:25:08 -0500
Date: Wed, 29 Jan 2014 14:26:52 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Brian King <brking@linux.vnet.ibm.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wendy Xiong <wenxiong@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 4/9] ipr: Use pci_enable_msi_range() and
 pci_enable_msix_range()
Message-ID: <20140129132651.GA27764@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
 <eb0b62be65c050533f2565fcf3f1d673770dfd67.1389904166.git.agordeev@redhat.com>
 <20140128095441.GA6951@dhcp-26-207.brq.redhat.com>
 <52E7CCAD.5070008@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E7CCAD.5070008@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 09:28:45AM -0600, Brian King wrote:

Thanks for the review, Brian!

> These look like they will conflict with a recent patch to
> the ipr driver:
> 
> http://www.spinics.net/lists/linux-scsi/msg71644.html

BTW, this one does not appear ACKed.

> Do you want me to rediff your patches on top of this one,
> or do you want to keep the entire MSI series together
> and do the rediff? Otherwise the patches seem fine.

I would prefer the former.

@Bjorn, please let us know if you prefer otherwise.

> Thanks,
> 
> Brian
> 
> 
> -- 
> Brian King
> Power Linux I/O
> IBM Linux Technology Center
> 
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
