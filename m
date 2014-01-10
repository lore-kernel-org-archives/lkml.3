Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbaAJGbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 01:31:09 -0500
Received: from mail-gg0-f178.google.com ([209.85.161.178]:52966 "EHLO
	mail-gg0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaAJGbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 01:31:05 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.5
To: torvalds@linux-foundation.org
Message-ID: <20140110063052.7168.29117@quantum>
Subject: [GIT PULL] clk: fixes for 3.13
Date: Thu, 09 Jan 2014 22:30:52 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc:

  Linux 3.13-rc7 (2014-01-04 15:12:14 -0800)

are available in the git repository at:

  git://git.linaro.org/people/mike.turquette/linux.git tags/clk-fixes-for-linus

for you to fetch changes up to 778037e1ccb75609846deca9e419449c1dc137fa:

  clk: clk-divider: fix divisor > 255 bug (2014-01-08 08:33:12 -0800)

----------------------------------------------------------------
Late fixes for clock drivers. All of these fixes are for user-visible
regressions, typically boot failures or other unsafe system
configuration that causes badness.

----------------------------------------------------------------
Abhilash Kesavan (4):
      clk: samsung: exynos5250: Fix ACP gate register offset
      clk: samsung: exynos5250: Add MDMA0 clocks
      ARM: dts: exynos5250: Fix MDMA0 clock number
      clk: samsung: exynos5250: Add CLK_IGNORE_UNUSED flag for the sysreg clock

Andrew Bresticker (1):
      clk: exynos5250: fix sysmmu_mfc{l,r} gate clocks

James Hogan (1):
      clk: clk-divider: fix divisor > 255 bug

Krzysztof Kozlowski (1):
      clk: exynos: File scope reg_save array should depend on PM_SLEEP

Mike Turquette (1):
      Merge tag 'samsung-clk-fixes' of git://git.kernel.org/.../tfiga/samsung-clk into clk-fixes

Seung-Woo Kim (1):
      clk: samsung: exynos4: Correct SRC_MFC register

 .../devicetree/bindings/clock/exynos5250-clock.txt         |  2 ++
 arch/arm/boot/dts/exynos5250.dtsi                          |  2 +-
 drivers/clk/clk-divider.c                                  |  2 +-
 drivers/clk/samsung/clk-exynos-audss.c                     | 10 +++++-----
 drivers/clk/samsung/clk-exynos4.c                          |  2 +-
 drivers/clk/samsung/clk-exynos5250.c                       | 14 +++++++++-----
 6 files changed, 19 insertions(+), 13 deletions(-)
