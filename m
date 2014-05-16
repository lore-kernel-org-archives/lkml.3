Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbaEPO2C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:28:02 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:56884 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964AbaEPO17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:27:59 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@linaro.org>
Date: Fri, 16 May 2014 15:27:39 +0100
X-Google-Sender-Auth: Y6dY3wXrnroSuU4_SxrOp1uwY0E
Message-ID: <CACxGe6v5vAXypkOcX7ZLqpsDaVNxCGanYCuytWrLzu_6pRXFuA@mail.gmail.com>
Subject: [GIT PULL] Devicetree fixes for v3.15
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Cc: Rob Herring <rob.herring@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following bug fix branch.

Thanks,
g.

The following changes since commit 14186fea0cb06bc43181ce239efe0df6f1af260a:

  Merge tag 'locks-v3.15-4' of git://git.samba.org/jlayton/linux
(2014-05-13 11:33:09 +0900)

are available in the git repository at:


  git://git.secretlab.ca/git/linux tags/dt-for-linus

for you to fetch changes up to dfc44f8030653b345fc6fb337558c3a07536823f:

  mips: dts: Fix missing device_type="memory" property in memory nodes
(2014-05-16 15:22:53 +0100)

----------------------------------------------------------------
Drivercore bugfixes for v3.15

This branch contains bug fixes important to get into v3.15. There is a
fix for modifying properties seen during early boot, a fix for an
incorrect prototype when CONFIG_OF=n, and a couple of corrections to
device tree memory nodes on  a few platforms.

----------------------------------------------------------------
Leif Lindholm (2):
      arm: dts: Fix missing device_type="memory" for ste-ccu8540
      mips: dts: Fix missing device_type="memory" property in memory nodes

Stephen Rothwell (1):
      of: fix CONFIG_OF=n prototype of of_node_full_name()

Thomas Petazzoni (1):
      of: make of_update_property() usable earlier in the boot process

 arch/arm/boot/dts/ste-ccu8540.dts     | 1 +
 arch/mips/lantiq/dts/easy50712.dts    | 1 +
 arch/mips/ralink/dts/mt7620a_eval.dts | 1 +
 arch/mips/ralink/dts/rt2880_eval.dts  | 1 +
 arch/mips/ralink/dts/rt3052_eval.dts  | 1 +
 arch/mips/ralink/dts/rt3883_eval.dts  | 1 +
 drivers/of/base.c                     | 4 ++++
 include/linux/of.h                    | 2 +-
 8 files changed, 11 insertions(+), 1 deletion(-)
