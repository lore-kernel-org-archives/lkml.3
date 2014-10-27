Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaJ0OYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:24:53 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:61479 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaJ0OYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:24:51 -0400
From: Jan Kardell <jan.kardell@telliq.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 0/6] rtc: pcf8563 alarm fixes
Date: Mon, 27 Oct 2014 15:16:55 +0100
Message-Id: <1414419421-11098-1-git-send-email-jan.kardell@telliq.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found some bugs when trying to use the alarm function of the NXP pcf8563 RTC.

Jan Kardell (6):
  rtc: pcf8563 Remove leftover code
  rtc: pcf8563 Fix write of invalid bits to ST2 reg
  rtc: pcf8563 Fix wrong time from read_alarm
  rtc: pcf8563 Handle consequeces of lacking second alarm reg
  rtc: pcf8563 Save battery power
  rtc: pcf8563 Clear expired alarm at boot time

 drivers/rtc/rtc-pcf8563.c | 55 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 46 insertions(+), 9 deletions(-)

-- 
1.8.4.5

