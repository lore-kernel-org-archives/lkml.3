Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaAXNiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:38:19 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41251 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaAXNiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:38:17 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-d1-52e26cc76ae5
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 0/2] regulator: s5m8767: Use GPIO for controlling Buck9/eMMC
Date: Fri, 24 Jan 2014 14:37:56 +0100
Message-id: <1390570678-30686-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHJMWRmVeSWpSXmKPExsVy+t/xK7rHcx4FGVxt5rWY+vAJm8X8I+dY
	LV6/MLS4//Uoo8W3Kx1MFpd3zWGzmHF+H5PFyT+9jBanu1ktLq74wuTA5bFz1l12j02rOtk8
	7lzbw+Yx72SgR9+WVYwenzfJBbBFcdmkpOZklqUW6dslcGWcvdDDWvCQvWJawxXmBsYXrF2M
	nBwSAiYS9/beYYKwxSQu3FvPBmILCSxllLi4Rr2LkQvI7mOS+HrtPViCTcBYYvPyJWwgCRGB
	g0wSR7/3gCWYBQwlfr77ww5iCwv4S2z58BVsA4uAqsTVeffAbF4Bd4mO06+Zuxg5gLYpSMyZ
	ZDOBkXsBI8MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJAw+rKDcfExq0OMAhyMSjy8MwIf
	BgmxJpYVV+YeYpTgYFYS4d0a8ChIiDclsbIqtSg/vqg0J7X4ECMTB6dUA6NSjfp+u9V3Wz6W
	/VFZGH+n9fDOgxmVrxcdZdfbFHRkw/Y9Ymxhruses0mYVy/TfTd37fpPD1X3mEfs2T19vaDu
	VufDN2budMvvObvMoMn56+N5cX4v1N7/7Vz9eNNz5mWe0iUt54xW70y5sj73hCX38ebvh5oW
	Tl1961apz+JmbuZ/HMYL7rybocRSnJFoqMVcVJwIAGzij4gBAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is third version of patch adding GPIO control over Buck9 regulator
in s5m8767 regulator driver.

Previously the patch was part of larger patchset from which all other patches
were applied.


Changes since v2:
1. Use only one DT property ("s5m8767,pmic-ext-control-gpios");
   suggested by Mark Brown.

Changes since v1:
1. Use ena_gpio of regulator core, as suggested by Mark Brown.


This patchset is based on next tree: next-20140122.

Best regards,
Krzysztof

Krzysztof Kozlowski (2):
  regulator: s5m8767: Use GPIO for controlling Buck9/eMMC
  regulator: s5m8767: Document new binding for Buck9 GPIO control

 .../bindings/regulator/s5m8767-regulator.txt       |   13 ++-
 drivers/regulator/s5m8767.c                        |   87 +++++++++++++++++++-
 include/linux/mfd/samsung/core.h                   |    3 +-
 include/linux/mfd/samsung/s5m8767.h                |    7 ++
 4 files changed, 105 insertions(+), 5 deletions(-)

-- 
1.7.9.5

