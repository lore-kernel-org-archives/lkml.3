Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbaILOJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:09:50 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:57345 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbaILOJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:09:49 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@codethink.co.uk,
        rob.jones@codethink.co.uk
Subject: [PATCH 0/2] fs: proc: use seq_open_private()
Date: Fri, 12 Sep 2014 15:09:36 +0100
Message-Id: <1410530978-29627-1-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __seq_open_private() to reduce boilerplate code in proc.

This function has been around, undocumented, for years. It can simplify
the set up code for seq file operations.

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>


Rob Jones (2):
  fs: proc: use __seq_open_private()
  fs: proc: use __seq_open_private()

 fs/proc/task_mmu.c   |   42 ++++++++++++++++--------------------------
 fs/proc/task_nommu.c |   22 ++++++++--------------
 2 files changed, 24 insertions(+), 40 deletions(-)

-- 
1.7.10.4

