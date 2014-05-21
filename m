Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaEULXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:23:30 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62658 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaEULXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:23:19 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-cb-537c8c9ffdba
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 0/3] clk: s2mps11: Fixes and add support for S2MPS14 clocks
Date: Wed, 21 May 2014 13:22:58 +0200
Message-id: <1400671381-14792-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJMWRmVeSWpSXmKPExsVy+t/xa7rze2qCDb7817TYOGM9q8XrF4YW
	Z5vesFvc/3qU0eLyrjlsFjPO72OyWHvkLrvF0wkX2SzWz3jN4sDpcefaHjaPvi2rGD0+b5IL
	YI7isklJzcksSy3St0vgyjjxIK9gN3fFxlv72RoYl3B2MXJySAiYSBzZeZ0NwhaTuHBvPZDN
	xSEksJRRYsXHJywQTh+TxMG/r9lBqtgEjCU2L18C1iEikCsxv3EVWAezQDeTxOWOXUwgCWEB
	P4mH34+ANbAIqEosO3+WFcTmFXCXuLFxKjPEOjmJk8cms05g5F7AyLCKUTS1NLmgOCk910iv
	ODG3uDQvXS85P3cTIyRIvu5gXHrM6hCjAAejEg9vxvXqYCHWxLLiytxDjBIczEoivMcqaoKF
	eFMSK6tSi/Lji0pzUosPMTJxcEo1MJ6p3fK46Lv6Jq1T3Ds/Xzr9otL+YtDN4n+PW8RunVy1
	f7f666jn7v5zNfX+bH0zqXhldtyp4xu++XALy138nHV5mnKt8pHQz0H8Ly7P7vndflzN4/1i
	0Rw7W85bz/SFPpTpWs3OP23u7fSph084UGTaSy83jcsq1mamIt6yOWkzNL6FsLj8vqXEUpyR
	aKjFXFScCAAR/Ws28AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is actually a resend of previous patches, rebased on latest
3.15-rc5. There are no changes, beside rebasing.

The first two fixes were posted previously as separate patches and they
didn't get review [1]. I am attaching them here.
The last patch adds support for S2MPS14 device and already was
reviewed/acked [2].

Mike, could you pick them up or should they go through MFD tree?


[1] https://lkml.org/lkml/2014/4/7/42
[2] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/28039/focus=310279


Changes since v3:
=================
1. Add Mike's acked-by (see [2]).
2. Rebase patch 3/3 on the fixes (patches 1 and 2).
3. Rebase on v3.15-rc5-157-g60b5f90d0fac

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


Krzysztof Kozlowski (3):
  clk: s2mps11: Add missing of_node_put and of_clk_del_provider
  clk: s2mps11: Remove useless check for clk_table
  clk: s2mps11: Add support for S2MPS14 clocks

 drivers/clk/Kconfig       |  8 ++---
 drivers/clk/clk-s2mps11.c | 88 +++++++++++++++++++++++++++++++++--------------
 2 files changed, 66 insertions(+), 30 deletions(-)

-- 
1.9.1

