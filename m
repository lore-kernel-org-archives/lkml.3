Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbaAVLqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:46:18 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33996 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbaAVLqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:46:13 -0500
From: Michael Trimarchi <michael@amarulasolutions.com>
To: linux-mmc@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>,
        Manjunathappa Prakash <prakash.pm@ti.com>
Subject: [RFC PATCH 0/3] ARM: mmc: davinci: Small fixes on host davinci driver
Date: Wed, 22 Jan 2014 12:46:02 +0100
Message-Id: <1390391165-27906-1-git-send-email-michael@amarulasolutions.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I had the omapl138 board for one day.
Looking at the code I have noticed that opendrain mmc configuration is buggy.
I don't have the possibility to test but it should be correct to use
host clock variable information. The other two patches are small style cleanup

Michael Trimarchi (3):
  ARM: mmc: davinci: remove unused variable mmc_pclk and fix opendrain  
      clock calculation
  ARM: mmc: davinci: Remove cast to the same type
  ARM: mmc: davinci: clock rate is an unsigned long

 drivers/mmc/host/davinci_mmc.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

-- 
1.8.1.2

