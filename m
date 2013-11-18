Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3KRAJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 19:09:56 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:40606 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab3KRAJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 19:09:45 -0500
X-AuditID: cbfec372-b7fcc6d0000068fc-23-52895ac66917
Date: Sun, 17 Nov 2013 22:09:37 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux EDAC Mailing List <linux-edac@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>
Subject: [GIT PULL for v3.13-rc1] edac updates
Message-id: <20131117220937.14dfd290@samsung.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e9wsO6xqM4gg9X/NS3mrF/DZnF12Vkm
	iwunGpgsLu+aw2bxqO8tuwOrx4kZv1k8Pm+S85hyqJ0lgDmKyyYlNSezLLVI3y6BK2P6pvlM
	BTt5Kzacl2hg/MnVxcjJISFgIjHv5U1WCFtM4sK99WxdjFwcQgJLGCUuHHvGDOH0MElcnjed
	DaSKRUBVYvGvHjCbTcBI4lVjC1i3CJD9+cUVIJuDg1ngHKPExwSQsLCAnsTJXZfZQMK8AoYS
	L15ngpgSAk4Suw9IgVTwCghK/Jh8jwXEZhbQkti8rYkVwpaX2LzmLfMERr5ZSMpmISmbhaRs
	ASPzKkbR0uLkguKk9FxDveLE3OLSvHS95PzcTYyQMCzawfhsg9UhRgEORiUeXo2wziAh1sSy
	4srcQ4wSHMxKIrwm/kAh3pTEyqrUovz4otKc1OJDjEwcnFINjLZyOyYuVm94uZbxTbHHsVQZ
	ps9HaiJ/VZZIXlerrtp7ZYXTxGMv/1QfvDQj9WuQ56sLvQ+1zE2+RKT/nT87fM7FOT823w13
	OrPD9PvES20NkUmsonvtljcf/xlcbJD4b8a0do7/Hl1/TY/lHHh4gltm9oOGVn8GpaiVmUVJ
	NawhKWbze1ceq1NiKc5INNRiLipOBABCul/zIQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git linux_next

For:
	- sb_edac: add support for Ivy Bridge support;
	- cell_edac: add a missing of_node_put() call

-

Following up the last week's discussion about EDAC, here's my part of the
EDAC patchset.

Thank you!
Mauro

-


The following changes since commit 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52:

  Linux 3.12 (2013-11-03 15:41:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git linux_next

for you to fetch changes up to 3e45588825c1c9c7b561102dd878d23af1b46bb9:

  cell_edac: fix missing of_node_put (2013-11-14 17:13:43 -0200)

----------------------------------------------------------------
Aristeu Rozanski (11):
      sb_edac: make RANK_CFG_A value part of sbridge_info
      sb_edac: isolate TOLM retrieval
      sb_edac: rename pci_br
      sb_edac: isolate TOHM retrieval
      sb_edac: allow different dram_rule arrays
      sb_edac: allow different interleave lists
      sb_edac: rework sad_pkg
      sb_edac: enable multiple PCI id tables to be used
      sb_edac: rename mci_bind_devs()
      sb_edac: avoid decoding the same error multiple times
      sb_edac: add support for Ivy Bridge

Libo Chen (1):
      cell_edac: fix missing of_node_put

 drivers/edac/cell_edac.c |   1 +
 drivers/edac/sb_edac.c   | 593 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------
 2 files changed, 465 insertions(+), 129 deletions(-)

