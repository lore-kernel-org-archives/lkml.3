Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbaCZXts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 19:49:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40916 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaCZXtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 19:49:47 -0400
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Mitchel Humpherys <mitchelh@codeaurora.org>
Subject: [PATCH] Some printk cleanup in mm
Date: Wed, 26 Mar 2014 16:49:42 -0700
Message-Id: <1395877783-18910-1-git-send-email-mitchelh@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series cleans up some printks in the mm code that were missing
log levels.

Mitchel Humpherys (1):
  mm: convert some level-less printks to pr_*

 mm/bounce.c    |  5 +++--
 mm/mempolicy.c |  3 ++-
 mm/mmap.c      | 19 ++++++++++---------
 mm/nommu.c     |  3 ++-
 mm/slub.c      |  7 ++++---
 mm/vmscan.c    |  3 ++-
 6 files changed, 23 insertions(+), 17 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

