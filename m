Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3DLJ6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 05:58:45 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:39006 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab3DLJ6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 05:58:44 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.or
Cc: Shawn Guo <shawn.guo@freescale.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH v2] clk: add device tree fixed-factor-clock binding support
Date: Fri, 12 Apr 2013 11:58:27 +0200
Message-Id: <1365760708-4763-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[I resend it because I forgot to add the mainling lists!]

Since august this patch finally find a user:
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/arch/arc/boot/dts/abilis_*.dtsi.
So I resusrected this patch with small changed suggested by Christian
Ruppert.

- Adding CLK_OF_DECLARE
- Using IS_ERR to test the clk value

Thanks,

Gregory CLEMENT (1):
  clk: add device tree fixed-factor-clock binding support

 .../bindings/clock/fixed-factor-clock.txt          |   24 +++++++++++++
 drivers/clk/clk-fixed-factor.c                     |   36 ++++++++++++++++++++
 include/linux/clk-provider.h                       |    2 ++
 3 files changed, 62 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/fixed-factor-clock.txt

-- 
1.7.9.5

