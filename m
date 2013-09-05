Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab3IEEOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 00:14:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33748 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab3IEEOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 00:14:19 -0400
X-AuditID: cbfee68e-b7f756d000004512-62-52280515a334
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Milo Kim'" <milo.kim@ti.com>,
        "'Daniel Jeong'" <gshark.jeong@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH V2 0/6] backlight updates for 3.12-rc1
Date: Thu, 05 Sep 2013 13:14:12 +0900
Message-id: <000701cea9ee$609bfff0$21d3ffd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6p7mBpdyq9ywYnR82rhDmFCL2hBA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zA11RVo0gg1sz2CzmrF/DZjF5dxer
	xeWFl4DErjlsFst/rWOx2L3rKasDm8fOWXfZPU7M+M3isWf+D1aPvi2rGD2O39jO5PF5k1wA
	WxSXTUpqTmZZapG+XQJXxu4lC9gKrstVrNh6m7WBcadoFyMnh4SAicS5azvYIGwxiQv31gPZ
	XBxCAssYJc5N3sQIU7Tv6hcWiMQiRok911aCdQgJ/GKU+LojDcRmE1CT+PLlMHsXIweHiIC+
	RFuLBkg9s8BWRonNH3ezgtQIC5hJrNnyFKyXRUBV4t+GiywgNq+ArcT6mY1sELagxI/J98Di
	zAJaEut3HmeCsOUlNq95ywwyX0JAXeLRX12QsIiAnsTRN8ugykUk9r14xwiyV0LgGrvEm1ed
	rBC7BCS+TT7EAtErK7HpADPEX5ISB1fcYJnAKDYLyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQn
	pRcZ6RUn5haX5qXrJefnbmKERGPfDsabB6wPMSYDrZ/ILCWanA+M5rySeENjMyMLUxNTYyNz
	SzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MM6V0OV48aut7RnP2osMjspB
	627dXFWWukmeQ6fEWzp9NfukrCtMT5aevaH5+rTv0rgibe1l64X/T+GM+3BMqzZSuG3j8uOC
	Pkt0rgVv0W0yENnTPluqdo40vwvzrV0zfC4vFPwUcOlcwPKnsSXergE2PJyM9r+5juYskfYR
	Obr8upVhrv60ICWW4oxEQy3mouJEAIiiV7LcAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAV1RVo0ggx8PGS3mrF/DZjF5dxer
	xeWFl4DErjlsFst/rWOx2L3rKasDm8fOWXfZPU7M+M3isWf+D1aPvi2rGD2O39jO5PF5k1wA
	W1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0B1K
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xozdSxawFVyXq1ix9TZrA+NO
	0S5GTg4JAROJfVe/sEDYYhIX7q1n62Lk4hASWMQosefaSjaQhJDAL0aJrzvSQGw2ATWJL18O
	s3cxcnCICOhLtLVogNQzC2xllNj8cTcrSI2wgJnEmi1PwXpZBFQl/m24CLaAV8BWYv3MRjYI
	W1Dix+R7YHFmAS2J9TuPM0HY8hKb17xlBpkvIaAu8eivLkhYREBP4uibZVDlIhL7XrxjnMAo
	MAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJj/Zn0DsZVDRaH
	GAU4GJV4eBuM1YOEWBPLiitzDzFKcDArifBarAQK8aYkVlalFuXHF5XmpBYfYkwGenQis5Ro
	cj4wDeWVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2NG+ZZn
	JxvX/9Bv/nnFrO5N0zNGRp/uOlW9/+eftHczmDVKT+qVcUmUM5L18NaZN9nyivEdJZ8Ks6VG
	y2ZzSa4sf/w/IaHz1PItzH+nikWIsB/nnq39V2zWXt05/JJN+nPutB7UOvpSaJvZk86gN2IO
	Hmutr+w3z/hUk//l2+nQnrlRR0MmhimxFGckGmoxFxUnAgBT8hndOQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

This is the 2nd version of the backlight updates for 3.12-rc1.
Please add these patches to mm-tree.

