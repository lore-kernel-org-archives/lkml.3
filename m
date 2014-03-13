Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaCMJhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:37:32 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43976 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbaCMJh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:37:29 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-6f-53217c571e05
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 0/3] clk: s2mps11: Add support for S2MPS14 clocks
Date: Thu, 13 Mar 2014 10:37:01 +0100
Message-id: <1394703425-6462-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42I5/e/4Fd3wGsVgg3VNchYbZ6xntXj9wtDi
	bNMbdov7X48yWmx6fI3V4vKuOWwWM87vY7JYe+Quu8XTCRfZLE7+6WW0ON3NanFxxRcmi/Uz
	XrNYtP/dy2YxZ/o7Jgd+jzvX9rB5zDsZ6LF5Sb1H35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVw
	ZfTNvMZcMI2zYsbCfpYGxvdsXYycHBICJhKT56yCssUkLtxbD2RzcQgJLGWUWHfvECuE08ck
	0friKStIFZuAscTm5UvAqkQEmpkk9n19zATiMAu8ZZK4c+gmO0iVsICLxL1DD5lBbBYBVYlH
	/Y9ZQGxeATeJh2seAE3iANqnIDFnks0ERu4FjAyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3
	MUIC7ssOxsXHrA4xCnAwKvHwrliuECzEmlhWXJl7iFGCg1lJhNe8QDFYiDclsbIqtSg/vqg0
	J7X4ECMTB6dUA2PsqVStnAVrNnZdmMplcGa7Qs3W8ASZUE3dPXd3xf0+Hn2u5qPiLYUvPd1z
	20pNszbLP1Li+XBti9n6ek33js1SRmzXkk+ujWXKmO71VFZx3V9mAZ2pRokCUm1aE5IlG76o
	SixmMzU8Kj5/oXFo+FfbVKtC14IYhoU5v81m37Ll+9dwLd9kmhJLcUaioRZzUXEiAHfzeccW	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is second version of patchset adding support for the S2MPS14
device to the s2mps11 clock driver.


The patchset *depends on*:
==========================
1. Work done by Tushar Behera:
   [PATCH V2 0/2] Add support for clocks in S5M8767
   http://thread.gmane.org/gmane.linux.kernel.samsung-soc/27264
2. Support for S2MPS14 in main sec-core MFD driver (already in linux-next
   and Lee's tree).

Changes since v1:
=================
1. Patch 1/3: Update driver description in Kconfig.
2. Patch 2/3: Add of_compatible to all MFD cells.
3. Add Yadwinder's Review-by.


Best regards,
Krzysztof


Krzysztof Kozlowski (3):
  clk: s2mps11: Add support for S2MPS14 clocks
  mfd: sec-core: Add of_compatible strings for MFD cells
  Documentation: mfd: s2mps11: Describe S5M8767 and S2MPS14 clocks

 Documentation/devicetree/bindings/mfd/s2mps11.txt |   24 +++++---
 drivers/clk/Kconfig                               |    8 +--
 drivers/clk/clk-s2mps11.c                         |   61 ++++++++++++++++-----
 drivers/mfd/sec-core.c                            |    8 +++
 4 files changed, 73 insertions(+), 28 deletions(-)

-- 
1.7.9.5

