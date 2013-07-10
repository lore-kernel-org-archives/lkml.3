Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3GJPTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:19:01 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:46311 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab3GJPTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:19:00 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Subject: [PATCH v2 0/3] Modernize menuconfig a bit
Date: Wed, 10 Jul 2013 20:45:15 +0530
Message-Id: <1373469318-13956-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.736.g869de25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After Michal's (somewhat positive) response to the first iteration,
here's the second iteration fixing the reserved-letters problem.

I also find hitting <ESC><ESC> to return to the previous page quite
annoying, and I hope to tackle this in the future depending on how the
community responds to [3/3].

Independent of part 3, I think parts 1 and 2 are obviously correct,
and should be merged.

Thanks.

Ramkumar Ramachandra (3):
  menuconfig: factor out reserved letters
  menuconfig: remove redundant info from RESERVED_LETTERS
  menuconfig: allow j/k to move down/up the menu

 scripts/kconfig/lxdialog/menubox.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

-- 
1.8.3.2.736.g869de25

