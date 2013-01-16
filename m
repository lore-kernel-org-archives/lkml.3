Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3APGGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 01:06:40 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:40748 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab3APGGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 01:06:38 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-77-50f6436d0916
Message-id: <50F6437D.50907@samsung.com>
Date: Wed, 16 Jan 2013 15:06:53 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, cwchoi00@gmail.com
Subject: [GIT PULL] extcon for v3.9
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e+Zpm6u87cAg/4H/BaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSuj8edrxoJTUhU3L1xja2BcLNrFyMkhIWAi0fOgixnCFpO4cG89
	WxcjF4eQwDJGiXVbljLBFL180skKYgsJTGeUOLJEB6Koi0li3ryNYN28AhoS7++9A2tgEVCV
	mLDrD1icTUBLYv+LG0BTOThEBSIkfvVzQJQLSvyYfI8FxBYBan159BYLyExmgfeMEvcuTQBL
	CAsoS/yd+BrMZhbQkdjfOo0NwpaX2LzmLTPELgGJb5MPsYDMlxCQldh0gBlkjoTAezaJKQe3
	Qj0gKXFwxQ2WCYwis5DsnoVk7CwkYxcwMq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECAlx
	qR2MKxssDjEKcDAq8fB6FX4NEGJNLCuuzD3EKMHBrCTCu8z+W4AQb0piZVVqUX58UWlOavEh
	Rh+gaycyS4km5wPjL68k3tDYwNjQ0NLQzNTS1ACHsJI4L+OpJwFCAumJJanZqakFqUUw45g4
	OKUaGEM19jlXnEmYneS8W6fT5fycgyafD+8uPmvyc7603JOMz+lnlq0wyf80rSb6xKF03gU9
	G+K93y46cWq50s+7lacXtnf1Bqx4fa+6/Pub9Q+F+W3XX9z6IePmzKYHG6d1nPa+co5DYsqq
	9EMKu8L5/syboOezxHmRr3Jk5EQh4ZVJ6lsZzqW8ZmVTYinOSDTUYi4qTgQAG0pUX54CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jQd1c528BBj03WCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jRuPP14wFp6Qqbl64xtbA
	uFi0i5GTQ0LAROLlk05WCFtM4sK99WwgtpDAdEaJI0t0uhi5gOwuJol58zYygyR4BTQk3t97
	xwRiswioSkzY9QcsziagJbH/xQ2gZg4OUYEIiV/9HBDlghI/Jt9jAbFFgFpfHr3FAjKTWeA9
	o8S9SxPAEsICyhJ/J74Gs5kFdCT2t05jg7DlJTavecs8gZFvFpJZs5CUzUJStoCReRWjaGpB
	ckFxUnquoV5xYm5xaV66XnJ+7iZGcAQ9k9rBuLLB4hCjAAejEg+vV+HXACHWxLLiytxDjBIc
	zEoivMvsvwUI8aYkVlalFuXHF5XmpBYfYvQB+nQis5Rocj4wuvNK4g2NTcyMLI3MjE3MjY1x
	CCuJ8zKeehIgJJCeWJKanZpakFoEM46Jg1OqgXGu5iNFKYmol+8rn1zctega+4QG2/qd7/c+
	urSCg5lZ//jxW2l/pLYzPYk0sU8LlDCRrD1415nxHtemrOWJxbIHWt9Zz2As2ik7VWO29w47
	y3rNPdvsLosGJB0+UrmaoyC9d8+Mj/XrAn5fuWoW+qDr78szIS/tIk/dqBG311v6KPrY6Zdt
	P5uVWIozEg21mIuKEwGXFHEezQIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This is the extcon pull request for v3.9.

I don't send separate pull request of extcon about bugfixes patch.
I'd like to apply this patch-set to your next branch for v3.9.

Please pull extcon with following updates.

Update to max77693/max8997 extcon driver:
- Using MHL_TA cable for charging.
- Support JIG cable.
- Support Dock-Audio device for playing music and button of device.
- Support Dock-Smart device for desktop mode with mouse/keyboard.
- Set default UART/USB path on probe().
- Check the state/type of cable after completing initialization.
- Code clean to remove duplicate code and bug fix related to sequence of interrupt.
- Fix irq_flag of max8997/max77693 driver.

Update to arizona extcon driver:
- Headphone measurements.
- Alternative detection mechanism for non-default system designs.
- Microphone clamp integration.
- Support for additional detection pin.
- MICBIAS rise time configuration.

Best regards,
Chanwoo Choi

The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-for-3.9

for you to fetch changes up to 689557d3c7045320958d5bc4141088f7b4dff7ba:

  mfd: wm5102: Add microphone clamp control registers (2013-01-15 15:42:18 +0900)

----------------------------------------------------------------
Chanwoo Choi (9):
      extcon: max77693: Remove duplicate code by making function
      extcon: max77693: Add support MHL_TA cable for charging battery
      extcon: max77693: Add support jig cable
      extcon: max77693: Add support dock device and buttons
      extcon: max77693: Check the state/type of cable after boot completed
      extcon: max8997/max77693: Support IRQF_NO_SUSPEND flag for interrupt
      extcon: max77693: Set default uart/usb path by using platform data
      extcon: max77693: Fix bug when detecting MHL/Dock-Audio with USB/TA cable
      extcon: max77693: Add support Dock-Smart device for desktop mode

Mark Brown (11):
      extcon: arizona: Convert to devm_input_allocate_device()
      extcon: arizona: Remove duplicate mic ramp configuration
      extcon: arizona: Only set GPIO if it has been requested
      extcon: arizona: Allow configuration of MICBIAS rise time
      extcon: arizona: Use microphone clamp function if available
      extcon: arizona: Support use of GPIO5 as an input to jack detection
      extcon: arizona: Enable basic headphone identification
      extcon: Simple code motion supporting future work.
      extcon: arizona: Support HPDET based accessory identification
      extcon: arizona: Support direct microphone measurement via HPDET
      mfd: wm5102: Add microphone clamp control registers

 drivers/extcon/extcon-arizona.c       | 634 +++++++++++++++++++++--
 drivers/extcon/extcon-max77693.c      | 920 +++++++++++++++++++++++++---------
 drivers/extcon/extcon-max8997.c       |   6 +-
 drivers/mfd/wm5102-tables.c           |  10 +
 include/linux/mfd/arizona/core.h      |   4 +-
 include/linux/mfd/arizona/pdata.h     |  12 +
 include/linux/mfd/arizona/registers.h |  48 ++
 include/linux/mfd/max77693-private.h  |  86 ++++
 include/linux/mfd/max77693.h          |   9 +
 9 files changed, 1439 insertions(+), 290 deletions(-)
