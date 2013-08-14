Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078Ab3HNQTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:19:07 -0400
Received: from mx.mmd.net ([80.83.0.3]:57319 "EHLO mx.mmd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760049Ab3HNQRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:17:44 -0400
From: tuukka.tikkanen@linaro.org
To: rjw@sisk.pl, daniel.lezcano@linaro.org, linux-pm@vger.kernel.org
Cc: private-pmwg@linaro.org, linux-kernel@vger.kernel.org,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
Subject: [PATCH 0/8] Cpuidle: Menu governor fixes
Date: Wed, 14 Aug 2013 19:02:33 +0300
Message-Id: <cover.1376487596.git.tuukka.tikkanen@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>

This series of patches fixes some bugs, style issues and wild use of
variable types in cpuidle menu governor. One of the bugs is a logic
flaw where a detected previously recurring pattern is given priority
over known guaranteed earlier wakeup. The others involve value
overflows.

Tuukka Tikkanen (8):
  Cpuidle: Ignore interval prediction result when timer is shorter
  Cpuidle: Rearrange code and comments in get_typical_interval()
  Cpuidle: Check called function parameter in get_typical_interval()
  Cpuidle: CodingStyle: Break up multiple assignments on single line
  Cpuidle: Fix menu_device->intervals type
  Cpuidle: Fix variable domains in get_typical_interval()
  Cpuidle: Add a comment warning about possible overflow
  Cpuidle: Change struct menu_device field types

 drivers/cpuidle/governors/menu.c |   96 ++++++++++++++++++++++++++------------
 1 file changed, 65 insertions(+), 31 deletions(-)

-- 
1.7.9.5