Changes since v1:
- Added missing author's information to 1st and 2nd patch.
- Added missing committer's signed-off to 1st and 2nd patch.

Best regards,
Jingoo Han

----------------------------------------------------------------
backlight updates for 3.12-rc1

- LP855x: Add LP8555 support
- LM3630 is changed to LM3630A
- Fix sparse warnings: ld9040, lm3639 and lp8788

----------------------------------------------------------------

Daniel Jeong (1):
      backlight: lm3630: apply chip revision

Jingoo Han (4):
      backlight: ld9040: Staticize local variable gamma_table
      backlight: lm3639: Don't mix different enum types
      backlight: lp8788: Staticize 'default_bl_config'
      backlight: use dev_get_platdata()

Milo Kim (1):
      backlight: lp855x_bl: support new LP8555 device

 Documentation/backlight/lp855x-driver.txt          |    5 +-
 .../devicetree/bindings/video/backlight/lp855x.txt |   29 +-
 drivers/video/backlight/88pm860x_bl.c              |    2 +-
 drivers/video/backlight/Kconfig                    |   10 +-
 drivers/video/backlight/Makefile                   |    2 +-
 drivers/video/backlight/aat2870_bl.c               |    2 +-
 drivers/video/backlight/adp5520_bl.c               |    2 +-
 drivers/video/backlight/adp8860_bl.c               |    6 +-
 drivers/video/backlight/adp8870_bl.c               |    6 +-
 drivers/video/backlight/ams369fg06.c               |    2 +-
 drivers/video/backlight/atmel-pwm-bl.c             |    2 +-
 drivers/video/backlight/bd6107.c                   |    2 +-
 drivers/video/backlight/corgi_lcd.c                |    2 +-
 drivers/video/backlight/da903x_bl.c                |    2 +-
 drivers/video/backlight/generic_bl.c               |    2 +-
 drivers/video/backlight/gpio_backlight.c           |    3 +-
 drivers/video/backlight/ili9320.c                  |    2 +-
 drivers/video/backlight/kb3886_bl.c                |    2 +-
 drivers/video/backlight/l4f00242t03.c              |    6 +-
 drivers/video/backlight/ld9040.c                   |    2 +-
 drivers/video/backlight/ld9040_gamma.h             |    4 +-
 drivers/video/backlight/lm3533_bl.c                |    2 +-
 drivers/video/backlight/lm3630_bl.c                |  475 -------------------
 drivers/video/backlight/lm3630a_bl.c               |  483 ++++++++++++++++++++
 drivers/video/backlight/lm3639_bl.c                |   13 +-
 drivers/video/backlight/lms283gf05.c               |    4 +-
 drivers/video/backlight/lms501kf03.c               |    2 +-
 drivers/video/backlight/lp855x_bl.c                |   21 +-
 drivers/video/backlight/lp8788_bl.c                |    2 +-
 drivers/video/backlight/lv5207lp.c                 |    2 +-
 drivers/video/backlight/omap1_bl.c                 |    2 +-
 drivers/video/backlight/pcf50633-backlight.c       |    2 +-
 drivers/video/backlight/platform_lcd.c             |    2 +-
 drivers/video/backlight/pwm_bl.c                   |    2 +-
 drivers/video/backlight/s6e63m0.c                  |    2 +-
 drivers/video/backlight/tdo24m.c                   |    2 +-
 drivers/video/backlight/tosa_bl.c                  |    2 +-
 drivers/video/backlight/tps65217_bl.c              |    5 +-
 drivers/video/backlight/wm831x_bl.c                |    8 +-
 include/linux/platform_data/lm3630_bl.h            |   57 ---
 include/linux/platform_data/lm3630a_bl.h           |   65 +++
 include/linux/platform_data/lp855x.h               |   19 +
 42 files changed, 673 insertions(+), 594 deletions(-)
 delete mode 100644 drivers/video/backlight/lm3630_bl.c
 create mode 100644 drivers/video/backlight/lm3630a_bl.c
 delete mode 100644 include/linux/platform_data/lm3630_bl.h
 create mode 100644 include/linux/platform_data/lm3630a_bl.h


