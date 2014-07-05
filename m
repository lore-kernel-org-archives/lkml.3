Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaGEM4w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 08:56:52 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54281 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaGEM4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 08:56:51 -0400
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH] zlib: dead code cleanup
Date: Sat,  5 Jul 2014 21:56:16 +0900
Message-Id: <1404564977-1636-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.0.1.612.gea98109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch removes some unused code in zlib inflate/deflate.
Functions in question have been dead since 2006.

Sergey Senozhatsky (1):
  zlib: cleanup some dead code

 include/linux/zlib.h       | 118 -------------------------------------
 lib/zlib_deflate/deflate.c | 143 ---------------------------------------------
 lib/zlib_inflate/inflate.c | 132 -----------------------------------------
 3 files changed, 393 deletions(-)

-- 
2.0.1.612.gea98109

