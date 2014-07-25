Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935234AbaGYAk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 20:40:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53570 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934873AbaGYAk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 20:40:56 -0400
X-AuditID: cbfee690-b7fb56d000003439-f7-53d1a796819b
Message-id: <53D1A796.8030607@samsung.com>
Date: Fri, 25 Jul 2014 09:40:54 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        =?UTF-8?B?7J6E6re87Iud?= <geunsik.lim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [GIT PULL] extcon next for v3.17
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsWyRsSkSHfa8ovBBueuWFtc//Kc1eLPhFY2
	i+bF69kszja9Ybe4vGsOm8XtxhVsDmwe++euYffo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSu
	jO4pDSwFhzQqbuw/x9rAeE2ui5GDQ0LAROLBJMEuRk4gU0ziwr31bF2MXBxCAksZJXrn/GaD
	SJhI3Pj0gB0isYhRouvENqiq14wSjUtvM4JU8QpoSRxd9xWsg0VAVWLfuq0sIDYbUHz/ixtg
	cVGBMImV06+wQNQLSvyYfA/MFhHQkHh59BYLyFBmgceMEgf7f7ODnCcsoCnR9EMHpIZZQF1i
	0rxFzBC2vMTmNW+ZQeolBOaxS5w6t5wJYrGAxLfJh1ggXpOV2HSAGeIDSYmDK26wTGAUmYVk
	9SwkY2chGbuAkXkVo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRmCknP73bMIOxnsHrA8xJgOt
	nMgsJZqcD4y0vJJ4Q2MzIwtTE1NjI3NLM9KElcR51R4lBQkJpCeWpGanphakFsUXleakFh9i
	ZOLglGpgzK+VW39oivfFmDK/iureHc8lvksEvF6vvfPe9Na5a6+bfjrIfejsno58JSa5VdbL
	5A/FBD/+KT+76phUmfnUwhfJH8USeJrSNzQfb/m7fuV9J0bWuv2WswrXy6xPFj7kfTN+4Qbf
	rdcaVyucenaY5a1W+ZSDga98CzZo5Psd7p6z5sN/m/azrUosxRmJhlrMRcWJAM3bnNqqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t9jAd1pyy8GG0z6ZWxx/ctzVos/E1rZ
	LJoXr2ezONv0ht3i8q45bBa3G1ewObB57J+7ht2jb8sqRo/Pm+QCmKMaGG0yUhNTUosUUvOS
	81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgBYrKZQl5pQChQISi4uV9O0w
	TQgNcdO1gGmM0PUNCYLrMTJAAwlrGDO6pzSwFBzSqLix/xxrA+M1uS5GTg4JAROJG58esEPY
	YhIX7q1n62Lk4hASWMQo0XViG5TzmlGiceltRpAqXgEtiaPrvrKB2CwCqhL71m1lAbHZgOL7
	X9wAi4sKhEmsnH6FBaJeUOLH5HtgtoiAhsTLo7dYQIYyCzxmlDjY/xtoNQeHsICmRNMPHZAa
	ZgF1iUnzFjFD2PISm9e8ZZ7AyDcLyahZSMpmISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10v
	OT93EyM4Ep9J72Bc1WBxiFGAg1GJh7ej/mKwEGtiWXFl7iFGCQ5mJRFet7lAId6UxMqq1KL8
	+KLSnNTiQ4ymQJ9OZJYSTc4HJom8knhDYxMzI0sjc0MLI2NzJXHeg63WgUIC6YklqdmpqQWp
	RTB9TBycUg2MjR8kN645/6TO4cLS7MDfrtuc7mya0Oe2vM6l68MH1T8vOL6Lnn8+vVPW69aO
	eZ0cpldff11Ybqr8UO+in1Z/2aUN+ztr6tMS0rxsDnPPyzhh+prLUfOflahMf0RO5AYFk3TJ
	KJVtFYI5dd7ZwR/kp0/cPGXzlJreBTq8JzwWft6ZrbL31LdIJZbijERDLeai4kQAMk6ZfNoC	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg,

This is extcon-next full request for v3.17. I add detailed description of this
pull request on below. Please pull extcon with following updates.

I report you about merge of MAX77693 patchset from MFD git repo(Lee Jones).
The MAX77693 patchset in this pull request has the dependency on various
subsystem(MFD/Regulator/Extcon). To protect merge conflit, firstly MFD Maintainer
created Immutable branch(branch: ib-mfd-extcon-regulator) and then I merged it on
extcon-next branch.

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-next-for-3.17

