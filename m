Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaFWGCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 02:02:24 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60753 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaFWGCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 02:02:22 -0400
From: Tushar Behera <tushar.b@samsung.com>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org, jslaby@suse.cz,
        gregkh@linuxfoundation.org, linux@arm.linux.org.uk
Cc: trblinux@gmail.com
Subject: [PATCH 0/2] serial: amba-pl01x: Clean up patches
Date: Mon, 23 Jun 2014 11:29:09 +0530
Message-Id: <1403503151-4166-1-git-send-email-tushar.b@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches are based next-20140620 and they have only been build
tested.

Tushar Behera (2):
  serial: amba-pl011: Simplify goto statements
  serial: amba-pl010: Use devres APIs

 drivers/tty/serial/amba-pl010.c |   46 ++++++++++++++-------------------------
 drivers/tty/serial/amba-pl011.c |   30 +++++++++----------------
 2 files changed, 26 insertions(+), 50 deletions(-)

-- 
1.7.9.5

