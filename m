Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093AbaLLACR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 19:02:17 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:52249 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095AbaLLACQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 19:02:16 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] lib: bitmap: Another small series
Date: Fri, 12 Dec 2014 01:01:46 +0100
Message-Id: <1418342514-21630-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found some patches in a long-forgotten branch - they still applied
cleanly, so I spiced them up with a few extra simplifications and
signed->unsigned conversions.

Rasmus Villemoes (8):
  lib: bitmap: More signed->unsigned conversions
  linux/nodemask.h: Update bitmap wrappers to take unsigned int
  linux/cpumask.h: Update bitmap wrappers to take unsigned int
  lib: bitmap: Update bitmap_onto to unsigned
  lib: bitmap: Change parameters of bitmap_fold to unsigned
  lib: bitmap: Simplify bitmap_pos_to_ord
  lib: bitmap: Simplify bitmap_ord_to_pos
  lib: bitmap: Minor changes of bitmap_remap

 include/linux/bitmap.h   | 22 ++++++-------
 include/linux/cpumask.h  | 22 ++++++-------
 include/linux/nodemask.h | 26 +++++++--------
 lib/bitmap.c             | 85 +++++++++++++++++++++---------------------------
 4 files changed, 72 insertions(+), 83 deletions(-)

-- 
2.1.3

