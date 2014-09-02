Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbaIBR6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:58:37 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56143 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbaIBR6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:58:35 -0400
Date: Tue, 2 Sep 2014 11:58:31 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Mark Brown <broonie@kernel.org>, Mohit Kumar <mohit.kumar@st.com>
Subject: [GIT PULL] PCI fixes for v3.17
Message-ID: <20140902175831.GA10577@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This fixes an ARM allmodconfig build problem.

Bjorn


The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.17-fixes-1

for you to fetch changes up to 8d7004a6904cf089e0ebfe5a27e9674cee5db9dc:

  PCI: spear: Remove module option (2014-08-17 22:09:16 -0600)

----------------------------------------------------------------
PCI update for v3.17:

  ST Microelectronics SPEAr13xx
    - Remove module option (Sachin Kamat)

----------------------------------------------------------------
Sachin Kamat (1):
      PCI: spear: Remove module option

 drivers/pci/host/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
