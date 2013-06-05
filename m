Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3FEPHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:07:35 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17936 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab3FEPHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:07:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 05 Jun 2013 08:06:41 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mturquette@linaro.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Fix some uses of clk->rate
Date: Wed, 5 Jun 2013 18:06:34 +0300
Message-ID: <1370444796-18648-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using clk->rate directly does not take the CLK_GET_RATE_NOCACHE flag into
account. This can cause wrong results if the flag is set.

Peter De Schrijver (2):
  clk: use clk_get_rate() for debugfs
  clk: honor CLK_GET_RATE_NOCACHE in clk_set_rate

 drivers/clk/clk.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

-- 
1.7.7.rc0.72.g4b5ea.dirty

