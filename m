Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaBJU1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:27:32 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38520 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbaBJU11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:27:27 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <ivan.khoronzhuk@ti.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 0/2] clk: keystone: Couple of fixes for 3.14-rcx
Date: Mon, 10 Feb 2014 15:26:49 -0500
Message-ID: <1392064011-11986-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

Can you please look at these couple of keystone clock fixes ?
Without these, we have seen some random kernel crashes. I
have included the dts fix since both fixes are related. Do
let me know if you prefer dts patch to be sent it via arm-soc tree.

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git for_3.14-rcx/clk-fixes

for you to fetch changes up to 565bbdcd3b91523b4142587c00206302e091a23e:

  ARM: keystone: dts: fix clkvcp3 control register address (2014-02-10 15:17:43 -0500)

----------------------------------------------------------------
Ivan Khoronzhuk (2):
      clk: keystone: gate: fix clk_init_data initialization
      ARM: keystone: dts: fix clkvcp3 control register address

 arch/arm/boot/dts/keystone-clocks.dtsi |    2 +-
 drivers/clk/keystone/gate.c            |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

Regards,
Santosh

-- 
1.7.9.5

