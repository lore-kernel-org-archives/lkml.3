Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935526Ab3IECj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 22:39:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55696 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab3IECj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 22:39:57 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-0a-5227eefb23b7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Milo Kim'" <milo.kim@ti.com>,
        "'Daniel Jeong'" <gshark.jeong@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 0/6] backlight updates for 3.12-rc1
Date: Thu, 05 Sep 2013 11:39:55 +0900
Message-id: <002101cea9e1$34a38330$9dea8990$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6p4TRpKe++09SiQwq9N1m2ivIIow==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zfd3f79SDDD69trCYs34Nm8Xk3V2s
	FpcXXgISu+awWSz/tY7FYveup6wObB47Z91l9zgx4zeLx575P1g9+rasYvQ4fmM7k8fnTXIB
	bFFcNimpOZllqUX6dglcGRv67rAVbJWtOLxsBmMD43aRLkZODgkBE4llS6azQ9hiEhfurWfr
	YuTiEBJYxihx+MgLZpiiW3d/s0MkpjNK7Lm6D8r5xSixZOlFJpAqNgE1iS9fDgMlODhEBPQl
	2lo0QGqYBbYySmz+uJsVpEZYwFhixeRORhCbRUBVoqt7GZjNK2ArsaTnKJQtKPFj8j0WEJtZ
	QEti/c7jTBC2vMTmNW+ZQeZLCKhLPPqrCxIWEdCTuLbzN1SJiMS+F+8YQfZKCFxil9j+BuQd
	kF0CEt8mH2KB6JWV2HQA6jFJiYMrbrBMYBSbhWTzLCSbZyHZPAvJigWMLKsYRVMLkguKk9KL
	jPWKE3OLS/PS9ZLzczcxQuKxfwfj3QPWhxiTgdZPZJYSTc4HxnNeSbyhsZmRhamJqbGRuaUZ
	acJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhjTVdPuZvQ5LFm4+H6thaagac+b
	xo2Lph9r2bkzJMLsb0nR/aVxJi+LLxecY54o4P555eFN8zXZW65/mWjjVKa/SU934VzOn8xi
	JYHr5GSrQhL1jp1YviP8N9sqt5bFDWEb3mjs7VWU513lmq38sme3i39X4IW//2dXzNr06+vV
	pKfRveIf+dqVWIozEg21mIuKEwGS7mRY3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQd3f79SDDNa8N7aYs34Nm8Xk3V2s
	FpcXXgISu+awWSz/tY7FYveup6wObB47Z91l9zgx4zeLx575P1g9+rasYvQ4fmM7k8fnTXIB
	bFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QHco
	KZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDM29N1hK9gqW3F42QzGBsbt
	Il2MnBwSAiYSt+7+ZoewxSQu3FvP1sXIxSEkMJ1RYs/VfewQzi9GiSVLLzKBVLEJqEl8+XIY
	KMHBISKgL9HWogFSwyywlVFi88fdrCA1wgLGEismdzKC2CwCqhJd3cvAbF4BW4klPUehbEGJ
	H5PvsYDYzAJaEut3HmeCsOUlNq95ywwyX0JAXeLRX12QsIiAnsS1nb+hSkQk9r14xziBUWAW
	kkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER/szqR2MKxssDjEK
	cDAq8fA2GKsHCbEmlhVX5h5ilOBgVhLhtVgJFOJNSaysSi3Kjy8qzUktPsSYDPToRGYp0eR8
	YCLKK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbG87PY9vxr
	Fm2qalJU3rWn0aJ9av0NN4k/n6IZ8zZ6meRcNA0XerxXcH312kiWIocic9tj725f+KrXfvuM
	zd+sle66NfXvw7xmVl+w4DhkMblwT8cuvouT76z8knFsZ/zUVtlPMvFKszi/Vx7uTYthnMF2
	Z4VlN89alR3CuWcXzVf//cSxfX6JEktxRqKhFnNRcSIAn5JK7zoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

This is the backlight updates for 3.12-rc1.
Please add these patches to mm-tree.

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


