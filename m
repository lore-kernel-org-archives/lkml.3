Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750852AbaESEL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 00:11:57 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:50041 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaESEL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 00:11:56 -0400
From: Anton Saraev <antonysaraev@gmail.com>
To: gregkh@linuxfoundation.org
Cc: antonysaraev@gmail.com, jason@lakedaemon.net, jake@lwn.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/06] staging: crypto: skein: fixing style issues
Date: Mon, 19 May 2014 12:09:53 +0400
Message-Id: <cover.1399675444.git.antonysaraev@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi! To prepare skein driver for mainline inclusion we fixing most of
style issues (wrong names of functions, vars, macros, files) and 
checkpatch problems in this patch set. For example, existing code 
is widely use camelCase names. This patch fix it.

Anton Saraev (6):
  staging: crypto: skein: rename camelcase functions
  staging: crypto: skein: rename camelcase vars
  staging: crypto: skein: rename skein1024_ctx to skein_1024_ctx
  staging: crypto: skein: rename enums
  staging: crypto: skein: rename macros
  staging: crypto: skein: rename files

 drivers/staging/skein/Makefile                     |  10 +-
 drivers/staging/skein/TODO                         |   3 -
 drivers/staging/skein/include/skein.h              | 180 +++----
 .../skein/include/{skeinApi.h => skein_api.h}      |  66 +--
 drivers/staging/skein/include/skein_block.h        |  12 +-
 drivers/staging/skein/include/skein_iv.h           |   6 +-
 .../include/{threefishApi.h => threefish_api.h}    |  84 +--
 drivers/staging/skein/skein.c                      | 577 +++++++++++----------
 drivers/staging/skein/{skeinApi.c => skein_api.c}  | 170 +++---
 drivers/staging/skein/skein_block.c                | 411 +++++++--------
 .../{skeinBlockNo3F.c => skein_block_no_3f.c}      |  62 +--
 drivers/staging/skein/threefishApi.c               |  79 ---
 ...threefish1024Block.c => threefish_1024_block.c} |  80 +--
 .../{threefish256Block.c => threefish_256_block.c} |  32 +-
 .../{threefish512Block.c => threefish_512_block.c} |  48 +-
 drivers/staging/skein/threefish_api.c              |  78 +++
 16 files changed, 959 insertions(+), 939 deletions(-)
 rename drivers/staging/skein/include/{skeinApi.h => skein_api.h} (79%)
 rename drivers/staging/skein/include/{threefishApi.h => threefish_api.h} (66%)
 rename drivers/staging/skein/{skeinApi.c => skein_api.c} (52%)
 rename drivers/staging/skein/{skeinBlockNo3F.c => skein_block_no_3f.c} (66%)
 delete mode 100644 drivers/staging/skein/threefishApi.c
 rename drivers/staging/skein/{threefish1024Block.c => threefish_1024_block.c} (98%)
 rename drivers/staging/skein/{threefish256Block.c => threefish_256_block.c} (96%)
 rename drivers/staging/skein/{threefish512Block.c => threefish_512_block.c} (97%)
 create mode 100644 drivers/staging/skein/threefish_api.c

-- 
1.9.2

