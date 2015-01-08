Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbbAHJIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:08:15 -0500
Received: from mout.gmx.net ([212.227.17.20]:53302 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058AbbAHJIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:08:10 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: daniel.lezcano@linaro.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH] clocksource driver for Alphascale asm9260
Date: Thu,  8 Jan 2015 10:07:21 +0100
Message-Id: <1420708042-22906-1-git-send-email-linux@rempel-privat.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417193657-31602-2-git-send-email-linux@rempel-privat.de>
References: <1417193657-31602-2-git-send-email-linux@rempel-privat.de>
X-Provags-ID: V03:K0:yg6YY4USp1tjtjbooMeZ8utihJ9a8dRdtFke7sYv6jEuR2oh66Z
 G8VDK0wpidSg2OAUAMAbc1pubMvK2UXPCmNUOA82dRrnpWcaZpxlJCNjdngE7x2f3u67CjD
 46yNwGODK74Bj/fYsAn/6n5GlHfDo2b5d7+kCtMKSRVryXq+cs7LvoIUIAMrAuYm1+Je5s0
 D9O2WqnVSUX3uzCTzHV2w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
this patch provides clocksource support for Alphascale asm9260 SoC.
As was suggested..., I explicitly ask you to merge this patch :D

Oleksij Rempel (1):
  ARM: clocksource: add asm9260_timer driver

 drivers/clocksource/Kconfig         |   9 ++
 drivers/clocksource/Makefile        |   1 +
 drivers/clocksource/asm9260_timer.c | 220 ++++++++++++++++++++++++++++++++++++
 3 files changed, 230 insertions(+)
 create mode 100644 drivers/clocksource/asm9260_timer.c

-- 
1.9.1

