Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbaDSDVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 23:21:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48155 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaDSDVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 23:21:47 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL 0/4] phy: fixes for 3.15 -rc2
Date: Sat, 19 Apr 2014 08:51:40 +0530
Message-ID: <1397877704-2755-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's the PULL requeust for PHY subsystem for this -rc cycle. It consissts of
a bunch of critical fixes in PHY.

Let me know if I have to change anything.

Thanks
Kishon

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git tags/for-3.15-rc2

for you to fetch changes up to 354ea2fda82eab209d1544cde3b5fed5e6a86c4a:

  phy: core: make NULL a valid phy reference if !CONFIG_GENERIC_PHY (2014-04-16 18:10:47 +0530)

----------------------------------------------------------------
fixes for 3.15 -rc cycle

Bunch of critical fixes in PHY subsystem

----------------------------------------------------------------
Arnd Bergmann (1):
      phy: exynos: fix building as a module

Grygorii Strashko (1):
      phy: core: make NULL a valid phy reference if !CONFIG_GENERIC_PHY

Jean Delvare (1):
      phy: restore OMAP_CONTROL_PHY dependencies

Sergei Shtylyov (1):
      phy: fix kernel oops in phy_lookup()

 drivers/phy/Kconfig     |    1 +
 drivers/phy/Makefile    |    9 +++++----
 drivers/phy/phy-core.c  |    3 +++
 include/linux/phy/phy.h |   16 ++++++++++++++++
 4 files changed, 25 insertions(+), 4 deletions(-)
-- 
1.7.9.5

