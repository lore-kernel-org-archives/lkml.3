Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581Ab3FCSOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 14:14:10 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:48921 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041Ab3FCSOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 14:14:07 -0400
From: Marcus Overhagen <marcus.overhagen@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] staging: rts5139: Fix SD card reader for Samsung NP730U3E
Date: Mon,  3 Jun 2013 20:14:00 +0200
Message-Id: <1370283242-24434-1-git-send-email-marcus.overhagen@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg, please apply this patchset. There appears to exist no
maintainer for this driver.

Marcus Overhagen (2):
  staging: rts5139: Fix SD card detection on Samsung NP730U3E Ultrabook
  staging: rts5139: Use correct USB transfer interval to fix syslog spamming

 drivers/staging/rts5139/rts51x_transport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
1.8.1.2

