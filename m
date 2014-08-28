Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaH1LpC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:45:02 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:49544 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaH1Lo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:44:59 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 0/4] Remove various orphaned header files
Date: Thu, 28 Aug 2014 13:44:30 +0200
Message-Id: <1409226274-3202-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These four files are not included anywhere, and seem to be accidental
leftovers from past cleanups (see the individual commit messages).

Rasmus Villemoes (4):
  include/linux/cycx_x25.h: Remove unused header
  include/linux/i82593.h: Remove unused header
  include/linux/phonedev.h: Remove unused header
  include/rxrpc/types.h: Remove unused header

 include/linux/cycx_x25.h | 125 --------------------------
 include/linux/i82593.h   | 229 -----------------------------------------------
 include/linux/phonedev.h |  25 ------
 include/rxrpc/types.h    |  41 ---------
 4 files changed, 420 deletions(-)
 delete mode 100644 include/linux/cycx_x25.h
 delete mode 100644 include/linux/i82593.h
 delete mode 100644 include/linux/phonedev.h
 delete mode 100644 include/rxrpc/types.h

-- 
2.0.4

