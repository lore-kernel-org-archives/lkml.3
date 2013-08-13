Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab3HMRYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:24:53 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:52343 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758623Ab3HMRYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:24:51 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <dan.carpenter@oracle.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 00/10] staging: ozwpan: Coding style fixes
Date: Tue, 13 Aug 2013 18:24:20 +0100
Message-ID: <1376414670-23257-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch seriese mostly contains coding style fixes & removes unneeded
variable initialization.

Dan Carpenter (1):
  staging: ozwpan: Separate success & failure case for
    oz_hcd_pd_arrived()

Rupesh Gujare (9):
  staging: ozwpan: Add a blank line between declaraction and code.
  staging: ozwpan: Add a blank line between functions & declarations.
  staging: ozwpan: Simply if condition
  staging: ozwpan: Fix coding style.
  staging: ozwpan: Remove unnecessary pointer check.
  staging: ozwpan: Make oz_hcd_pd_arrived() return a struct pointer
  staging: ozwpan: Make oz_hcd_pd_departed() take a struct pointer.
  staging: ozwpan: Remove unneeded initializers
  staging: ozwpan: Swap arguments of oz_ep_alloc() to match kmalloc()

 drivers/staging/ozwpan/ozcdev.c        |   23 ++++
 drivers/staging/ozwpan/ozeltbuf.c      |   21 +++-
 drivers/staging/ozwpan/ozhcd.c         |  197 ++++++++++++++++++++++++--------
 drivers/staging/ozwpan/ozhcd.h         |    4 +-
 drivers/staging/ozwpan/ozmain.c        |    3 +
 drivers/staging/ozwpan/ozpd.c          |   66 ++++++++++-
 drivers/staging/ozwpan/ozproto.c       |   33 ++++++
 drivers/staging/ozwpan/ozurbparanoia.c |    4 +
 drivers/staging/ozwpan/ozusbsvc.c      |   17 +++
 drivers/staging/ozwpan/ozusbsvc1.c     |   21 ++++
 10 files changed, 334 insertions(+), 55 deletions(-)

-- 
1.7.9.5

