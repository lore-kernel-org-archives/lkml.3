Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015AbaDYAmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:42:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:8729 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaDYAmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:42:32 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-7e-5359af763eac
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 0/9] extcon: Support devm_extcon_dev_allocate/free()
Date: Fri, 25 Apr 2014 09:42:15 +0900
Message-id: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWyRsSkQLdsfWSwQdtTS4uD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbA5fHplWdbB4vJ/5m8+jb
	sorRY+qUv4wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK2Pth7msBaf5Kz5t3c3WwPidp4uR
	k0NCwESi9cYLVghbTOLCvfVsILaQwFJGiUtzuWFqXky8ydzFyAUUn84o8eblKzYIp4lJovXg
	cbAONgEtif0vboDZIgIKEpt7n7GCFDELPGOUOHH1BDNIQljATeLHn71gNouAqsS05nfsIDav
	gKvEowUdUGfISXzY84gdwp7HLjH1USFEvYDEt8mHWLoYOYDishKbDjBDlEhKHFxxg2UCo+AC
	RoZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIGBffrfs74djDcPWB9iTAYaN5FZSjQ5HxgZ
	eSXxhsZmRhamJqbGRuaWZqQJK4nzLnqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMbU6
	k+nSDtF1O/v7br2t17MRj3v888a/9iC5V34O1fm3TgcUSSiv8Fhx+cve9Sv39zRfObKpy46T
	/ZDDY453Vj2LuzW7/u8OiLVeOSfUzffDoXir7quCnu9q1RR/Gn1XmzN/TUPh4f0PDrqyXomT
	OnVeYb3JwqdXi/ItfUvUN21wfLm8UyH9ixJLcUaioRZzUXEiAI+W0PCCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t9jQd2y9ZHBBvNWGVocvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYHLg8Nq3qZPN4OfE3m0ff
	llWMHlOn/GX0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgz1n6Yy1pwmr/i09bdbA2M33m6GDk5JARMJF5MvMkMYYtJXLi3nq2LkYtDSGA6o8Sbl6+g
	nCYmidaDx9lAqtgEtCT2v7gBZosIKEhs7n3GClLELPCMUeLE1RNgo4QF3CR+/NkLZrMIqEpM
	a37HDmLzCrhKPFrQwQqxTk7iw55H7BMYuRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93E
	CI6dZ1I7GFc2WBxiFOBgVOLh/aAWGSzEmlhWXJl7iFGCg1lJhFd5FVCINyWxsiq1KD++qDQn
	tfgQYzLQ9onMUqLJ+cC4ziuJNzQ2MTOyNDI3tDAyNidNWEmc90CrdaCQQHpiSWp2ampBahHM
	FiYOTqkGxr3fay5O3Hw7iHXj/EkxefseKwgJGd1bwqfw3a+w5Mv2Bxc5J5kd/3rHyCPP+cGf
	0De/A7oUdrIs0NN6Vteg8/ns6omHf4lsqv/BL8Z/2rQsbWZG0OOLV+qNddeZr7yfxbu1/fhn
	D8bQjb26rjZ7OCfxfa2zuPFJk/2D8E3//KzOaQdYOI4qHVdiKc5INNRiLipOBAD7JBKI4QIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add devm_extcon_dev_allocate/free() for the resource management
of extcon device. And devm_extcon_dev_allocate() handles all of supported cables.

Changes from v3:
- Change return value of extcon_dev_allocate()/devm_extcon_dev_allocate()
  if failed to allocate the memory of extcon device (NULL -> ERR_PTR(-ENOMEM))
- All of extcon provier drivers check return value using IS_ERR() macro
- Fix the description of function due to changing return type if failure

Changes from v2:
- Resolve bisectable issue about patch-1
  extcon: Add extcon_dev_allocate/free() to control the memory of extcon device
- extcon_dev_allocate/free() don't handle all behaviors for supported cables

Changes from v1:
- Rebase it on latest extcon-next branch

Chanwoo Choi (9):
  extcon: Add extcon_dev_allocate/free() to control the memory of extcon device
  extcon: Add devm_extcon_dev_allocate/free to manage the resource of extcon device
  extcon: max8997: Use devm_extcon_dev_allocate for extcon_dev
  extcon: max77693: Use devm_extcon_dev_allocate for extcon_dev
  extcon: max14577: Use devm_extcon_dev_allocate for extcon_dev
  extcon: arizona: Use devm_extcon_dev_allocate for extcon_dev
  extcon: adc-jack: Use devm_extcon_dev_allocate for extcon_dev
  extcon: gpio: Use devm_extcon_dev_allocate for extcon_dev
  extcon: palmas: Use devm_extcon_dev_allocate for extcon_dev

 drivers/extcon/extcon-adc-jack.c |  21 ++++----
 drivers/extcon/extcon-arizona.c  |  30 ++++++-----
 drivers/extcon/extcon-class.c    | 108 ++++++++++++++++++++++++++++++++++-----
 drivers/extcon/extcon-gpio.c     |  23 ++++++---
 drivers/extcon/extcon-max14577.c |   7 +--
 drivers/extcon/extcon-max77693.c |   9 ++--
 drivers/extcon/extcon-max8997.c  |   7 ++-
 drivers/extcon/extcon-palmas.c   |  35 +++++++------
 include/linux/extcon.h           |  24 +++++++++
 include/linux/mfd/palmas.h       |   2 +-
 10 files changed, 196 insertions(+), 70 deletions(-)

-- 
1.8.0

