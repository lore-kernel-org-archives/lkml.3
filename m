Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbbA1UxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:53:07 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45531 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbbA1UxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:53:01 -0500
Date: Wed, 28 Jan 2015 13:46:39 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Srikanth Thokala <sthokal@xilinx.com>, Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch v2 18/22] PCI: Use common resource list management code
 instead of private implementation
Message-ID: <20150128134639.GN1569@arm.com>
References: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
 <1422442660-455-19-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422442660-455-19-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 10:57:36AM +0000, Jiang Liu wrote:
> Use common resource list management data structure and interfaces
> instead of private implementation.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  arch/arm/kernel/bios32.c            |    5 ++---
>  arch/x86/pci/bus_numa.c             |    4 ++--
>  drivers/pci/bus.c                   |   18 ++++++------------
>  drivers/pci/host-bridge.c           |    8 ++++----
>  drivers/pci/host/pci-host-generic.c |    4 ++--
>  drivers/pci/host/pci-xgene.c        |    4 ++--
>  drivers/pci/host/pcie-xilinx.c      |    4 ++--
>  drivers/pci/probe.c                 |   10 +++++-----
>  include/linux/pci.h                 |    9 ++-------
>  9 files changed, 27 insertions(+), 39 deletions(-)

The arch/arm/ and drivers/pci/host/pci-host-generic.c bits look fine to
me:

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
