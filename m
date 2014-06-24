Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbaFXKHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:07:01 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:45593 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaFXKG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:06:59 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Don Mullis <don.mullis@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v2 0/4] lib: list_sort: Various minor improvements
Date: Tue, 24 Jun 2014 12:06:27 +0200
Message-Id: <1403604392-23259-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading the source of lib/list_sort.c, I came up with a few possible
improvements. I think 4/4 may be a bit controversial, but 1/4, 2/4 and
3/4 should be straightforward.

v2: Fix typo in 2/4, and add 3/4,4/4.

Rasmus Villemoes (4):
  lib: list_sort_test(): Return -ENOMEM when allocation fails
  lib: list_sort_test(): Add extra corruption check
  lib: list_sort_test(): Simplify and harden cleanup
  lib: list_sort.c: Limit number of unused cmp callbacks

 lib/list_sort.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

-- 
1.9.2

