Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759688AbaJ3NIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:08:07 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41500 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759020AbaJ3NIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:08:05 -0400
From: Isamu Mogi <isamu@leafytree.jp>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        isamu@leafytree.jp
Subject: [PATCH v2 0/3] MIPS: R3000: Fix debug output for Virtual page number
Date: Thu, 30 Oct 2014 22:07:35 +0900
Message-Id: <1414674458-7583-1-git-send-email-isamu@leafytree.jp>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410278429-8541-1-git-send-email-isamu@leafytree.jp>
References: <1410278429-8541-1-git-send-email-isamu@leafytree.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set fixes the bit mask for MIPS R3000's virtual page number in
debug output. Also replace magic numbers with macros to decrease the
likelihood of issues like this.

Changes in v2:
- Replace magic numbers with macros
- Remove redundant parentheses

Isamu Mogi (3):
  MIPS: R3000: Fix debug output for Virtual page number
  MIPS: R3000: Replace magic numbers with macros
  MIPS: R3000: Remove redundant parentheses

 arch/mips/lib/r3k_dump_tlb.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

-- 
1.9.1

