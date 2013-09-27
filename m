Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab3I0B2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 21:28:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26417 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3I0B2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 21:28:20 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-e5-5244df32dd93
Message-id: <5244DF34.9090909@samsung.com>
Date: Fri, 27 Sep 2013 10:28:20 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [GIT PULL] extcon next for 3.13
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWyRsSkSNfovkuQwYk94hbXvzxntWhevJ7N
	4mzTG3aLy7vmsFncblzB5sDqsX/uGnaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyphzYTZT
	wVPZiq0nV7A1MK4S72Lk5JAQMJE4vmUfE4QtJnHh3nq2LkYuDiGBpYwSb1fvZoQp2n7+EBNE
	YjqjxJRTx9ghnFeMEtMvngFr5xXQktj9aiIbiM0ioCrx8812FhCbDSi+/8UNsLioQJjEyulX
	WCDqBSV+TL4HZosIaEi8PHoLzGYWWMsoced5AogtDBRfcucpI0RcR2J/6zQ2CFteYvOat8wg
	R0gI9LNLfH+9nxlisYDEt8mHgAZxACVkJTYdYIb4QFLi4IobLBMYRWYhWT0LydhZSMYuYGRe
	xSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iREYIaf/PevfwXj3gPUhxmSglROZpUST84ERllcS
	b2hsZmRhamJqbGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxpPSZTy6
	C6bXeX99u+UTr8Rvr6MTLrHdVVJX+yTy5WHdlS3L3+3fJXH285KLX4Ov3Hk1tYBf7bvU55pZ
	MdeCpt3YEbjLRuPx6lmHTzja3sxaEao9halaLDL5rw1b2KclLuz1G6ImnS8MfXxs98VrD9Zv
	lnvM7PVn1uW7MnnPp7kxv7pm6P//iH2qEktxRqKhFnNRcSIAYEZUTaYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t9jQV2j+y5BBs9e8ltc//Kc1aJ58Xo2
	i7NNb9gtLu+aw2Zxu3EFmwOrx/65a9g9+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/d
	Vsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2inkkJZYk4pUCggsbhYSd8O04TQEDdd
	C5jGCF3fkCC4HiMDNJCwhjFjzoXZTAVPZSu2nlzB1sC4SryLkZNDQsBEYvv5Q0wQtpjEhXvr
	2boYuTiEBKYzSkw5dYwdwnnFKDH94hmwKl4BLYndryaygdgsAqoSP99sZwGx2YDi+1/cAIuL
	CoRJrJx+hQWiXlDix+R7YLaIgIbEy6O3wGxmgbWMEneeJ4DYwkDxJXeeMkLEdST2t05jg7Dl
	JTavecs8gZFvFpJRs5CUzUJStoCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcPw9k97B
	uKrB4hCjAAejEg9vRpZLkBBrYllxZe4hRgkOZiUR3vWxQCHelMTKqtSi/Pii0pzU4kOMyUCf
	TmSWEk3OB6aGvJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpg
	FPsyZ8aLsnqh7Cne6ast9NpMF0Qoh3Lvzd0Sb/fw1BTVmIvBIvwK1g2z42exlEft36D/NyJm
	7Vlfr89X/m/5mMScsrHBMr9NeE6IEG9uifidq86NkjaNTx875cZuLX7v90Vzjk2V/rS9n0pr
	v500Urb8LulmJvPdVTOjJSxAd9K0mRddZ/5VYinOSDTUYi4qTgQAerdwxQMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This is extcon-next pull request for 3.13. I add detailed description of this
pull request on below. Please pull extcon with following updates.

Best Regards,
Chanwoo Choi

The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-next-for-3.13

for you to fetch changes up to 42d7d7539a7bcf1d493b989465283c464f4a0525:

  extcon: Simplify extcon_dev_register() prototype by removing unnecessary parameter (2013-09-27 09:37:01 +0900)

----------------------------------------------------------------
Update extcon for 3.13

This patchset modify extcon core to remove unnecessary allocation sequence for
'dev' instance and change extcon_dev_register() interface. extcon-gpio use
gpiolib API to get debounce time and include small fix of extcon core/device
driver.

Detailed description for patchset:
1. Modify extcon core driver
- The extcon-gpio driver use gpio_set_debounce() API provided from gpiolib
if gpio driver for SoC support gpio_set_debounce() function and support 'gpio_
activ_low' filed to check whether gpio active state is 1(high) or 0(low).
- Change field type of 'dev' in structure extcon_dev and remove the sequence
of allocating memory of 'struct dev' on extcon_dev_register() function because
extcon device must need 'struct device.
- Change extcon_dev_register() prototype to simplify it and remove unnecessary
parameter as below:

2. Fix coding style and typo
- extcon core     : Fix indentation coding style and remove unnecessary casting
- extcon-max8997  : Fix checkpatch warning
- extcon-max77693 : Fix checkpatch warning
- extcon-arizona  : Fix typo of comment and modify minor issue
- extcon-palmas   : Use dev_get_platdata()

3. Modify extcon-arizona driver
- Modify minor issue about micbias and comparision statement

----------------------------------------------------------------
Chanwoo Choi (3):
      extcon: Fix indentation coding style to improve readability
      extcon: Change field type of 'dev' in extcon_dev structure
      extcon: Simplify extcon_dev_register() prototype by removing unnecessary parameter

Charles Keepax (3):
      extcon: arizona: Clear trig_sts bits on all paths
      extcon: arizona: Correct typo in headphone detect range transitions
      extcon: arizona: Don't require micbias to be shifted in pdata

Guenter Roeck (3):
      extcon: gpio: Do not unnecessarily initialize variables
      extcon: gpio: Use gpio driver/chip debounce if supported
      extcon: gpio: Add support for active-low presence to detect pins

Jingoo Han (2):
      extcon: Remove casting the return value which is a void pointer
      extcon: use dev_get_platdata()

Sachin Kamat (3):
      extcon: max8997: Fix checkpatch warning
      extcon: arizona: Fix a typo in a comment
      extcon: max77693: Fix checkpatch warning

 Documentation/extcon/porting-android-switch-class |  6 +-
 drivers/extcon/extcon-adc-jack.c                  | 27 +++----
 drivers/extcon/extcon-arizona.c                   | 20 ++---
 drivers/extcon/extcon-class.c                     | 95 +++++++++++------------
 drivers/extcon/extcon-gpio.c                      | 19 ++++-
 drivers/extcon/extcon-max77693.c                  |  7 +-
 drivers/extcon/extcon-max8997.c                   |  5 +-
 drivers/extcon/extcon-palmas.c                    |  5 +-
 include/linux/extcon.h                            | 72 ++++++++---------
 include/linux/extcon/extcon-adc-jack.h            | 42 +++++-----
 include/linux/extcon/extcon-gpio.h                | 20 +++--
 11 files changed, 170 insertions(+), 148 deletions(-)
