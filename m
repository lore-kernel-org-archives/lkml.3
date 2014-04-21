Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaDUJgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:36:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60998 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaDUJg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:36:26 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-08-5354e695d4ff
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, gg@slimlogic.co.uk, kishon@ti.com, balbi@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        sangjung.woo@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/9] extcon: Support devm_extcon_dev_allocate/free()
Date: Mon, 21 Apr 2014 18:36:17 +0900
Message-id: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWyRsSkQHfqs5Bgg2e3LS0O3q+3mPrwCZvF
	vyk32C2uf3nOatG/xcXi9QtDiwtPe9gszja9Ybe4vGsOm8XtxhVsFgv2lDhwe2xa1cnm8XLi
	bzaPvi2rGD2mTvnL6HH8xnYmj8+b5ALYorhsUlJzMstSi/TtErgyOuZ3sxac5qpo3LWEtYHx
	AUcXIyeHhICJxIL7L9ghbDGJC/fWs3UxcnEICSxllOg6184GU/RizykWiMQiRokVk34wQjhN
	TBLPV/1kBaliE9CS2P/iBliHiICCxObeZ6wgRcwCDUwScz4tYAJJCAu4SDx/sgCsiEVAVeLh
	ks8sIDavgKvEvO8boO6Qk/iw5xE7SLOEwCJ2if7u8+wQDQIS3yYfAmrgAErISmw6wAxRLylx
	cMUNlgmMggsYGVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBAb56X/PJuxgvHfA+hBjMtC4
	icxSosn5wCjJK4k3NDYzsjA1MTU2Mrc0I01YSZxX7VFSkJBAemJJanZqakFqUXxRaU5q8SFG
	Jg5OqQbGBL395r6mMc0q2zk3ST37VTDJbMmuoGVdods/mKUvXZC74GmwsLvjgpUt+yZP8u2c
	yuzHu+Pp77At7l/nXBe8HrhA79zhcGeN2aKab6skJnF8bcs+Os2dce2MNft2zA28Oa1XZca9
	04uvi36Pz59w7OMNgTVrZL1PvExyPNe8m9P1eIfEn/z6VUosxRmJhlrMRcWJAFeEfTmIAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd2pz0KCDQ61GVocvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYLBbsKXHg9ti0qpPN4+XE
	32wefVtWMXpMnfKX0eP4je1MHp83yQWwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaekUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7H
	yAANJKxhzOiY381acJqronHXEtYGxgccXYycHBICJhIv9pxigbDFJC7cW8/WxcjFISSwiFFi
	xaQfjBBOE5PE81U/WUGq2AS0JPa/uMEGYosIKEhs7n3GClLELNDAJDHn0wImkISwgIvE8ycL
	wIpYBFQlHi75DLaCV8BVYt73DewQ6+QkPux5xD6BkXsBI8MqRtHUguSC4qT0XCO94sTc4tK8
	dL3k/NxNjOAYeia9g3FVg8UhRgEORiUe3hf5IcFCrIllxZW5hxglOJiVRHgj1gOFeFMSK6tS
	i/Lji0pzUosPMSYDbZ/ILCWanA+M77ySeENjEzMjSyNzQwsjY3PShJXEeQ+2WgcKCaQnlqRm
	p6YWpBbBbGHi4JRqYCy/m2zAtam3fFXCu1M379ezGk8POFHpdmefXYYAc8rj++0LmlxKWpyE
	Pj9Tucv1+6tyxdrVgufd7U7zL/a7ydof7vY4y/Gl5c226y5TDy7+0/pWz3/bR1Gntp0+zYf/
	/cttduptNG/aFLfM48Ep6dYDDIy8HAvUfF2nzNpz143F9XVrDZPlGSWW4oxEQy3mouJEAOR0
	/VTlAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add devm_extcon_dev_allocate/free() for the resource management
of extcon device. And devm_extcon_dev_allocate() handles all of supported cables.

Chanwoo Choi (9):
  extcon: Add extcon_dev_allocate/free() to control the memory of extcon device
  extcon: Add devm_extcon_dev_allocate/free to manage the resource of extcon device
  extcon: max8997: Use devm_extcon_dev_allocate for extcon_dev
  extcon: max77693: Use devm_extcon_dev_allocate for extcon_dev
  extcon: max14577: Use devm_extcon_dev_allocate for extcon_dev
  extcon: palmas: Use devm_extcon_dev_allocate for extcon_dev
  extcon: arizona: Use devm_extcon_dev_allocate for extcon_dev
  extcon: adc-jack: Use devm_extcon_dev_allocate for extcon_dev
  extcon: gpio: Use devm_extcon_dev_allocate for extcon_dev

 drivers/extcon/extcon-adc-jack.c |  25 +--
 drivers/extcon/extcon-arizona.c  |  35 ++--
 drivers/extcon/extcon-class.c    | 352 ++++++++++++++++++++++++---------------
 drivers/extcon/extcon-gpio.c     |  27 +--
 drivers/extcon/extcon-max14577.c |   5 +-
 drivers/extcon/extcon-max77693.c |   6 +-
 drivers/extcon/extcon-max8997.c  |   5 +-
 drivers/extcon/extcon-palmas.c   |  37 ++--
 include/linux/extcon.h           |  31 ++++
 include/linux/mfd/palmas.h       |   2 +-
 10 files changed, 331 insertions(+), 194 deletions(-)

-- 
1.8.0

