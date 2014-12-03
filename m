Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaLCHzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:55:51 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:23377 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbaLCHzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:55:47 -0500
X-AuditID: cbfee68d-f79296d000004278-39-547ec1f38156
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-input@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v5 0/2] Add regulator-haptic driver
Date: Wed, 03 Dec 2014 16:55:26 +0900
Message-id: <1417593328-8223-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsWyRsSkRPfzwboQg31HpS2uf3nOanF40QtG
	ix0NR1gtehdcZbO4+ekbq8XlXXPYLGac38fkwO6xc9Zddo++LasYPT5vkgtgjuKySUnNySxL
	LdK3S+DKWLx/BlPBXK6KvT8nMDUwfmLvYuTkkBAwkbi5cz4jhC0mceHeejYQW0hgKaPEzVuK
	XYwcYDW775V0MXIBhRcxSjxY2McE4bQxSZzdeZ0ZpIFNQFvi+/rFrCC2iECoxOcLs5hBipgF
	NjJK/Hp0GSwhLGAs8XvDXyYQm0VAVWLVrEVgNq+Au0Rb829WiG0KEnMm2YD0Sgh8ZpN4c+A5
	I0S9gMS3yYdYIGpkJTYdYIY4WlLi4IobLBMYBRcwMqxiFE0tSC4oTkovMtQrTswtLs1L10vO
	z93ECAzQ0/+e9e5gvH3A+hCjAAejEg+vRVxdiBBrYllxZe4hRlOgDROZpUST84FxkFcSb2hs
	ZmRhamJqbGRuaaYkzqso9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6PX/rc71p52KXv4
	kn+ZwXbr1btvlVc8069PYPzldI9tww2+6ZzlAgcDOsL3M550kVh3LtVFanfnBh1xhuN/V30s
	iL8zg39q9DaNPxPuzNo/J4N7zhtrm0L3qZ9YLLhn/iwRyP14p153m+gsluMrf5yd6x/QOXn+
	3P6npf77P17wucKzfFvouZtflViKMxINtZiLihMBx0YtWUsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e+xgO7ng3UhBnvnilhc//Kc1eLwoheM
	FjsajrBa9C64ymZx89M3VovLu+awWcw4v4/Jgd1j56y77B59W1YxenzeJBfAHNXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmLF4/wymgrlcFXt/TmBqYPzE3sXIwSEhYCKx
	+15JFyMnkCkmceHeerYuRi4OIYFFjBIPFvYxQThtTBJnd15nBqliE9CW+L5+MSuILSIQKvH5
	wixmkCJmgY2MEr8eXQZLCAsYS/ze8JcJxGYRUJVYNWsRmM0r4C7R1vybFWKzgsScSTYTGLkX
	MDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOgGdSOxhXNlgcYhTgYFTi4bWIqwsRYk0s
	K67MPcQowcGsJMK7bAdQiDclsbIqtSg/vqg0J7X4EKMp0PKJzFKiyfnA6MwriTc0NjEzsjQy
	N7QwMjZXEue9cTM3REggPbEkNTs1tSC1CKaPiYNTqoGRpejHd/mKTDV9eY5df2aaNB3NntS9
	hI+Rbd2vXeapO/sbD0xw6rpskuC/+NcMjfCb/q+z5pyaxVbvOGFHbEHd8leeZyxvPXp26cm8
	n806m+N8j1Xnn97Izb2g3oXTXijtLeutg88On+/q1fCeeznxqodgNqe8r7TolPLz5vZqt6on
	HlDkr92pxFKckWioxVxUnAgAhE6xcpYCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds regulator-haptic driver.
The regulator-haptic has haptic motor and it is controlled by
voltage of regulator via force feedback framework.

Changes in v5:
 - give preference to platform data

Changes in v4:
 - _regulator_get() -> _regulator_get_exclusive()

Changes in v3:
 - fix typo in Documentation
 - add define in header file

Changes in v2:
 - remove driver owner
 - merge enable/disable function
 - support platform data
 - fix wrong suspends_state check in regulator_haptic_resume()

Jaewon Kim (2):
  Input: add regulator haptic driver
  ARM: dts: Add regulator-haptic device node for exynos3250-rinato

 .../devicetree/bindings/input/regulator-haptic.txt |   21 ++
 arch/arm/boot/dts/exynos3250-rinato.dts            |    7 +
 drivers/input/misc/Kconfig                         |   11 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/regulator-haptic.c              |  246 ++++++++++++++++++++
 include/linux/input/regulator-haptic.h             |   31 +++
 6 files changed, 317 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/regulator-haptic.txt
 create mode 100644 drivers/input/misc/regulator-haptic.c
 create mode 100644 include/linux/input/regulator-haptic.h

-- 
1.7.9.5

