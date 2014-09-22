Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbaIVXoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 19:44:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:9371 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbaIVXoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 19:44:16 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-e6-5420b44c78ba
Message-id: <5420B44C.6060504@samsung.com>
Date: Tue, 23 Sep 2014 08:44:12 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        =?UTF-8?B?7J6E6re87Iud?= <geunsik.lim@samsung.com>
Subject: [GIT PULL] extcon next for v3.18
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWyRsSkUNd3i0KIwewDLBZ/JrSyWTQvXs9m
	cbbpDbvF5V1z2CxuN65gc2D12D93DbtH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZVz7rlmw
	XKbiw45TbA2MnWJdjJwcEgImEmfurGGGsMUkLtxbzwZiCwksZZT4OtENpmZP33VmiPgioHiT
	UhcjF5D9mlHi5PvDjCAJXgEtiWlPXjGB2CwCqhKXbjSB2WxA8f0vboANFRUIk1g5/QoLRL2g
	xI/J98BsEQENiZdHb7GADGUW2Mso8evWXbAGYQFNib9bToDZzALqEpPmLWKGsOUlNq95ywzS
	ICHQzy7xZ9EHVojNAhLfJh8CmsQBlJCV2HQA6jNJiYMrbrBMYBSZhWT3LCRjZyEZu4CReRWj
	aGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGYHSc/vdswg7GewesDzEKcDAq8fB6rFEIEWJNLCuu
	zD3EaAp0xURmKdHkfGAM5pXEGxqbGVmYmpgaG5lbmimJ876W+hksJJCeWJKanZpakFoUX1Sa
	k1p8iJGJg1OqgbE6qH+S886zvNUiWgo+Re9K7uVe+La4ao6v19LNXDHs0hqyeZYCX/9tj/9w
	/0Lo8zIf6wmbL77SW9m5QLMutJblxJGJvvr73J0lN7plP3dJi2EUq5jzQXDx6uyNk3KFWPI8
	fz/dmpw759/p8s3SKvwzd+tw6h0w+Pb04fNFbzRzI+wFhUUkm5RYijMSDbWYi4oTAXfdXRuJ	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t9jAV2fLQohBruvWFn8mdDKZtG8eD2b
	xdmmN+wWl3fNYbO43biCzYHVY//cNewefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZdu
	q+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RTSaEsMacUKBSQWFyspG+HaUJoiJuu
	BUxjhK5vSBBcj5EBGkhYw5hx7btmwXKZig87TrE1MHaKdTFyckgImEjs6bvODGGLSVy4t54N
	xBYSWMQo8bVJqYuRC8h+zShx8v1hRpAEr4CWxLQnr5hAbBYBVYlLN5rAbDag+P4XN8CaRQXC
	JFZOv8ICUS8o8WPyPTBbREBD4uXRWywgQ5kF9jJK/Lp1F6xBWEBT4u+WE2A2s4C6xKR5i5gh
	bHmJzWveMk9g5JuFZNYsJGWzkJQtYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcfc+k
	dzCuarA4xCjAwajEw+u5RiFEiDWxrLgy9xCjBAezkghvyUSgEG9KYmVValF+fFFpTmrxIUZT
	oFcnMkuJJucDE0NeSbyhsYmZkaWRuaGFkbG5kjjvwVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQZG
	42WHIy6H3lByN36x7BBP9qzEJ6d4tkc3pTxd371XqnuPRGM4h0TTFmWd64t29vy23+iV0Vbn
	ftudS+V4yTb5Y8pMBxeX79SufzTN5V7hrv3aF04qX1k3M+5h5Oolz3UyTEuTtbPvalk8fsp6
	Y5s8026Ha5k/7rI6/Ld/GRUU+dYoWVp3TWm+EktxRqKhFnNRcSIAoqCMh9QCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg,

This is extcon-next pull request for 3.18. I add detailed description of this
pull request on below. Please pull extcon with following updates.

This patchset is rebased on char-misc-next branch (3.17-rc5).

I'm so sorry for late pull request because I'm out of office for two weeks.

Best Regards,
Chanwoo Choi

The following changes since commit 9e82bf014195d6f0054982c463575cdce24292be:

  Linux 3.17-rc5 (2014-09-14 17:50:12 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-next-for-3.18

for you to fetch changes up to 62364357c184db52d556f868e493963fac2aea78:

  extcon: gpio: Fix code cleanup (2014-09-22 16:48:47 +0900)

----------------------------------------------------------------
Update extcon for v3.18

This patchset add new extcon provider driver and fix minor issue of extcon driver.

Detailed description for patchset:
1. Add new Richtek RT8973A extcon driver
This driver support for Richtek RT8973A which is Micro USB Switch OVP and
i2c interface. The RT8973A is a USB port accessory detector and switch that is
optimized to protect low voltage system from abnormal high input voltage
(up to 28V) and supports high speed USB operation. Also, RT8973A support
'auto-configuration' mode. If auto-configuration mode is enabled, RT8973A
would control internal h/w patch for USB D-/D+ switching.

2. Fix code cleanup for other extcon driver
- extcon-sm5502 driver
 : Fix bug to check cable type and build break.
 : Move header file from include/linux/extcon to drivers/extcon because this
   header file is only user for extcon-sm5502.c.
 : Clean up codes by using checkpatch script
- extcon-max77693 driver
 : Use resource managed interrupt function
 : Fix bug to set ADC debounce time
- extcon-gpio driver
 : Fix minor code cleanup

----------------------------------------------------------------
Chanwoo Choi (6):
      extcon: sm5502: Fix bug to check cable type
      extcon: sm5502: Add I2C dependency to fix build break
      extcon: sm5502: Move sm5502.h header file to extcon directory
      extcon: sm5502: Clean up codes by using checkpatch script
      extcon: rt8973a: Add Richtek RT8973A extcon driver
      dt-bindings: extcon: Add support for Richtek RT8973A MUIC device

George Cherian (1):
      extcon: gpio: Fix code cleanup

Jean Delvare (1):
      extcon: sm5502: Drop useless include

Jonghwa Lee (1):
      extcon: max77693: Fix a bug occured at changing ADC debounce time.

Krzysztof Kozlowski (1):
      extcon: max77693: Use resource managed interrupt line

 .../devicetree/bindings/extcon/extcon-rt8973a.txt  |  25 +
 drivers/extcon/Kconfig                             |  13 +
 drivers/extcon/Makefile                            |   1 +
 drivers/extcon/extcon-gpio.c                       |  10 +-
 drivers/extcon/extcon-max77693.c                   |  37 +-
 drivers/extcon/extcon-rt8973a.c                    | 740 +++++++++++++++++++++
 drivers/extcon/extcon-rt8973a.h                    | 203 ++++++
 drivers/extcon/extcon-sm5502.c                     |  20 +-
 .../sm5502.h => drivers/extcon/extcon-sm5502.h     |   5 -
 include/linux/extcon/extcon-gpio.h                 |   4 +-
 10 files changed, 1012 insertions(+), 46 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-rt8973a.txt
 create mode 100644 drivers/extcon/extcon-rt8973a.c
 create mode 100644 drivers/extcon/extcon-rt8973a.h
 rename include/linux/extcon/sm5502.h => drivers/extcon/extcon-sm5502.h (97%)
