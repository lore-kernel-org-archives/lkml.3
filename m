Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaIPJiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:38:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29669 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaIPJiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:38:08 -0400
X-AuditID: cbfee68d-f79c46d000000b84-36-541804fdf18a
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, sjg@chromium.org,
        grundler@chromium.org, linux-kernel@vger.kernel.org, wsa@the-dreams.de,
        cpgs@samsung.com, devicetree@vger.kernel.org
Subject: [PATCH 0/2] i2c: Add i2c support for Exynos7 SoC
Date: Tue, 16 Sep 2014 15:03:16 +0530
Message-id: <1410859998-29285-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWyRsSkWvcvi0SIwa+zRhYvD2lazD9yjtXi
	1ZEfTBabHl9jtej4+4XR4vKuOWwWM87vY7JYtO0/s8W3LdsYLVaemMXswOUxu+Eii8fOWXfZ
	PTYvqffo27KK0ePkqScsHp83yQWwRXHZpKTmZJalFunbJXBlrHj3jrFgO1fFm0MP2RsY93J0
	MXJySAiYSLzov8gOYYtJXLi3nq2LkYtDSGApo8TJzuXMMEWnP55mArGFBBYxSjQ3J0AU9TNJ
	TLu6BCzBJmAmcXDRarBJIgKyEq0P1jCDFDELfGWUODTvCViRsIClxP6DL8CKWARUJdrfLGDp
	YuTg4BVwlTj5yRDElBBQkJgzyQakVUJgHrvEq94pLBDlAhLfJh9igaiRldh0AOo2SYmDK26w
	TGAUXMDIsIpRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjMLBP/3vWu4Px9gHrQ4wCHIxKPLwe
	j8RDhFgTy4orcw8xmgJtmMgsJZqcD4yfvJJ4Q2MzIwtTE1NjI3NLMyVxXkWpn8FCAumJJanZ
	qakFqUXxRaU5qcWHGJk4OKUaGBPNWGTkE/b2Oc5ZZPVWIzes6uO/dalCnqYmoc5PniwvkJKp
	kb17gNtprbq3dcbb6ZtUY3rXN8qI6P+f+dTMK8PEQy1o3dQvO2c/07uQOjNw8oUbR5/83az1
	pfpE8ruDT1nm7OPyv1rALbLcpMY08pHFvhAre4GXXsYpt+yCE7Y57tQ+dvzfXyWW4oxEQy3m
	ouJEAPgxBFBnAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t9jAd2/LBIhBnvOaFq8PKRpMf/IOVaL
	V0d+MFlsenyN1aLj7xdGi8u75rBZzDi/j8li0bb/zBbftmxjtFh5YhazA5fH7IaLLB47Z91l
	99i8pN6jb8sqRo+Tp56weHzeJBfAFtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGto
	aWGupJCXmJtqq+TiE6DrlpkDdJmSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0
	kLCGMWPFu3eMBdu5Kt4cesjewLiXo4uRk0NCwETi9MfTTBC2mMSFe+vZQGwhgUWMEs3NCV2M
	XEB2P5PEtKtLwIrYBMwkDi5azQ5iiwjISrQ+WMMMUsQs8JVR4tC8J2BFwgKWEvsPvgArYhFQ
	lWh/s4Cli5GDg1fAVeLkJ0MQU0JAQWLOJJsJjNwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl
	5+duYgTHzTOpHYwrGywOMQpwMCrx8Ho8Eg8RYk0sK67MPcQowcGsJMJ78Q9QiDclsbIqtSg/
	vqg0J7X4EKMp0O6JzFKiyfnAmM4riTc0NjE3NTa1NLEwMbNUEuc90GodKCSQnliSmp2aWpBa
	BNPHxMEp1cAYaiwZlKE2cfIjDp65t+/k+1xfLXBiygOdlctXtG0+UXW3vfp3ze0OJe+Kr7td
	11jx9cgxHzygm1CtVH7/0uQTM9+dyhUvluIIW1kYGd49IXmL8/1Xb1PqDnvNeRJuOS0t8Vcu
	tz337k2vtzTGtIvtXK7p7nusKeB2/ExpX5uHR1OvR2zTUHmhxFKckWioxVxUnAgAhaJP1bEC	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds code to the i2c-exynos5.c driver to support
the HSI2C H/W available on Exynos7 SoC.

Also, modifies the Kconfig dependencies to be able to select
for ARCH_EXYNOS7 platform.

The following patches are tested based on Kgene's for-next tree.
https://git.kernel.org/cgit/linux/kernel/git/kgene/linux-samsung.git/log/?h=for-next

Following patches are required for this series:
1. "tty/serial: fix config dependencies for samsung serial"
   https://www.mail-archive.com/linux-samsung-soc <at> vger.kernel.org/msg36208.html
2. "dts, kbuild: Implement support for dtb vendor subdirs" patchset 
   http://comments.gmane.org/gmane.linux.kbuild.devel/12131
3. [PATCH v4 0/8] arch: arm64: enable support for Samsung Exynos7 SoC
   http://www.spinics.net/lists/devicetree/msg49130.html
4. [PATCH 0/4] Add initial support for pinctrl on Exynos7
   http://www.spinics.net/lists/devicetree/msg49237.html

Naveen Krishna Chatradhi (2):
  i2c: exynos: add support for HSI2C module on Exynos7
  i2c: exynos5: Add Kconfig dependencies

 .../devicetree/bindings/i2c/i2c-exynos5.txt        |    2 +
 drivers/i2c/busses/Kconfig                         |    2 +-
 drivers/i2c/busses/i2c-exynos5.c                   |   71 ++++++++++++++++++--
 3 files changed, 68 insertions(+), 7 deletions(-)

-- 
1.7.9.5

