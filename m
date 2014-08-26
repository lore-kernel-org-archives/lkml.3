Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbaHZM4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:56:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51958 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473AbaHZM4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:56:33 -0400
X-AuditID: cbfee68d-f79c46d000000b84-94-53fc83ffa55b
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 00/18] backlight: fix checkpatch warnings
Date: Tue, 26 Aug 2014 21:56:30 +0900
Message-id: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t8zQ93/zX+CDW6d47c4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDLmvXvJ
	XrBcuGLKvceMDYwn+boYOTkkBEwkzizfwgJhi0lcuLeerYuRi0NIYBmjRNOGfqAEB1hRb3c+
	RHwRo8TBu3dZQRqEBH4zSpw9kAxiswmoSXz5cpgdxBYRUJDY3PsMrIZZIFfi98yVjCC2sICl
	xKU5x8HiLAKqEtN3L2ICsXkFbCUevJvODmELSvyYfI8FoldLYv3O40wQtrzE5jVvmSHuUZd4
	9FcXYpWexKVrvVAlIhL7XrxjBLlTQmATu8S7pllsELsEJL5NPgT1i6zEpgPMEP9KShxccYNl
	AqPYLCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJReZKhXnJhbXJqXrpecn7uJERJjvTsYbx+w
	PsQowMGoxMN7I/53sBBrYllxZe4hRlOgiyYyS4km5wMjOa8k3tDYzMjC1MTU2Mjc0kxJnFdR
	6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkY/69cbz2Qsb3CTWTN7wdV3205FPDlaYHUz
	2Xdpi7dK8PPmPi1NDa6XNZeMeGdPuqOsw8hi9eWz5HqdDXOcHx46UXf5zOzjCTHP8xedcJa0
	OcZzTto+Yvuxh38YDjSp3tZz0XX06bc6FFcT1602I0THYWepT1Qj88XVh/vC8hcukJJpKK7o
	P6DEUpyRaKjFXFScCADOeIAqrAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jAd3/zX+CDVZd5rY4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgz5r17yV6wXLhiyr3HjA2MJ/m6GDk4JARMJHq787sYOYFMMYkL
	99azdTFycQgJLGKUOHj3LitIQkjgN6PE2QPJIDabgJrEly+H2UFsEQEFic29z8BqmAVyJX7P
	XMkIYgsLWEpcmnMcLM4ioCoxffciJhCbV8BW4sG76ewQtqDEj8n3WCB6tSTW7zzOBGHLS2xe
	85YZ4jZ1iUd/dSFW6UlcutYLVSIise/FO8YJjAKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4
	KT3XSK84Mbe4NC9dLzk/dxMjOIKfSe9gXNVgcYhRgINRiYf3RvzvYCHWxLLiytxDjBIczEoi
	vD+S/gQL8aYkVlalFuXHF5XmpBYfYjQFenQis5Rocj4wueSVxBsam5gZWRqZWRiZmJsrifMe
	bLUOFBJITyxJzU5NLUgtgulj4uCUamDMLF/7XuTczzwf9TgZwfAvl92kyt8HHvcTOuy+8tu3
	OffNW2w+qx1c4XTi7+Tf4REJF7ctPHH6wIKXpVzpHZkKuSnqbNJVbPsOrIj/MnVejfU55un5
	BnEvpmZIHbcJ3isWuz6/pejbDmPWVY9i9tbmPXZvevhM/e/9BUknClYI6rF8lPmj+NdHiaU4
	I9FQi7moOBEAkqWNOfYCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes checkpatch warnings as follows.
There is no functional change.

   WARNING: Missing a blank line after declarations
   WARNING: else is not generally useful after a break or return
   WARNING: void function return statements are not generally useful

Jingoo Han (18)
      backlight: adp5520: add blank line after declarations
      backlight: adp8860: add blank line after declarations
      backlight: adp8870: add blank line after declarations
      backlight: ams369fg06: remove 'else' after a return
      backlight: corgi_lcd: add blank line after declarations
      backlight: cr_bllcd: add blank line after declarations
      backlight: ili922x: remove 'else' after a return
      backlight: ld9040: remove 'else' after a return
      backlight: lm3639: remove unnecessary return statements
      backlight: lms501kf03: remove 'else' after a return
      backlight: lp855x: add blank line after declarations
      backlight: pcf50633: add blank line after declarations
      backlight: s6e63m0: remove 'else' after a return
      backlight: tdo24m: add blank line after declarations
      backlight: wm831x_bl: add blank line after declarations
      backlight: jornada720: remove 'else' after a return
      backlight: jornada720: remove 'else' after a return
      backlight: omap1: add blank line after declarations
   
---
 drivers/video/backlight/adp5520_bl.c         |  1 +
 drivers/video/backlight/adp8860_bl.c         |  3 +++
 drivers/video/backlight/adp8870_bl.c         |  4 ++++
 drivers/video/backlight/ams369fg06.c         |  6 +++---
 drivers/video/backlight/corgi_lcd.c          |  1 +
 drivers/video/backlight/cr_bllcd.c           |  1 +
 drivers/video/backlight/ili922x.c            | 11 ++++++-----
 drivers/video/backlight/jornada720_bl.c      |  6 +++---
 drivers/video/backlight/jornada720_lcd.c     |  4 ++--
 drivers/video/backlight/ld9040.c             |  6 +++---
 drivers/video/backlight/lm3639_bl.c          |  2 --
 drivers/video/backlight/lms501kf03.c         | 12 ++++++------
 drivers/video/backlight/lp855x_bl.c          |  2 ++
 drivers/video/backlight/omap1_bl.c           |  1 +
 drivers/video/backlight/pcf50633-backlight.c |  1 +
 drivers/video/backlight/s6e63m0.c            | 12 ++++++------
 drivers/video/backlight/tdo24m.c             |  2 ++
 drivers/video/backlight/wm831x_bl.c          |  1 +
 18 files changed, 46 insertions(+), 30 deletions(-)


