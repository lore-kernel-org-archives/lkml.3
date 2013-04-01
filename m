Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab3DAUyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:54:10 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:42923 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab3DAUyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:54:08 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
User-Agent: alot/0.3.3+
To: torvalds@linux-foundation.org
Message-ID: <20130401205402.8177.16854@quantum>
Subject: [GIT PULL] clk: fixes for 3.9-rc6
Date: Mon, 01 Apr 2013 13:54:02 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mturquette/linux.git tags/clk-fixes-for-linus

for you to fetch changes up to 0f1bc12e9eddaba2baf52d020d37670dbabe3702:

  clk: tegra: Allow PLLE training to succeed (2013-04-01 11:44:38 -0700)

----------------------------------------------------------------
Missing base address in Tegra clock driver results in non-operational
PCIe.  On some devices this means that Ethernet will go uninitialized
and other devices will fail.  This pull request fixes it with a single
patch to pass the proper base address in the Tegra clock driver.

----------------------------------------------------------------
Thierry Reding (1):
      clk: tegra: Allow PLLE training to succeed

 drivers/clk/tegra/clk-tegra20.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
