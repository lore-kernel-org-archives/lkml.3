Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbaC0Ry3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 13:54:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59347 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbaC0Ry2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 13:54:28 -0400
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Joe Perches <joe@perches.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Mitchel Humpherys <mitchelh@codeaurora.org>
Subject: [PATCH v2] Some printk cleanup in mm
Date: Thu, 27 Mar 2014 10:54:18 -0700
Message-Id: <1395942859-11611-1-git-send-email-mitchelh@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series cleans up some printks in the mm code that were missing
log levels.

Changelog:

  - v2: Suggestions by Joe Perches (pr_fmt, pr_cont, pr_err, __func__,
    missing \n)

Mitchel Humpherys (1):
  mm: convert some level-less printks to pr_*

 mm/bounce.c    |  7 +++++--
 mm/mempolicy.c |  5 ++++-
 mm/mmap.c      | 21 ++++++++++++---------
 mm/nommu.c     |  5 ++++-
 mm/slub.c      |  9 ++++++---
 mm/vmscan.c    |  5 ++++-
 6 files changed, 35 insertions(+), 17 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

