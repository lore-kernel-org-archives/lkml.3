Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaLCSam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:30:42 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:32899 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaLCSak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:30:40 -0500
Date: Wed, 3 Dec 2014 11:30:36 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>
Subject: [GIT PULL] PCI fixes for v3.18
Message-ID: <20141203183036.GA19435@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This fixes a Tegra20 regression that we introduced during the v3.18 merge
window.

Bjorn


The following changes since commit 7fc986d8a9727e5d40da3c2c1c343da6142e82a9:

  PCI: Support 64-bit bridge windows if we have 64-bit dma_addr_t (2014-11-19 14:30:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.18-fixes-4

for you to fetch changes up to 5106787a9e08dc2901d6b2513ed8f377671befa8:

  PCI: tegra: Use physical range for I/O mapping (2014-12-01 16:55:43 -0700)

----------------------------------------------------------------
PCI update for v3.18:

  NVIDIA Tegra
    - Use physical range for I/O mapping (Thierry Reding)

----------------------------------------------------------------
Thierry Reding (1):
      PCI: tegra: Use physical range for I/O mapping

 drivers/pci/host/pci-tegra.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)
