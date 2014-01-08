Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbaAHLwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:52:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201AbaAHLwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:52:00 -0500
Date: Wed, 8 Jan 2014 12:54:01 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        wil6210@qca.qualcomm.com, linux-pci@vger.kernel.org
Subject: Re: [PATCH 7/7] wil6210: Use new interfaces for MSI enablement
Message-ID: <20140108115400.GD20157@dhcp-26-207.brq.redhat.com>
References: <cover.1389103215.git.agordeev@redhat.com>
 <a5774459cb8eebfc95156b8cd3b249d896e04400.1389103215.git.agordeev@redhat.com>
 <1649789.pNiBbZVqTd@lx-vladimir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1649789.pNiBbZVqTd@lx-vladimir>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 01:30:45PM +0200, Vladimir Kondratiev wrote:
> On Tuesday, January 07, 2014 07:05:42 PM Alexander Gordeev wrote:
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> > ---
> >  drivers/net/wireless/ath/wil6210/pcie_bus.c |   36 ++++++++++++++------------
> >  1 files changed, 19 insertions(+), 17 deletions(-)
> > 
> 
> Patch looks fine, but I can't validate it as I can't find patch introducing
> pci_enable_msi_range(). Where this patch landed on?

Vladimir,

This series is against pci/msi branch in Bjorn Helgaas's repo:
git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git

Commit 302a252 "PCI/MSI: Add pci_enable_msi_range() and pci_enable_msix_range()"

> I am working with:
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> 
> I also checked
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> and, of course
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> 
> Thanks, Vladimir

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
