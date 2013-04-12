Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab3DLL54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 07:57:56 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:39563 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab3DLL5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 07:57:55 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Shawn Guo <shawn.guo@freescale.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH v3] clk: add device tree fixed-factor-clock binding support
Date: Fri, 12 Apr 2013 13:57:43 +0200
Message-Id: <1365767864-7829-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since august this patch finally find a user:
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/arch/arc/boot/dts/abilis_*.dtsi.
So I resusrected this patch with small changed suggested by Christian
Ruppert.

Mike,
if you still agree with this patch, you can apply it.
It was based on 3.9-rc6 but it can also be applied on clk-next
without any conflict.

Changelog:
v2 -> v3

- Updating the binding documentation bu using clock-div and clock-mul
  instead of div and mul
- Adding the tested-by tag from by Christian Ruppert

v1 -> v2
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

