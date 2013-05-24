Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128Ab3EXKAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 06:00:17 -0400
Received: from mail-wi0-f196.google.com ([209.85.212.196]:34471 "EHLO
	mail-wi0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab3EXKAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 06:00:15 -0400
From: Alexandre Torgue <alexandre.torgue.st@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH 0/2]  ab8540 cut2: new rtc second resolution 
Date: Fri, 24 May 2013 11:59:46 +0200
Message-Id: <1369389588-27568-1-git-send-email-alexandre.torgue.st@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@st.com>

Android expects the RTC to have second resolution.
On ab8540 cut2 RTC block has a new register which
allows setting seconds for wakeup alarms.

Alexandre Torgue (2):
  mfd: ab8540: add device for new rtc version on ab8540 cut2
  rtc: ab8540: add second resolution to rtc driver

 drivers/mfd/ab8500-core.c         | 55 +++++++++++++++++++++++++++++-----
 drivers/rtc/rtc-ab8500.c          | 63 ++++++++++++++++++++++++++++++++++++++-
 include/linux/mfd/abx500/ab8500.h |  2 ++
 3 files changed, 111 insertions(+), 9 deletions(-)

-- 
1.8.2.1

