Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbaBRMOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 07:14:41 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63396 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbaBRMOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 07:14:39 -0500
Date: Tue, 18 Feb 2014 14:14:35 +0200
From: Amir Vadai <amirv@mellanox.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: ixgbevf: Use pci_enable_msix_range() instead of pci_enable_msix()
Message-ID: <20140218121433.GB8770@mtl-eit-vdi-22.mtl.labs.mlnx>
References: <cover.1392717502.git.agordeev@redhat.com>
 <9ee830cfd4b417f230f77dd37256ca8e4396ecbe.1392717503.git.agordeev@redhat.com>
 <20140218120136.GA8770@mtl-eit-vdi-22.mtl.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218120136.GA8770@mtl-eit-vdi-22.mtl.labs.mlnx>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/02/14 14:01 +0200, Amir Vadai wrote:
> On 18/02/14 11:11 +0100, Alexander Gordeev wrote:
> > As result of deprecation of MSI-X/MSI enablement functions
> > pci_enable_msix() and pci_enable_msi_block() all drivers
> > using these two interfaces need to be updated to use the
> > new pci_enable_msi_range() and pci_enable_msix_range()
> > interfaces.
> > 
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> > Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > Cc: Bruce Allan <bruce.w.allan@intel.com>
> > Cc: e1000-devel@lists.sourceforge.net
> > Cc: netdev@vger.kernel.org
> > Cc: linux-pci@vger.kernel.org
> > ---
> 
> Acked-By: Amir Vadai <amirv@mellanox.com>
Oh, I'm still working for Mellanox - just replied to the wrong mail :)
