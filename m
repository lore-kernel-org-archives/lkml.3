Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaEIHnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:43:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45721 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaEIHnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:43:16 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-5d-536c8711cc92
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, jkosina@suse.cz,
        labbe.montjoie@gmail.com, a.kesavan@samsung.com,
        sreekumar.c@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 0/5] devfreq: Support resource management functions and code
 clean
Date: Fri, 09 May 2014 16:43:06 +0900
Message-id: <1399621391-27228-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWyRsSkQFewPSfYYPsEY4vHaxYzWVz/8pzV
	YvecxSwWZ5vesFusX7CQzeLyrjlsFp97jzBa3G5cwWbx5sdZJovHK96yWxx8uIDZgdtj56y7
	7B6L97xk8ujbsorR48yCI+wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK+P5lp8sBYu4Kyb9
	+8DSwLiNs4uRk0NCwETi8/31rBC2mMSFe+vZuhi5OIQEljJK3FzTxt7FyAFW9PWDEUR8EaPE
	z75t7BBOE5NE75NbTCDdbAJaEvtf3GADsUUEzCV2Lf0JNolZ4AWjRMfGTcwgCWGBMIkX/1Yz
	gtgsAqoSsy7OBovzCrhKHG6cDHWGnMSHPY/ANkgIrGOXWDtnPxNEg4DEt8mHWCBOkpXYdIAZ
	ol5S4uCKGywTGAUXMDKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAgM9dP/nvXuYLx9wPoQ
	YzLQuInMUqLJ+cBYySuJNzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2ampBalF8UWlO
	avEhRiYOTqkGRj5BvcUOTi+3WD6ZHqbyx5f3ohAvr6n0M73mG5MTr/N8fzBX+0fUISMWPuvJ
	YTcag80n73xp/eSOWzWzw46rdwJefWeUkF538yz/hVgZnjMhp/Zl2y/480+6d7714fmuJSEH
	Zske7dpyUeth+E4uXRum6LvpZeoGku9mSAg6L3v5dLr+vM3fHJRYijMSDbWYi4oTAW11vuaL	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jAV3B9pxgg+4vWhaP1yxmsrj+5Tmr
	xe45i1kszja9YbdYv2Ahm8XlXXPYLD73HmG0uN24gs3izY+zTBaPV7xltzj4cAGzA7fHzll3
	2T0W73nJ5NG3ZRWjx5kFR9g9jt/YzuTxeZNcAFtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxz
	vKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtCBSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9
	Q4LgeowM0EDCGsaM51t+shQs4q6Y9O8DSwPjNs4uRg4OCQETia8fjLoYOYFMMYkL99azdTFy
	cQgJLGKU+Nm3jR3CaWKS6H1yiwmkik1AS2L/ixtsILaIgLnErqU/wTqYBV4wSnRs3MQMkhAW
	CJN48W81I4jNIqAqMevibLA4r4CrxOHGyawQ6+QkPux5xD6BkXsBI8MqRtHUguSC4qT0XCO9
	4sTc4tK8dL3k/NxNjOBIeia9g3FVg8UhRgEORiUe3hdTsoOFWBPLiitzDzFKcDArifBKpecE
	C/GmJFZWpRblxxeV5qQWH2JMBto+kVlKNDkfGOV5JfGGxiZmRpZG5oYWRsbmpAkrifMebLUO
	FBJITyxJzU5NLUgtgtnCxMEp1cCo3zNzZszHZZ+Z79rtvJiy2WTvtHmp5YoCB75K1Ezbemv9
	3zksb+0vrt/i6V15zTB/2ukcLZWVmr9dghru78y5P1U/RfiadbH9ri3us6JsOya1rG9xOrnC
	7eLvnPuf12R4vEnk+f5vrd/N+bst3xY7vlv6o+l07cUZHawyN3KWJzk4bXgyP89TVYmlOCPR
	UIu5qDgRAPjcw1PoAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fix devfreq_remove_device() to remove duplicate function call
of _remove_devfreq() and add following functions for the resource management
of devfreq device and simpify the control of resource on exynos4_bus/exynos5_bus
driver.
- devm_devfreq_add_device
- devm_devfreq_remove_device
- devm_devfreq_register_opp_notifier
- devm_devfreq_unregister_opp_notifier

Changes from v1:
- Remove empty function (exynos5_init_exit) and propogate the return value
  without additonal local variable if failed to call devm_devfreqw_add_device
  in exynos5_busfreq.c.
- Fix return value from -ENOMEM to -ENOSYS in devm_devfreq_add_device() inline
  function.
- Fix minor coding style of devm_devfreq_dev_match()

Chanwoo Choi (5):
  devfreq: Fix devfreq_remove_device() to improve the sequence of resource free
  devfreq: Add resource-managed function for devfreq device
  devfreq: Add devm_devfreq_{register,unregister}_opp_notfier function
  devfreq: exynos4: Use devm_devfreq_* function using device resource management
  devfreq: exynos5: Use devm_devfreq_* function using device resource management

 drivers/devfreq/devfreq.c            | 125 ++++++++++++++++++++++++++++++++---
 drivers/devfreq/exynos/exynos4_bus.c |  19 ++----
 drivers/devfreq/exynos/exynos5_bus.c |  29 +++-----
 include/linux/devfreq.h              |  35 +++++++++-
 4 files changed, 161 insertions(+), 47 deletions(-)

-- 
1.8.0

