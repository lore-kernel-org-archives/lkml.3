Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3LRAeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 19:34:50 -0500
Received: from mga03.intel.com ([143.182.124.21]:30382 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab3LRAeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 19:34:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,504,1384329600"; 
   d="scan'208";a="397432148"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Update to error injection interface
Date: Tue, 17 Dec 2013 16:34:41 -0800
Message-Id: <52b0eda116006e30e1@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please queue in x86/ras branch for next merge window.

Thanks

-Tony

The following changes since commit 319e2e3f63c348a9b66db4667efa73178e18b17d:

  Linux 3.13-rc4 (2013-12-15 12:31:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-einj

for you to fetch changes up to 3482fb5e0c1c20ce0dbcfc5ca3b6558a8c455b10:

  ACPI, APEI, EINJ: Changes to the ACPI/APEI/EINJ debugfs interface (2013-12-17 16:04:22 -0800)

----------------------------------------------------------------
Add more flexibility to debugfs i/f to error injection (EINJ)

----------------------------------------------------------------
Tony Luck (1):
      ACPI, APEI, EINJ: Changes to the ACPI/APEI/EINJ debugfs interface

 Documentation/acpi/apei/einj.txt | 19 ++++++++++++++++++-
 drivers/acpi/apei/einj.c         | 39 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 52 insertions(+), 6 deletions(-)
