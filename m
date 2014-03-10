Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaCJMem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:34:42 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27943 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaCJMej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:34:39 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-f8-531db15c4556
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
Subject: [PATCH 0/3] clk: s2mps11: Add support for S2MPS14 clocks
Date: Mon, 10 Mar 2014 13:34:15 +0100
Message-id: <1394454858-3139-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpiluLIzCtJLcpLzFFi42I5/e/4Vd2YjbLBBhv/iVpsnLGe1eL1C0OL
	s01v2C3ufz3KaLHp8TVWi8u75rBZzDi/j8li7ZG77BZPJ1xkszj5p5fR4nQ3q8XFFV+YLNbP
	eM1i0f53L5vFnOnvmBz4Pe5c28PmMe9koMfmJfUefVtWMXp83iQXwBrFZZOSmpNZllqkb5fA
	lXHv8Be2gvdsFR9+/GZpYJzJ2sXIySEhYCLRsOIRM4QtJnHh3nq2LkYuDiGBpYwSK1c2sEM4
	fUwSJ5qmMIJUsQkYS2xevgSsSkSgmUli39fHTCAOs8BbJok7h26yg1QJCzhKTH2ylQnEZhFQ
	lbi8pxOom4ODV8BNYtW1XBBTQkBBYs4kmwmM3AsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn
	525ihITblx2Mi49ZHWIU4GBU4uE98FYmWIg1say4MvcQowQHs5IIb+Zi2WAh3pTEyqrUovz4
	otKc1OJDjEwcnFINjF1J//cq/+9KWbDsoKz5Pc4W5q/7Ht6RapkR/TpgH2f0xcXqZ1d35JR5
	pWW+rwn54Hf88vnOvTNPfDrBwenD4z7nwiF2C7mPsh4qaxTr1sg0a9f9kt//1sxluZaPI/+0
	/7MKwiQz+OfWMh7u9574ZGaQXstFQxftp6Xf39c6bpX2+3m9c/tvNyWW4oxEQy3mouJEAPM/
	qwIVAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds support for the S2MPS14 device to the s2mps11 clock
driver.

The patchset *depends on*:
1. Work done by Tushar Behera:
   [PATCH V2 0/2] Add support for clocks in S5M8767
   http://thread.gmane.org/gmane.linux.kernel.samsung-soc/27264
2. Support for S2MPS14 in main sec-core MFD driver (already in linux-next
   and Lee's tree).

Best regards,
Krzysztof


Krzysztof Kozlowski (3):
  clk: s2mps11: Add support for S2MPS14 clocks
  mfd: sec-core: Add of_compatible strings for MFD cells
  Documentation: mfd: s2mps11: Describe S5M8767 and S2MPS14 clocks

 Documentation/devicetree/bindings/mfd/s2mps11.txt |   24 +++++---
 drivers/clk/clk-s2mps11.c                         |   61 ++++++++++++++++-----
 drivers/mfd/sec-core.c                            |    3 +
 3 files changed, 64 insertions(+), 24 deletions(-)

-- 
1.7.9.5

