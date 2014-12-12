Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934805AbaLLKcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:32:45 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:60334 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933677AbaLLKci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:32:38 -0500
X-AuditID: cbfee68e-f79b46d000002b74-f2-548ac444e168
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-input@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v6 0/2] Add regulator-haptic driver
Date: Fri, 12 Dec 2014 19:32:27 +0900
Message-id: <1418380349-32588-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsWyRsSkRNf1SFeIwZ1bbBbXvzxntTi86AWj
	xY6GI6wWvQuuslnc/PSN1eLyrjlsFjPO72NyYPfYOesuu0ffllWMHp83yQUwR3HZpKTmZJal
	FunbJXBlPPoxgbngHFfF2YNXmBoYp3J0MXJySAiYSFydcpENwhaTuHBvPZgtJLCUUeLkIlOY
	mv+7brB3MXIBxRcxSrRN28IK4bQxSXx41cgIUsUmoC3xff1iVhBbRCBU4vOFWcwgRcwCGxkl
	fj26DJYQFjCW+DB1HZjNIqAqseHAKTCbV8BDYu+FF0CrOYDWKUjMmWQD0ish8J5N4sqLLewQ
	9QIS3yYfYoGokZXYdIAZ4jpJiYMrbrBMYBRcwMiwilE0tSC5oDgpvchIrzgxt7g0L10vOT93
	EyMwRE//e9a3g/HmAetDjAIcjEo8vC9Su0KEWBPLiitzDzGaAm2YyCwlmpwPjIS8knhDYzMj
	C1MTU2Mjc0szJXHeBKmfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYq/80x9j9NRKw7dmy
	vE/K+Zel6vWeFwHbGgtKNNs6wpb9n3z8Wubu6Ufkv962CGQLPLn/3EUBzr+enz6uy006q5U0
	U2bPmWiOI3UnNy85ZTqhxXri6c7pFh2LRT6tC8396bVz3SKxgzpzL5j+eHU08hiXgdVLuTZ9
	9d2rt15g0JGsZN2lfyO7RYmlOCPRUIu5qDgRADMuawNMAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e+xgK7Lka4QgxMLrCyuf3nOanF40QtG
	ix0NR1gtehdcZbO4+ekbq8XlXXPYLGac38fkwO6xc9Zddo++LasYPT5vkgtgjmpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzHj0YwJzwTmuirMHrzA1ME7l6GLk5JAQMJH4
	v+sGO4QtJnHh3nq2LkYuDiGBRYwSbdO2sEI4bUwSH141MoJUsQloS3xfv5gVxBYRCJX4fGEW
	M0gRs8BGRolfjy6DJYQFjCU+TF0HZrMIqEpsOHAKzOYV8JDYe+EF0AoOoHUKEnMm2Uxg5F7A
	yLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzgGnkntYFzZYHGIUYCDUYmH90VqV4gQa2JZ
	cWXuIUYJDmYlEd6/UUAh3pTEyqrUovz4otKc1OJDjKZAyycyS4km5wPjM68k3tDYxMzI0sjc
	0MLI2FxJnFfJvi1ESCA9sSQ1OzW1ILUIpo+Jg1OqgdFNXIWlv1ze+sTSbU55kUUqPZE/nHWD
	z2+PZphveWQpT7njNpE3x7W1vW5xN/yYKvlYLcDFmXmGwG2+Wze89aY8bTY43lE5a+OqdSLp
	gowVJfu5r92senet6OSMij1Of/jm20uYCi03i+la16zn2Kby+basmvC8npVlbTu9XC3fW315
	96PATImlOCPRUIu5qDgRALURIy6XAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds regulator-haptic driver.
The regulator-haptic has haptic motor and it is controlled by
voltage of regulator via force feedback framework.

Changes in v6:
 - prevent racing condition

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
 drivers/input/misc/regulator-haptic.c              |  259 ++++++++++++++++++++
 include/linux/input/regulator-haptic.h             |   31 +++
 6 files changed, 330 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/regulator-haptic.txt
 create mode 100644 drivers/input/misc/regulator-haptic.c
 create mode 100644 include/linux/input/regulator-haptic.h

-- 
1.7.9.5

