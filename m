Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaDXHs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 03:48:28 -0400
Received: from inet-tsb5.toshiba.co.jp ([202.33.96.24]:42840 "EHLO
	imx2.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbaDXHs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 03:48:27 -0400
From: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
To: tglx@linutronix.de, rdunlap@infradead.org, john.stultz@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        viresh.kumar@linaro.org
Subject: [PATCH] timer_stats: add core information to event counters
Date: Thu, 24 Apr 2014 16:47:46 +0900
Message-Id: <1398325667-27060-1-git-send-email-daniel.sangorrin@toshiba.co.jp>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds information specifying the CPU core where timer 
callbacks (events) were executed to the output of /proc/timer_stats.
I tested the patch on a dual-core x86_64 and another dual-core 
ARM board. This patch may be useful for debugging timer execution
in multi-core environments.

Daniel Sangorrin (1):
  timer_stats: add core information to event counters

 Documentation/timers/timer_stats.txt | 41 ++++++++++++++++++++----------------
 kernel/time/timer_stats.c            | 20 ++++++++++--------
 2 files changed, 34 insertions(+), 27 deletions(-)

-- 
1.8.1.1

