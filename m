Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbaDNIJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:09:33 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:49818 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaDNIJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:09:27 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-ba-534b97b38dc8
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 0/4] regulator: s2mps11: Add external GPIO control for S2MPS14
Date: Mon, 14 Apr 2014 10:09:05 +0200
Message-id: <1397462949-22379-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsVy+t/xK7qbp3sHG/S8VrPYOGM9q8XUh0/Y
	LOYfOcdq0f9mIavFuVcrGS1evzC0ONv0ht3i/tejjBbfrnQwWVzeNYfNYsb5fUwWa4/cZbdY
	ev0ik8WE6WtZLFr3HmG3ON3NanFxxRcmi/UzXrM4CHmsmbeG0eNyXy+Tx85Zd9k9Vi7/wuax
	aVUnm8eda3vYPOadDPTo27KK0ePzJrkAzigum5TUnMyy1CJ9uwSujFXvVrAUvGGv2L9tLUsD
	YxNbFyMnh4SAicSbZ1ugbDGJC/fWA9lcHEICSxklOvZfAksICfQxSax+kA1iswkYS2xevgSs
	SETgBrPExGW7mEASzALPGSWefg8HsYUF/CTeLTvM3MXIwcEioCpx9oUniMkr4C6x7IA/xC4F
	iWVf1jJPYORewMiwilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMkZL/sYFx8zOoQowAHoxIP
	b8J2z2Ah1sSy4srcQ4wSHMxKIrzbMryChXhTEiurUovy44tKc1KLDzEycXBKNTBOE32iNm1l
	77LXu/7eYwrfndTMpV9x+ZKc9pUFAs5nujcVMVfKlrlqqUwo7Z4QMbt475zeP792HrQ3ncjJ
	sPunQ0Rii9ns3ZF/N/csq3xx5ry35sTKf7btFbF9JRJdJQs5f/A1uh85ucPy/L3dXy6fa3p+
	jSOv+lbW8ZoPOY1nCje9e/D6oMg9JZbijERDLeai4kQADS4ldDcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds external GPIO control to s2mps11 regulator driver
for some of the S2MPS14 regulators.

Additionally (patch 4/4) it changes the bindings in s5m8767 regulator driver
for external control to match these used here:
	"samsung,ext-control-gpios"

Best regards,
Krzysztof

Krzysztof Kozlowski (4):
  regulator: s2mps11: Move DTS parsing code to separate function
  regulator: s2mps11: Add external GPIO control for S2MPS14
  Documentation: regulator: s2mps11: Document external GPIO control
  regulator: s5m8767: Use same binding for external control as in
    s2mps11

 Documentation/devicetree/bindings/mfd/s2mps11.txt  | 14 ++++
 .../bindings/regulator/s5m8767-regulator.txt       |  4 +-
 drivers/regulator/s2mps11.c                        | 98 +++++++++++++++++++---
 drivers/regulator/s5m8767.c                        |  2 +-
 include/linux/mfd/samsung/s2mps14.h                |  2 +
 5 files changed, 105 insertions(+), 15 deletions(-)

-- 
1.8.3.2

