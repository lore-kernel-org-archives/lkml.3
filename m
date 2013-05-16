Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab3EQPxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 11:53:52 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:57598 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab3EQPxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 11:53:51 -0400
From: Pavel Tikhomirov <snorcht@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Helsley <matt.helsley@gmail.com>, linux-api@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Pavel Tikhomirov <snorcht@gmail.com>
Subject: [PATCH 0/1] posix timers: Expand exitsting info in proc file
Date: Fri, 17 May 2013 02:12:02 +0400
Message-Id: <1368742323-46949-1-git-send-email-snorcht@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I'm working on the checkpoint-restore project (http://criu.org), on
realisation of posix-timers. To compleatly checkpoint and restore these
timers we need to know which clock they are using. So I d'like to add
this information to existing syscall which shows posix-timers info.

Pavel Tikhomirov (1):
  posix-timers: Show clock ID in proc file

 fs/proc/base.c |    1 +
 1 file changed, 1 insertion(+)

-- 
1.7.9.5

