Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaDRAcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:32:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30892 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDRAci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:32:38 -0400
X-AuditID: cbfee690-b7f266d00000287c-95-535072a5d68b
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv3 0/8] Resource-managed extcon device register function
Date: Fri, 18 Apr 2014 09:32:32 +0900
Message-id: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWyRsSkRHdpUUCwweomWYvrX56zWrx+YWhx
	edccNovbjSvYLBbsKbGYMfklmwObR9+WVYwenzfJBTBFcdmkpOZklqUW6dslcGX8u3ebqWA7
	T8WORx/YGxh7uboYOTkkBEwkHp5azQRhi0lcuLeerYuRi0NIYCmjxKQlc1hgig51dbBDJBYx
	Skzu+MEC4bQxSex/dpoZpIpNQFfiyYHLYLaIQLBEx8njTCBFzAJLGCX+nbzFBpIQFnCX6Fv/
	hBXEZhFQlZi6aylYnFfATeLin89AKziA1ilIzJlkA9IrIfCcTeLC119sEPUCEt8mH2KBqJGV
	2HSAGeI6SYmDK26wTGAUXMDIsIpRNLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMjMBhP/3s2YQfj
	vQPWhxiTgcZNZJYSTc4HBnNeSbyhsZmRhamJqbGRuaUZacJK4rxqj5KChATSE0tSs1NTC1KL
	4otKc1KLDzEycXBKNTAufL5s1tVv4X8E5RtmXV8Sxii+y/SRiHLwDDEmbVYBG49TTrmPZvW8
	+quxQtnpkOCni6IyLAWy5kmCcvUHzyd1NvX4vYlpyr2jZ2PddvxgHpeF/onM9jPy15p9vu6S
	zuvLfdn0mbEtR3le1wv5Pt3VCp76Bx9GqGT8Znly+uKB5b7OQRxbdiuxFGckGmoxFxUnAgBY
	5qbWXAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t9jAd2lRQHBBrcPilpc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYx49+920wF23kqdjz6wN7A2MvVxcjJISFgInGoq4MdwhaTuHBvPVsX
	IxeHkMAiRonJHT9YIJw2Jon9z04zg1SxCehKPDlwGcwWEQiW6Dh5nAmkiFlgCaPEv5O32EAS
	wgLuEn3rn7CC2CwCqhJTdy0Fi/MKuElc/PMZaB0H0DoFiTmTbCYwci9gZFjFKJpakFxQnJSe
	a6RXnJhbXJqXrpecn7uJERzqz6R3MK5qsDjEKMDBqMTDe+Grf7AQa2JZcWXuIUYJDmYlEd7z
	aQHBQrwpiZVVqUX58UWlOanFhxiTgZZPZJYSTc4HxmFeSbyhsYmZkaWRuaGFkbE5acJK4rwH
	W60DhQTSE0tSs1NTC1KLYLYwcXBKNTAq72L9nLb6xINlOYKbyqNWLP1gIdF+z+B2VuopbrFV
	jr3Xvz0+qXrsW8Sl/EsPo4zuPX76qtXV8vTMS0udZ2xO0vsT/eiXhkXEFk+nrcukFi2dWh57
	++9Wxyd+l+yFN9zyPfIq5umKZesU3IK3uEeKvNHj+//4OUvF8vCN5lOOOGyZUBj3XHLaFCWW
	4oxEQy3mouJEAKsK0Ee5AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add resource-managed extcon device register functions for
developers' convenience and apply them to related device driver files.
This work can make the code more tidy since extcon device is automatically
unregistered on driver detach so tiresome managing codes could be removed.


Changelog:

v3:
* send the right version instead of previous v1
* add the credit for reviewers according to the review rules

v2:
* modify and clean up all unnecessary code reported by Chanwoo
* fix the bug reported by Seung-Woo
* add the credit for reviewers

v1:
* initial version

Sangjung Woo (8):
  extcon: Add resource-managed extcon register function
  extcon: adc-jack: Use devm_extcon_dev_register()
  extcon: gpio: Use devm_extcon_dev_register()
  extcon: max14577: Use devm_extcon_dev_register()
  extcon: max77693: Use devm_extcon_dev_register()
  extcon: max8997: Use devm_extcon_dev_register()
  extcon: palmas: Use devm_extcon_dev_register()
  extcon: arizona: Use devm_extcon_dev_register()

 drivers/extcon/extcon-adc-jack.c |   30 +++++-----------
 drivers/extcon/extcon-arizona.c  |   12 +++----
 drivers/extcon/extcon-class.c    |   72 ++++++++++++++++++++++++++++++++++++++
 drivers/extcon/extcon-gpio.c     |   16 +++------
 drivers/extcon/extcon-max14577.c |    9 ++---
 drivers/extcon/extcon-max77693.c |    7 ++--
 drivers/extcon/extcon-max8997.c  |    4 +--
 drivers/extcon/extcon-palmas.c   |   15 +++-----
 include/linux/extcon.h           |   17 +++++++++
 9 files changed, 116 insertions(+), 66 deletions(-)

-- 
1.7.9.5

