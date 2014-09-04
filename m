Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaIDPBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:01:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55302 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaIDPBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:01:50 -0400
X-AuditID: cbfee690-f79ce6d00000115a-5f-54087edccbf8
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v2 0/4] Add max77693 haptic driver
Date: Fri, 05 Sep 2014 00:01:27 +0900
Message-id: <1409842891-26549-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsWyRsSkRPdOHUeIQecTK4vrX56zWhxe9ILR
	YkfDEVaL+1+PMlrc/PSN1eLyrjlsFqe7WR3YPXbOusvucefaHjaPeScDPfq2rGL0+LxJLoA1
	issmJTUnsyy1SN8ugSvj+KEVzAVbOCsOXrjA3MDYwN7FyMkhIWAisejmPyhbTOLCvfVsXYxc
	HEICSxklvnXOZIQperxsLTNEYjqjxIcNnxkhnDYmiWsLOsDa2QS0Jb6vX8wKYosIVEr0d79g
	BSliFuhhlPjevpoZJCEsYCRxa8pvJhCbRUBVYsacFWAreAU8JFbv+QpkcwCtU5CYM8kGpFdC
	4D+bxOEzbWwQ9QIS3yYfYoGokZXYdIAZ4jpJiYMrbrBMYBRcwMiwilE0tSC5oDgpvchErzgx
	t7g0L10vOT93EyMwaE//ezZhB+O9A9aHGAU4GJV4eAtesIcIsSaWFVfmHmI0BdowkVlKNDkf
	GBt5JfGGxmZGFqYmpsZG5pZmSuK8r6V+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgdGFn
	mr91r41W/xFHb+3jJZWK71cFv+VtK75isja10N2Is6TlxlfeXrtXk5R3Sn7TNs/fl237VeuC
	1n+m5rf2t+TOzvVsapF8+i+0UjzsxHqRkJIHFhcES5rf6dkt91y+dU6UjG9UnXgzt2r8SQ+h
	Kr4Uu/vT00/U6LwLYf+xKe7/0WCrt8eVWIozEg21mIuKEwE7cPh+VQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e+xoO6dOo4QgxlHjC2uf3nOanF40QtG
	ix0NR1gt7n89ymhx89M3VovLu+awWZzuZnVg99g56y67x51re9g85p0M9OjbsorR4/MmuQDW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGccPrWAu2MJZcfDCBeYGxgb2
	LkZODgkBE4nHy9YyQ9hiEhfurWfrYuTiEBKYzijxYcNnRginjUni2oIOsA42AW2J7+sXs4LY
	IgKVEv3dL1hBipgFehglvrevBhslLGAkcWvKbyYQm0VAVWLGnBWMIDavgIfE6j1fgWwOoHUK
	EnMm2Uxg5F7AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzgmnkntYFzZYHGIUYCDUYmH
	t+AFe4gQa2JZcWXuIUYJDmYlEV73PI4QId6UxMqq1KL8+KLSnNTiQ4ymQMsnMkuJJucD4zWv
	JN7Q2MTMyNLI3NDCyNhcSZz3QKt1oJBAemJJanZqakFqEUwfEwenVAPjRcmc8MylWz8kCT1f
	ssfDp15Iy1tVTEF8usLZk5clDJWVRZSd3FVtt674Jmu6eN2r+rbkRAexNTcaZKOXbefWb7/N
	Wv5mv8QcH/Od36Ju9y4ov+q0LzQm/eq69cYV9yS1/9cW8Zg0vZb9bpYsc3RVyict9YM+vDyd
	ne3lbkl/gjZHX7d+4qvEUpyRaKjFXFScCADR77oQnwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds max77693 haptic driver.
The max77693 is a Multifunction device with PMIC, CHARGER, LED,
MUIC, HAPTIC and this series is haptic device driver in MAX77693.
The haptic driver use regmap method for i2c communication and
support force feedback framework in input device.

Changes in v2:
 - split to documentation and mfd patchs.
 - Documentation : change explanation of haptic 
 - Documentation : remove pwm-names propertie in example

Jaewon Kim (4):
  mfd: max77693: Initialize haptic register map
  Input: misc: Add haptic driver on max77693
  mfd: max77693: add haptic of_compatible in mfd_cell
  mfd: max77693: Update DT binding to support haptic

 Documentation/devicetree/bindings/mfd/max77693.txt |   18 ++
 drivers/input/misc/Kconfig                         |   12 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/max77693-haptic.c               |  333 ++++++++++++++++++++
 drivers/mfd/max77693.c                             |   26 +-
 include/linux/mfd/max77693-private.h               |    9 +
 6 files changed, 395 insertions(+), 4 deletions(-)
 create mode 100644 drivers/input/misc/max77693-haptic.c

-- 
1.7.9.5

