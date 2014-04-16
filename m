Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbaDPASn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 20:18:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39611 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaDPASm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 20:18:42 -0400
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Joe Perches <joe@perches.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Mitchel Humpherys <mitchelh@codeaurora.org>
Subject: [PATCH v4] Some printk cleanup in mm
Date: Tue, 15 Apr 2014 17:18:29 -0700
Message-Id: <1397607510-16084-1-git-send-email-mitchelh@codeaurora.org>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series cleans up some printks in the mm code that were missing
log levels.

Changelog:

  - v4: Remove redundant prefixes due to pr_fmt, improve commit
    message (suggested by Andrew Morton)

  - v3: Leaving slub.c alone. It's using hand-tagged printk's
    correctly so it's probably just churn to convert everything to the
    pr_ macros.

  - v2: Suggestions by Joe Perches (pr_fmt, pr_cont, pr_err, __func__,
    missing \n)

Mitchel Humpherys (1):
  mm: convert some level-less printks to pr_*

 mm/bounce.c    |  7 +++++--
 mm/mempolicy.c |  5 ++++-
 mm/mmap.c      | 21 ++++++++++++---------
 mm/nommu.c     |  5 ++++-
 mm/vmscan.c    |  5 ++++-
 5 files changed, 29 insertions(+), 14 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