for you to fetch changes up to d3b503140e15d302bc55cf5a90226f0f85860bc2:

  dt-bindings: extcon: Add support for SM5502 MUIC device (2014-07-23 10:22:36 +0900)

----------------------------------------------------------------
Update extcon for v3.17

This patchset add new extcon provider driver and fix minor issue of extcon driver.

Detailed description for patchset:
1. Add new Silicon-Mitus SM5502 MUIC (Micro-USB Interface Controller) device
- extcon-sm5502 driver  is capable of identifying the type of the external power
source and attached accessory. And external power sources, such as Dedicated
charger or a standard USB port, are able to charge the battery in the smart
phone via the connector.

2. Fix minor issue of extcon driver
- extcon-arizona driver
- extcon-palmas driver
- Remove unnecessary OOM messages for all extcon device drivers

3. Fix minor issue of extcon core
- Re-order the sequence of extcon device driver in Kconfig/Makefile alphabitically
- Set parent device of extcon device automatically using devm_extcon_dev_allocate()

4. Fix MAX77693 driver
- This patchset has dependency on MFD/Regulator/Extcon. So, Lee Jones
(MFD Maintainer) created Immutable branch between MFD and Extcon due
for v3.17 merge-window and then I merged this patchset from MFD git repo[1]
to Extcon git repo.
  [1] git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd
  (branch: ib-mfd-extcon-regulator)

----------------------------------------------------------------
Chanwoo Choi (7):
      extcon: Reorder the sequence of extcon device driver alphabetically
      extcon: Set parent device of extcon device using prameter of devm_extcon_dev_allocate
      Merge tag 'mfd-extcon-regulator-v3.17' of git://git.kernel.org/.../lee/mfd into extcon-next
      extcon: sm5502: Add support new SM5502 extcon device driver
      extcon: sm5502: Detect cable state after completing platform booting
      extcon: sm5502: Change internal hardware switch according to cable type
      dt-bindings: extcon: Add support for SM5502 MUIC device

Charles Keepax (4):
      extcon: arizona: Remove duplicate set of input parent device
      extcon: arizona: Correct typo to disable regulation for button detection
      extcon: arizona: Update manual headphone detection calculation
      extcon: arizona: Get MICVDD against extcon device

Jingoo Han (1):
      extcon: Remove unnecessary OOM messages

Krzysztof Kozlowski (1):
      extcon: palmas: Make of_device_id array const

Nikesh Oswal (1):
      extcon: arizona: Use extcon cable API with index of extcon cable instead of string

Richard Fitzgerald (1):
      extcon: arizona: support inverted jack detect switch

Robert Baldyga (2):
      mfd: max77693: Remove unnecessary wrapper functions
      mfd: max77693: Handle IRQs using regmap

 .../devicetree/bindings/extcon/extcon-sm5502.txt   |  23 +
 drivers/extcon/Kconfig                             |  38 +-
 drivers/extcon/Makefile                            |   7 +-
 drivers/extcon/extcon-adc-jack.c                   |   1 -
 drivers/extcon/extcon-arizona.c                    |  74 ++-
 drivers/extcon/extcon-class.c                      |   2 +
 drivers/extcon/extcon-gpio.c                       |   1 -
 drivers/extcon/extcon-max14577.c                   |   5 +-
 drivers/extcon/extcon-max77693.c                   |  41 +-
 drivers/extcon/extcon-max8997.c                    |   5 +-
 drivers/extcon/extcon-palmas.c                     |   3 +-
 drivers/extcon/extcon-sm5502.c                     | 724 +++++++++++++++++++++
 drivers/mfd/Kconfig                                |   1 +
 drivers/mfd/Makefile                               |   2 +-
 drivers/mfd/max77693-irq.c                         | 336 ----------
 drivers/mfd/max77693.c                             | 210 ++++--
 drivers/regulator/max77693.c                       |  12 +-
 include/linux/extcon/sm5502.h                      | 287 ++++++++
 include/linux/mfd/arizona/pdata.h                  |   3 +
 include/linux/mfd/max77693-private.h               |  54 +-
 20 files changed, 1335 insertions(+), 494 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-sm5502.txt
 create mode 100644 drivers/extcon/extcon-sm5502.c
 delete mode 100644 drivers/mfd/max77693-irq.c
 create mode 100644 include/linux/extcon/sm5502.h
