Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaLTS3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 13:29:25 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:51590 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaLTS3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 13:29:24 -0500
From: robert.ward114@googlemail.com
To: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: Rob Ward <robert.ward114@googlemail.com>
Subject: [PATCH 0/2] checkpatch Warning fixes in drivers/char/mem.c
Date: Sat, 20 Dec 2014 18:28:34 +0000
Message-Id: <1419100116-29819-1-git-send-email-robert.ward114@googlemail.com>
X-Mailer: git-send-email 2.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Ward <robert.ward114@googlemail.com>

Couple of changes to remove warnings reported by checkpatch.pl within
drivers/char/mem.c

Neither of these patches introduce functional changes.

Rob Ward (2):
  drivers: char: mem: Replace usage of asm include
  drivers: char: mem: Fix Missing blank line issues

 drivers/char/mem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
2.0.2

