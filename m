Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaFBFJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 01:09:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62403 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaFBFJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 01:09:25 -0400
X-AuditID: cbfee68f-b7fef6d000003970-56-538c06fc53c0
Message-id: <538C06FC.4000009@samsung.com>
Date: Mon, 02 Jun 2014 14:09:16 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [GIT PULL] extcon next-v2 for v3.16
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42JZI2JSovuHrSfY4OMOM4vmxevZLM42vWG3
	uLxrDpvF7cYVbA4sHvvnrmH36NuyitHj8ya5AOYoLpuU1JzMstQifbsEroyGv3YFF6Uqllxb
	z9zAeFO0i5GTQ0LAROLq5X+sELaYxIV769lAbCGBpYwSHUsSuxg5wGounWDvYuQCCk9nlNj/
	9jcjhPOaUeLVpCOMIA28AloS6yZeYAKxWQRUJeZNWAcWZwOK739xA2yoqECYxMrpV1gg6gUl
	fky+B2aLCGhIvDx6iwVkKLNAO6PEyYMrwBLCAjoS70/tAbOZgez9rdPYIGx5ic1r3jKDNEgI
	9LNLtC77yQyxWUDi2+RDLBBny0psOsAM8ZmkxMEVN1gmMIrMQrJ7FpKxs5CMXcDIvIpRNLUg
	uaA4Kb3IWK84Mbe4NC9dLzk/dxMjMCZO/3vWv4Px7gHrQ4zJQCsnMkuJJucDYyqvJN7Q2MzI
	wtTE1NjI3NKMNGElcd77D5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAam3TdnbUqsFzL
	zs3M0OW+jNhWw+BjGUKdhzT4Eot21cx0CVLfMn87n6NQtED75sc5G96KpFhLFyY+3y4lyCZ8
	XH7Dr80FR+dpLJ7j6ZYnpSa++VTphfgvvPm/Tlyd9TAkcPpKPjHJswUlOecOO7CdrXzosGf7
	ubaWm1H1Sk0TD5+a/s/h6UklluKMREMt5qLiRAB5FEnznwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jQd0/bD3BBv1r9S2aF69nszjb9Ibd
	4vKuOWwWtxtXsDmweOyfu4bdo2/LKkaPz5vkApijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DWKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1
	DQmC6zEyQAMJaxgzGv7aFVyUqlhybT1zA+NN0S5GDg4JAROJSyfYuxg5gUwxiQv31rN1MXJx
	CAlMZ5TY//Y3I4TzmlHi1aQjjCBVvAJaEusmXmACsVkEVCXmTVgHFmcDiu9/cYMNxBYVCJNY
	Of0KC0S9oMSPyffAbBEBDYmXR2+xgAxlFmhnlDh5cAVYQlhAR+L9qT1gNjOQvb91GhuELS+x
	ec1b5gmMfLOQzJqFpGwWkrIFjMyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJj7pn0DsZV
	DRaHGAU4GJV4eC/0dgULsSaWFVfmHmKU4GBWEuE9erY7WIg3JbGyKrUoP76oNCe1+BBjMtCr
	E5mlRJPzgekgryTe0NjEzMjSyNzQwsjYnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoY
	RdfHzuhpfqRnZfAx99yf9UczxbJ094stfZL8y3gTd5jY8wWX2+7rMu8s/idzZqFAVITs/tmm
	F6vafk9dGpy89vmeE8rcjo5iM/pmXBSI+br95EWHmS+aAr/2s8x6++9AlJdTakn9l6sLSxd1
	vRDXbtgrWqXc23CEpUL4qGXCiYdxS67orvutrMRSnJFoqMVcVJwIAJwR3on9AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg,

This is extcon-next-v2 full request for v3.16. This pull request includes
additional patchset after merged previous extcon-next pull request(tags/extcon-next-for-v3.16).
I add detailed description of this pull request on below. Please pull extcon with following update.

Best Regards,
Chanwoo Choi

The following changes since commit 3f79a3fb5f41e8f2229e5bf8aa725eaa79686f14:

  extcon: palmas: Use devm_extcon_dev_allocate for extcon_dev (2014-04-29 09:52:12 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-next-v2-for-3.16

for you to fetch changes up to 19c27d2fe7773f07ed53126f04ff9d7d62f64672:

  extcon: sm5502: Change internal hardware switch according to cable type (2014-06-02 09:28:34 +0900)

----------------------------------------------------------------
Update extcon for v3.16

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

3. Fix minor issue of extcon core
- Re-order the sequence of extcon device driver in Kconfig/Makefile alphabitically
- Set parent device of extcon device automatically using devm_extcon_dev_allocate()

----------------------------------------------------------------
Chanwoo Choi (5):
      extcon: Reorder the sequence of extcon device driver alphabetically
      extcon: Set parent device of extcon device using prameter of devm_extcon_dev_allocate
      extcon: sm5502: Add support new SM5502 extcon device driver
      extcon: sm5502: Detect cable state after completing platform booting
      extcon: sm5502: Change internal hardware switch according to cable type

Charles Keepax (3):
      extcon: arizona: Remove duplicate set of input parent device
      extcon: arizona: Correct typo to disable regulation for button detection
      extcon: arizona: Update manual headphone detection calculation

Krzysztof Kozlowski (1):
      extcon: palmas: Make of_device_id array const

Nikesh Oswal (1):
      extcon: arizona: Use extcon cable API with index of extcon cable instead of string

Richard Fitzgerald (1):
      extcon: arizona: support inverted jack detect switch

 drivers/extcon/Kconfig            |  35 +-
 drivers/extcon/Makefile           |   7 +-
 drivers/extcon/extcon-adc-jack.c  |   1 -
 drivers/extcon/extcon-arizona.c   |  68 ++--
 drivers/extcon/extcon-class.c     |   2 +
 drivers/extcon/extcon-gpio.c      |   1 -
 drivers/extcon/extcon-max77693.c  |   1 -
 drivers/extcon/extcon-max8997.c   |   1 -
 drivers/extcon/extcon-palmas.c    |   3 +-
 drivers/extcon/extcon-sm5502.c    | 726 ++++++++++++++++++++++++++++++++++++++
 include/linux/extcon/sm5502.h     | 287 +++++++++++++++
 include/linux/mfd/arizona/pdata.h |   3 +
 12 files changed, 1087 insertions(+), 48 deletions(-)
 create mode 100644 drivers/extcon/extcon-sm5502.c
 create mode 100644 include/linux/extcon/sm5502.h
