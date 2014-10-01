Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190AbaJAGoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 02:44:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23286 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaJAGoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 02:44:09 -0400
X-AuditID: cbfee68e-f79b46d000002b74-eb-542ba2b60b3b
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Jaewon Kim <jaewon02.kim@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH RESEND v5 0/3] Add max77693 haptic driver
Date: Wed, 01 Oct 2014 15:43:55 +0900
Message-id: <1412145838-7563-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWyRsSkRHfbIu0Qg4u3dCyuf3nOanF40QtG
	ix0NR1gt7n89ymhxedccNgdWj52z7rJ73Lm2h82jb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4
	Mi71SRWs5qqYuf4aYwPjZI4uRg4OCQETie8vgrsYOYFMMYkL99azgdhCAksZJXo+BkDETSTu
	vn/L3sXIBRSfziixs7+PCcJpY5JYcnYvE0gVm4C2xPf1i1lBhooIqEice2MOUsMsMI9R4vzt
	PWwgcWEBS4lNu3JAylkEVCXuv97JDGLzCrhLbO1ewAxxj4LEnEk2IK0SAu/ZJNr/HWeDqBeQ
	+Db5EAtEjazEpgPMELdJShxccYNlAqPgAkaGVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxiB
	AXn637O+HYw3D1gfYhTgYFTi4VVI0A4RYk0sK67MPcRoCrRhIrOUaHI+MOzzSuINjc2MLExN
	TI2NzC3NlMR5E6R+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgDN2XqPPi794bl1zj/n6P
	m65w5q2cR2ZBZrfXjeogqbUrLk+Lvxuy6BfbHJPYjW1pupfa1Hu2dva8+WHt/p9Xc/kdN8NX
	R26vYdz9yTzk/bsH9Rm7bmg1CzyY++j/210fXt7dd6VjbUFD34eQ/GnZ+/+mKP88cdCHKSLL
	wLbt5GzPXNNq8XfSBkosxRmJhlrMRcWJAEEXftNDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t9jQd1ti7RDDGY/Vra4/uU5q8XhRS8Y
	LXY0HGG1uP/1KKPF5V1z2BxYPXbOusvucefaHjaPvi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1L
	zk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqspFCWmFMKFApILC5W0rfD
	NCE0xE3XAqYxQtc3JAiux8gADSSsYcy41CdVsJqrYub6a4wNjJM5uhg5OSQETCTuvn/LDmGL
	SVy4t56ti5GLQ0hgOqPEzv4+JginjUliydm9TCBVbALaEt/XL2btYuTgEBFQkTj3xhykhllg
	HqPE+dt72EDiwgKWEpt25YCUswioStx/vZMZxOYVcJfY2r2AGaREQkBBYs4kmwmM3AsYGVYx
	iqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBIf8M+kdjKsaLA4xCnAwKvHwViRphwixJpYVV+Ye
	YpTgYFYS4Z1YARTiTUmsrEotyo8vKs1JLT7EaAq0fCKzlGhyPjAe80riDY1NzIwsjcwNLYyM
	zZXEeQ+2WgcKCaQnlqRmp6YWpBbB9DFxcEo1MLrfD3jStG+O4VS51UnbHj5xn3TCfOXuPr/4
	SrFrigKPX1tLprGx3gsJdlhnfMzrtaLD7cY5zwQO/XgZtEB00/SOvzzLqyL9Uq+tlReTrbrQ
	NFtl7XnW1p+Xbk5wLzJv+BWwWXXuu72LjfXX6eg8bU26cb3efWP1sevf40xWF8xeaWr5TmyK
	53olluKMREMt5qLiRACkKClmjwIAAA==
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

Changes in v5:
 - Documentation : change explanation of haptic and pwm

Changes in v4:
 - mfd : fix tabbing in mfd_cell
 - driver : move regulator enable/disable to input open()/close()
 - driver : add resume function

Changes in v3:
 - driver : remove mutex in workqueue
 - driver : mv max77693_haptic_set_duty_cyle() to workqueue.
 - driver : remove max77693_haptic_remove[]
 - driver : add suspend() function to turn-off entering suspend.

Changes in v2:
 - split to documentation and mfd patchs.
 - Documentation : change explanation of haptic 
 - Documentation : remove pwm-names propertie in example


Jaewon Kim (3):
  mfd: max77693: Initialize haptic register map
  mfd: max77693: add haptic of_compatible in mfd_cell
  mfd: max77693: Update DT binding to support haptic

 Documentation/devicetree/bindings/mfd/max77693.txt |   21 ++++++++++++++++
 drivers/mfd/max77693.c                             |   26 +++++++++++++++++---
 2 files changed, 43 insertions(+), 4 deletions(-)

-- 
1.7.9.5

