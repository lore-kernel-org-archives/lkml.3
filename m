Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbaLHToV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:44:21 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44188 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbaLHToT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:44:19 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/2] x86_64: switch_to fixes
Date: Mon,  8 Dec 2014 11:44:13 -0800
Message-Id: <cover.1418067750.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 is for stable.  It fixes a bug and an information leak.
Patch 2 is just cosmetic and is therefore not marked for stable.

Andy Lutomirski (2):
  x86_64, switch_to: Load TLS descriptors before switching DS and ES
  x86_64, switch_to: Fix an incorrect comment

 arch/x86/kernel/process_64.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

-- 
1.9.3

