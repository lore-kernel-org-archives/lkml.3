Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbaHVMqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:46:40 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:37078 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbaHVMqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:46:38 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Rui Zhang <rui.zhang@intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] thermal soc changes
Date: Fri, 22 Aug 2014 08:46:32 -0400
Message-Id: <1408711592-8917-1-git-send-email-edubezval@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rui,

Please pull these changes. Here we have three new features: IMX driver has
now support to i.mx6sx, the of-thermal now if aware of disabled thermal zones
in DT, and we shall have tracing support on thermal framework.

The following changes since commit 47d104ba5879790c7c91c3390b0b08399e168efe:

  Merge branches 'exynos-fix', 'for-rc', 'int3403-fix', 'misc', 'rcar-thermal' and 'sti-thermal' of .git into next (2014-07-22 10:13:00 +0800)

are available in the git repository at:


  https://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git 

for you to fetch changes up to 3c94f17e72a7bcf689756da100b6051e535c45f4:

  Thermal: imx: add i.mx6sx thermal support (2014-08-09 10:29:30 -0400)

----------------------------------------------------------------
Anson Huang (1):
      Thermal: imx: add i.mx6sx thermal support

Laxman Dewangan (1):
      thermal: add support to disable thermal zone from DTS

Punit Agrawal (3):
      thermal: trace: Trace temperature changes
      thermal: trace: Trace when a cooling device's state is updated
      thermal: trace: Trace when temperature is above a trip point

 .../devicetree/bindings/thermal/imx-thermal.txt    |  5 +-
 drivers/thermal/fair_share.c                       | 12 +++
 drivers/thermal/imx_thermal.c                      | 91 ++++++++++++++++++----
 drivers/thermal/of-thermal.c                       | 12 +++
 drivers/thermal/step_wise.c                        |  5 +-
 drivers/thermal/thermal_core.c                     |  7 ++
 include/trace/events/thermal.h                     | 83 ++++++++++++++++++++
 7 files changed, 200 insertions(+), 15 deletions(-)
 create mode 100644 include/trace/events/thermal.h


 BR,

 Eduardo Valentin
