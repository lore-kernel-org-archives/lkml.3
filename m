Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbaAVQIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 11:08:07 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17293 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbaAVQIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 11:08:02 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-bb-52dfecdfbe26
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 0/2] regulator: s5m8767: Use GPIO for controlling Buck9/eMMC
Date: Wed, 22 Jan 2014 17:07:26 +0100
Message-id: <1390406848-20964-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t/xK7r339wPMvj0w9Ki4WqIxdSHT9gs
	5h85x2rR/2Yhq8WBPzsYLc69Wslo8fqFocX9r0cZLb5d6WCyWNi2hMXi8q45bBYzzu9jslh6
	/SKTxYTpa1ks1r2czmLRuvcIu8XJP72MFqe7WS0urvjC5CDssWbeGkaPy329TB47Z91l91i5
	/Aubx6ZVnWwer1bPZPW4c20Pm8e8k4EefVtWMXp83iQXwBXFZZOSmpNZllqkb5fAlXGm9QB7
	wXe2ipUXExsY57B2MXJySAiYSMycvoAdwhaTuHBvPVsXIxeHkMBSRolP296AFQkJ9DFJdJ1I
	B7HZBIwlNi9fAlYkIjCdVaLvzzawbmYBQ4mf7/6A2cIC/hL/Z1xiA7FZBFQlTnf1soDYvALu
	Eg3f3zJ1MXIAbVOQmDPJZgIj9wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIUH8dQfj
	0mNWhxgFOBiVeHgDdt0LEmJNLCuuzD3EKMHBrCTCy/L8fpAQb0piZVVqUX58UWlOavEhRiYO
	TqkGRqMZ3hECBx6evc9RKMrnXFqitL980pIjlgl2kXviNvJWa2WerTuxbsqrztfzHr6v3v9s
	06fO5Sufiyx5eiG8xSatMOTg0luW4vKMyY1d0cs/m83hlNj7dP7HLjfuWd2Pfj6vqpQ8rval
	QfGxvf37e99XP9h56PRbq6krrltVmBy0um2yv+LeSSUlluKMREMt5qLiRAAHfyTAQAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is second version of patch adding GPIO control over Buck9 regulator
in s5m8767 regulator driver.

Previously the patch was part of larger patchset from which all other patches
were applied. Changes since previous revision:
1. Use ena_gpio of regulator core, as suggested by Mark Brown.

This patchset is based on next tree: next-20140122.

Best regards,
Krzysztof

Krzysztof Kozlowski (2):
  regulator: s5m8767: Use GPIO for controlling Buck9/eMMC
  regulator: s5m8767: Document new bindings for Buck9 GPIO control

 .../bindings/regulator/s5m8767-regulator.txt       |   16 +++-
 drivers/regulator/s5m8767.c                        |   97 +++++++++++++++++++-
 include/linux/mfd/samsung/core.h                   |    4 +-
 include/linux/mfd/samsung/s5m8767.h                |    7 ++
 4 files changed, 119 insertions(+), 5 deletions(-)

-- 
1.7.9.5

