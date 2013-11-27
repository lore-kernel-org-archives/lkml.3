Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3K0GZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:25:14 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:34847 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab3K0GZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:25:12 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Levente Kurusa <levex@linux.com>, Jason Baron <jbaron@akamai.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v4 0/2] Setup panic params early
Date: Wed, 27 Nov 2013 00:17:48 -0600
Message-Id: <1385533070-7604-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4.2+fc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exactly the same as v3, but with an unlrelated patch on top as well.

Felipe Contreras (2):
  panic: setup panic_timeout early
  panic: setup panic_on_oops early

 kernel/panic.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

-- 
1.8.4.2+fc1

