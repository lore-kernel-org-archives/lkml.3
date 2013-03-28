Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab3C1U7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 16:59:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65006 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3C1U7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 16:59:49 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, rajagopal.venkat@linaro.org,
        davidb@codeaurora.org, ulf.hansson@linaro.org,
        laurent.pinchart@ideasonboard.com, tglx@linutronix.de,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v6 0/2] reentrancy in the common clk framework
Date: Thu, 28 Mar 2013 13:59:00 -0700
Message-Id: <1364504343-12635-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364445958-2999-1-git-send-email-mturquette@linaro.org>
References: <1364445958-2999-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This sixth version of the series fixes up two minor cosmetic issues and
adds reviewed-by's and tested-by's.  If there are no more comments to
this version then I'll merge these patches into clk-next so that it can
get some cycles in linux-next.

Changes tested on top of the latest clk-next branch with an OMAP4430
Panda board.

Mike Turquette (2):
  clk: abstract locking out into helper functions
  clk: allow reentrant calls into the clk framework

 drivers/clk/clk.c |  139 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 101 insertions(+), 38 deletions(-)

-- 
1.7.10.4

