Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbbAZQXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:23:14 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:38754 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbbAZQXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:23:12 -0500
From: mathieu.poirier@linaro.org
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] coresight: next
Date: Mon, 26 Jan 2015 09:22:16 -0700
Message-Id: <1422289345-2084-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Good day,

These are the latest additions to the coresight sub-system.  Please
consider for inclusion.

Thanks,
Mathieu

Kaixu Xia (7):
  coresight: fix the replicator subtype value
  coresight: remove the unnecessary replicator property
  coresight: fix the link between orphan connection and newly added
    device
  coresight: remove the extra spaces
  coresight: fix the debug AMBA bus name
  coresight: remove the unnecessary function coresight_is_bit_set()
  coresight: fix function etm_writel_cp14() parameter order

Mathieu Poirier (1):
  coresight: fixing CPU hwid lookup in device tree

Paul Bolle (1):
  coresight-etm: remove check for unknown Kconfig macro

 Documentation/devicetree/bindings/arm/coresight.txt |  4 ----
 Documentation/trace/coresight.txt                   |  4 ++--
 drivers/coresight/coresight-etb10.c                 |  2 +-
 drivers/coresight/coresight-etm3x.c                 |  8 +-------
 drivers/coresight/coresight-priv.h                  |  2 +-
 drivers/coresight/coresight-replicator.c            |  2 +-
 drivers/coresight/coresight.c                       | 11 ++++++-----
 drivers/coresight/of_coresight.c                    | 16 +++++++++-------
 include/linux/coresight.h                           |  3 ---
 9 files changed, 21 insertions(+), 31 deletions(-)

-- 
1.9.1


