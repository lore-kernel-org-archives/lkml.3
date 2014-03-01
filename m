Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaCAQDK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 11:03:10 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61458 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbaCAQDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 11:03:09 -0500
From: Gideon Israel Dsouza <gidisrael@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, geert@linux-m68k.org,
        Gideon Israel Dsouza <gidisrael@gmail.com>
Subject: [PATCH 0/1] Use macros from compiler.h instead of gcc specific attributes
Date: Sat,  1 Mar 2014 21:32:27 +0530
Message-Id: <1393689748-32236-1-git-send-email-gidisrael@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To increase compiler portability there is <linux/compiler.h> which
provides convenience macros for various gcc constructs.  Eg: __weak for
__attribute__((weak)).  

I've taken up the job of cleaning these attributes all over the kernel.
Currently my patches for cleanup of all files under /kernel and /block
are already done and in the linux-next tree.

In the following patch I've replaced all aforementioned instances under
the /mm directory in the kernel source.

Gideon Israel Dsouza (1):
  mm: use macros from compiler.h instead of __attribute__((...))

 mm/hugetlb.c | 3 ++-
 mm/nommu.c   | 3 ++-
 mm/sparse.c  | 6 ++++--
 mm/util.c    | 5 +++--
 mm/vmalloc.c | 4 +++-
 5 files changed, 14 insertions(+), 7 deletions(-)

-- 
1.8.5.3

