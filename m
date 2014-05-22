Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaEVWYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 18:24:21 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:33785 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaEVWYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 18:24:20 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/3]  x86_64,vsyscall: Minor cleanups and fixes
Date: Thu, 22 May 2014 15:24:13 -0700
Message-Id: <cover.1400797362.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This turns the vsyscall page all the way off in vsyscall=none mode
and fixes a bug in warn_bad_vsyscall that resulted in corrupt log
lines.

With this series applied, vsyscall=none results in a tidier
/proc/PID/maps.

Andy Lutomirski (3):
  x86_64,vsyscall: Move all of the gate_area code to vsyscall_64.c
  x86_64,vsyscall: Turn vsyscalls all the way off when vsyscall=none
  x86_64,vsyscall: Fix warn_bad_vsyscall log output

 arch/x86/kernel/vsyscall_64.c | 69 ++++++++++++++++++++++++++++++++++++++-----
 arch/x86/mm/init_64.c         | 49 ------------------------------
 2 files changed, 61 insertions(+), 57 deletions(-)

-- 
1.9.0

