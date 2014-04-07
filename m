Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbaDGSS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:18:58 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56371 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbaDGSSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:18:54 -0400
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Joe Perches <joe@perches.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Mitchel Humpherys <mitchelh@codeaurora.org>
Subject: [PATCH v3] Some printk cleanup in mm
Date: Mon,  7 Apr 2014 11:18:51 -0700
Message-Id: <1396894732-17963-1-git-send-email-mitchelh@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series cleans up some printks in the mm code that were missing
log levels.

Changelog:

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

