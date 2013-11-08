Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab3KHAxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:53:31 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:36233 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab3KHAx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:53:28 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 0/3] panic: improvements
Date: Thu,  7 Nov 2013 18:46:37 -0600
Message-Id: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4.2+fc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While debugging a hang after panic in my laptop (I cannot hard-reboot, or
unplug the battery), I noticed the panic code has some areas of improvment.

Only the first patch is really needed, the rest seem like good to have.

Felipe Contreras (3):
  panic: setup panic_timeout early
  panic: improve panic_timeout calculation
  panic: enable local IRQs for restart timeout too

 kernel/panic.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

-- 
1.8.4.2+fc1

