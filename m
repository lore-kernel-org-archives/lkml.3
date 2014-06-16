Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549AbaFPSXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:23:07 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:12941 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932370AbaFPSXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:23:05 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlUHAHASn1NbtAal/2dsb2JhbABagw2rFgUBAQEBAQEFAZkkgREXdYRgI4EaiH0Bz0GFY4kTHYQtBJpDk1iDQjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 0/3] ROMFS logging clean-up
Date: Mon, 16 Jun 2014 20:21:45 +0200
Message-Id: <1402942905-10558-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patchset converts romfs to current logging functions and fixes some
checkpatch warnings.

Fabian Frederick (3):
  fs/romfs/super.c: convert printk to pr_foo()
  fs/romfs/super.c: use pr_fmt in logging
  fs/romfs/super.c: add blank line after declarations.

 fs/romfs/super.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

-- 
1.8.4.5

