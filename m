Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab3JNUvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:51:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35316 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758496Ab3JNUuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:50:07 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: daniel.lezcano@linaro.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/3] clocksource: sun4i: Fix a few minor issues
Date: Mon, 14 Oct 2013 21:07:45 +0200
Message-Id: <1381777668-32565-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Here is a few fixes for a few mistakes found during the review of the High
Speed Timers patches, that also applies to the timer code we had previously.

It's mostly a few things here and there, so it can wait for 3.13.

Thanks,
Maxime

Maxime Ripard (3):
  clocksource: sun4i: Select CLKSRC_MMIO
  clocksource: sun4i: Report the minimum tick that we can program
  clocksource: sun4i: remove IRQF_DISABLED

 drivers/clocksource/Kconfig       |  1 +
 drivers/clocksource/sun4i_timer.c | 12 +++++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

-- 
1.8.4

