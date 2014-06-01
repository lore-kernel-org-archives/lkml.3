Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbaFANJK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:09:10 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:61135 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaFANJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:09:08 -0400
From: Real Name <enjoymindful@gmail.com>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: richard@nod.at, linux-kernel@vger.kernel.org,
        Honggang Li <enjoymindful@gmail.com>
Subject: [PATCH] delete unnecessary bootmem struct page array
Date: Sun,  1 Jun 2014 21:08:50 +0800
Message-Id: <1401628131-1948-1-git-send-email-enjoymindful@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Honggang Li <enjoymindful@gmail.com>

The patch based on linux-next-20140530.

Honggang Li (1):
  delete unnecessary bootmem struct page array

 arch/um/kernel/um_arch.c | 6 ------
 1 file changed, 6 deletions(-)

-- 
1.8.3.1

