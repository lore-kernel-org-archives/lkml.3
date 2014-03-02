Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaCBNkT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 08:40:19 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:47733 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaCBNkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 08:40:17 -0500
From: Gideon Israel Dsouza <gidisrael@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, geert@linux-m68k.org,
        Gideon Israel Dsouza <gidisrael@gmail.com>
Subject: [PATCH 0/1] mm: Use macros from compiler.h instead of gcc specific attribute
Date: Sun,  2 Mar 2014 19:09:57 +0530
Message-Id: <1393767598-15954-1-git-send-email-gidisrael@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm extremely sorry about the mistake in the earlier patch.

The following patch is a corrected one.

================== Original Cover Letter ==================
To increase compiler portability there is <linux/compiler.h> which
provides convenience macros for various gcc constructs.  Eg: __weak for
__attribute__((weak)).

I've taken up the job of cleaning these attributes all over the kernel.
Currently my patches for cleanup of all files under /kernel and /block
are already done and in the linux-next tree.

In the following patch I've replaced all aforementioned instances under
the /mm directory in the kernel source.
==============================================================

Gideon Israel Dsouza (1):
  mm: use macros from compiler.h instead of __attribute__((...))

 mm/hugetlb.c | 3 ++-
 mm/nommu.c   | 3 ++-
 mm/sparse.c  | 4 +++-
 mm/util.c    | 5 +++--
 mm/vmalloc.c | 4 +++-
 5 files changed, 13 insertions(+), 6 deletions(-)

-- 
1.8.5.3

