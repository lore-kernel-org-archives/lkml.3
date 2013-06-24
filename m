Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab3FXMt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:49:58 -0400
Received: from multi.imgtec.com ([194.200.65.239]:2050 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab3FXMt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:49:57 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 0/2] metag: cache aliasing detection fixes
Date: Mon, 24 Jun 2013 13:49:46 +0100
Message-ID: <1372078188-26602-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_24_13_49_56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of metag cache aliasing detection fixes I intend on applying
for v3.11.

James Hogan (2):
  metag: panic if cache aliasing possible
  metag: don't check for cache aliasing on smp cpu boot

 arch/metag/kernel/cachepart.c | 13 +++++++------
 arch/metag/kernel/smp.c       |  6 ------
 2 files changed, 7 insertions(+), 12 deletions(-)

-- 
1.8.1.2


