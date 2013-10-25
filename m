Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3JYLUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:20:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54537 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751466Ab3JYLUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:20:05 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: daniel.lezcano@linaro.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sboyd@codeaurora.org, Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/2] More Allwinner SoC timer fixes
Date: Fri, 25 Oct 2013 12:16:09 +0100
Message-Id: <1382699771-4396-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are more fixes to the sun4i timer that we spotted during the review of the
High Speed timers patches, and that we hunted down during the Kernel Summit.

Since they are not critical fixes for the current code we have, it doesn't have
to be merged in 3.12 and can wait.

Thanks!
Maxime

Maxime Ripard (2):
  clockevent: sun4i: Fill the irq field in the clockevent structure
  clocksource: sun4i: change CPU mask to cpu_possible_mask

 drivers/clocksource/sun4i_timer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.8.4

