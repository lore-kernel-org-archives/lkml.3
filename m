Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965698AbaH1KAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:00:33 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56278 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936510AbaH1KAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:00:30 -0400
From: Juri Lelli <juri.lelli@arm.com>
To: peterz@infradead.org
Cc: luca.abeni@unitn.it, rdunlap@infradead.org, mingo@redhat.com,
        henrik@austad.us, raistlin@linux.it, juri.lelli@gmail.com,
        juri.lelli@arm.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] SCHED_DEADLINE documentation fixes and improvements
Date: Thu, 28 Aug 2014 11:00:25 +0100
Message-Id: <1409220029-9002-1-git-send-email-juri.lelli@arm.com>
X-Mailer: git-send-email 2.0.4
X-OriginalArrivalTime: 28 Aug 2014 10:00:27.0003 (UTC) FILETIME=[E47164B0:01CFC2A6]
X-MC-Unique: 114082811002802501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s7SA0bOu017312

Hello everyone,

This is version 3 of a small patchset that fixes and improves SCHED_DEADLINE
documentation.

Patch 1/4 fixes and clarifies terminology; patch 2/4 aligns Section 4 to
the current interface; patch 3/4 improves and clarifies what admission
control means on UP an SMP systems; patch 4/4 introduces an appendix about
testing.

Changes since v1:

 - fixed typos spotted by Randy and Peter (thanks!)

Changes since v2:

 - fixed typos and rewrote paragraphs as suggested by Ingo (thanks!)

Best Regards,

- Juri

Juri Lelli (2):
  Documentation/scheduler/sched-deadline.txt: Rewrite section 4 intro
  Documentation/scheduler/sched-deadline.txt: add tests suite appendix

Luca Abeni (2):
  Documentation/scheduler/sched-deadline.txt: fix terminology and
    improve clarity
  Documentation/scheduler/sched-deadline.txt: improve and clarify AC
    bits

 Documentation/scheduler/sched-deadline.txt | 204 ++++++++++++++++++++++-------
 1 file changed, 159 insertions(+), 45 deletions(-)

-- 
2.0.4


