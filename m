Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab3FLNBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 09:01:12 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:34383 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3FLNBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 09:01:10 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@driverdev.osuosl.org>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 00/01] staging: ozwpan: Remove event tracing code
Date: Wed, 12 Jun 2013 14:00:51 +0100
Message-ID: <1371042052-13463-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series removes event tracing code as it will be replaced by in-kernel
event tracing infrastructure.

http://permalink.gmane.org/gmane.linux.drivers.driver-project.devel/27606

Rupesh Gujare (1):
  staging: ozwpan: remove event tracing code.

 drivers/staging/ozwpan/Kbuild       |    3 +-
 drivers/staging/ozwpan/ozappif.h    |    2 -
 drivers/staging/ozwpan/ozcdev.c     |    5 -
 drivers/staging/ozwpan/ozconfig.h   |    1 -
 drivers/staging/ozwpan/ozevent.c    |  195 -----------------------------------
 drivers/staging/ozwpan/ozevent.h    |   32 ------
 drivers/staging/ozwpan/ozeventdef.h |   40 -------
 drivers/staging/ozwpan/ozhcd.c      |   47 ---------
 drivers/staging/ozwpan/ozmain.c     |    9 --
 drivers/staging/ozwpan/ozpd.c       |   23 +----
 drivers/staging/ozwpan/ozproto.c    |   17 ---
 drivers/staging/ozwpan/ozusbsvc.c   |    5 -
 drivers/staging/ozwpan/ozusbsvc1.c  |    5 -
 13 files changed, 4 insertions(+), 380 deletions(-)
 delete mode 100644 drivers/staging/ozwpan/ozevent.c
 delete mode 100644 drivers/staging/ozwpan/ozevent.h
 delete mode 100644 drivers/staging/ozwpan/ozeventdef.h

-- 
1.7.9.5

