Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaDNHzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:55:38 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46359 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaDNHzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:55:36 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-be-534b9475c19b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 resend] clk: s2mps11: Add support for S2MPS14 clocks
Date: Mon, 14 Apr 2014 09:55:21 +0200
Message-id: <1397462122-24447-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGJMWRmVeSWpSXmKPExsVy+t/xq7qlU7yDDfY161tsnLGe1eL1C0OL
	s01v2C0u75rDZjHj/D4mi7VH7rJbPJ1wkc1i/YzXLA4cHneu7WHz6NuyitHj8ya5AOYoLpuU
	1JzMstQifbsErox373cxFbxjq2i4ldbAeIK1i5GDQ0LARGLCQvsuRk4gU0ziwr31bF2MXBxC
	AksZJZbMvMAM4fQxSfRvXMwEUsUmYCyxefkSNhBbRCBXYn7jKjCbWeA5o8TT7+EgtrCAu0Tj
	8rmsIDaLgKrE3KaPYDW8QPEVfyexQ2xTkFj2ZS3zBEbuBYwMqxhFU0uTC4qT0nMN9YoTc4tL
	89L1kvNzNzFCwuLLDsbFx6wOMQpwMCrx8CZs9wwWYk0sK67MPcQowcGsJMK7LcMrWIg3JbGy
	KrUoP76oNCe1+BAjEwenVAPjFFnmHN3/7/hX5/8r763e6WT2g8lU9tjx+Qk2c2bdlP0lM/XM
	RtG/69av+L3s3jHfkugu66nycx/xCOVWaa1TZxWoTvvYWG1T2v35eQ8b27q5fPn7qx+w/9lX
	/ox508+7PR3RUrtj247z/xE7ud9kxZGX8maxM8/n9cxs/i5Rqbc1UDj7wFtnJZbijERDLeai
	4kQAgm6QrekBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a resend of third version of patchset adding support for
the S2MPS14 device to the s2mps11 clock driver.

Previous discusson can be found here:
http://thread.gmane.org/gmane.linux.kernel.samsung-soc/28039

Changes since v2:
=================
1. Patch 2/3: Remove MFD cells of_compatible which aren't used by child
   drivers and are not documented.
2. Added Tomasz's Review-by.

Changes since v1:
=================
1. Patch 1/3: Update driver description in Kconfig.
2. Patch 2/3: Add of_compatible to all MFD cells.
3. Add Yadwinder's Review-by.

Best regards,
Krzysztof

Krzysztof Kozlowski (1):
  clk: s2mps11: Add support for S2MPS14 clocks

 drivers/clk/Kconfig       |  8 +++----
 drivers/clk/clk-s2mps11.c | 61 +++++++++++++++++++++++++++++++++++------------
 2 files changed, 50 insertions(+), 19 deletions(-)

-- 
1.8.3.2

