Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966134AbaFTUW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:22:56 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:63392 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753833AbaFTUWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:22:55 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoHAEGXpFNXQzOZ/2dsb2JhbABZgw2rRwUBAQEBAQEFAZkqgQ4XdYRgI4EaiH0BylSFYokUHYQtBJpEk1qDRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: dushistov@mail.ru, akpm@linux-foundation.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 0/5] UFS logging clean-up
Date: Fri, 20 Jun 2014 22:21:32 +0200
Message-Id: <1403295692-4704-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patchset convert UFS to current logging functions.

Fabian Frederick (5):
  FS/UFS: convert printk to pr_foo()
  FS/UFS: use pr_fmt
  fs/ufs/super.c: use __func__ in logging
  fs/ufs/super.c: use va_format instead of buffer/vsnprintf
  FS/UFS: convert UFSD printk to pr_debug

 fs/ufs/Makefile |   1 +
 fs/ufs/super.c  | 304 ++++++++++++++++++++++++++++----------------------------
 fs/ufs/ufs.h    |  10 +-
 3 files changed, 161 insertions(+), 154 deletions(-)

-- 
1.8.4.5

