Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbaIPXAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:00:18 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43243 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaIPXAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:00:15 -0400
Date: Tue, 16 Sep 2014 17:00:11 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] PCI: tegra: Fixes and Tegra124 support
Message-ID: <20140916230011.GE5050@google.com>
References: <1409065898-26887-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409065898-26887-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 05:11:32PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> This series implements various fixes and adds support for Tegra124 to the
> Tegra PCIe controller driver.
> 
> Patches 1 and 2 were already sent out separately earlier on but haven't been
> applied yet, so I'm including them here for convenience.
> 
> Patches 3 to 5 are various fixes that should make the driver more reliable,
> though they don't (except maybe for patch 4) fix any known issues.
> 
> Patch 6 finally adds support for Tegra124.
> 
> Thierry
> 
> Eric Yuen (1):
>   PCI: tegra: Make sure the PCIe PLL is really reset
> 
> Peter Daifuku (1):
>   PCI: tegra: Fix extended configuration space mapping
> 
> Thierry Reding (4):
>   resource: Add device-managed request/release_resource()
>   PCI: tegra: Implement a proper resource hierarchy
>   PCI: tegra: Clear CLKREQ# enable on port disable
>   PCI: tegra: Add Tegra124 support
> 
>  .../bindings/pci/nvidia,tegra20-pcie.txt           |  25 +-
>  Documentation/driver-model/devres.txt              |   2 +
>  drivers/pci/host/pci-tegra.c                       | 257 ++++++++++++++++++---
>  include/linux/ioport.h                             |   5 +
>  kernel/resource.c                                  |  70 ++++++
>  5 files changed, 323 insertions(+), 36 deletions(-)

Applied to pci/host-tegra for v3.18, thanks.  I added Stephens's Tested-by
(though not to the first two because I had applied them before I got to
this v3 posting).
