Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423656Ab3FUSYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 14:24:10 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43996 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423641Ab3FUSYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 14:24:08 -0400
Date: Fri, 21 Jun 2013 14:23:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Jiang Liu <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] deprecate usage of pci_scan_bus_parented()
Message-ID: <20130621182341.GG15809@phenom.dumpdata.com>
References: <1371747665-12768-1-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371747665-12768-1-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 01:01:02AM +0800, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> This patch tries to deprecate usage of pci_scan_bus_parented().
> It applies to
> https://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git next

They look OK to me, but let me double-test them in case some last
minute regression has reared its head.

> 
> Jiang Liu (3):
>   PCI: export three functions to support modular host bridge driver
>   PCI, xen-pcifront: use new PCI interfaces to simplify implementation
>   PCI: mark pci_scan_bus_parented() as __deprecated
> 
>  arch/tile/kernel/pci.c     |  3 --
>  drivers/pci/host-bridge.c  |  1 +
>  drivers/pci/probe.c        |  1 +
>  drivers/pci/remove.c       |  7 +++++
>  drivers/pci/xen-pcifront.c | 70 ++++++++++++++++++++--------------------------
>  include/linux/pci.h        |  5 ++--
>  6 files changed, 42 insertions(+), 45 deletions(-)
> 
> -- 
> 1.8.1.2
> 
