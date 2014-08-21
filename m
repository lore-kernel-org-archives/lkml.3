Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbaHUJBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 05:01:55 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46481 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaHUJBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 05:01:52 -0400
From: Juri Lelli <juri.lelli@arm.com>
To: peterz@infradead.org
Cc: luca.abeni@unitn.it, rdunlap@infradead.org, mingo@redhat.com,
        henrik@austad.us, raistlin@linux.it, juri.lelli@gmail.com,
        juri.lelli@arm.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] SCHED_DEADLINE documentation fixes and improvements
Date: Thu, 21 Aug 2014 10:01:36 +0100
Message-Id: <1408611700-9420-1-git-send-email-juri.lelli@arm.com>
X-Mailer: git-send-email 2.0.4
X-OriginalArrivalTime: 21 Aug 2014 09:01:47.0233 (UTC) FILETIME=[899ADD10:01CFBD1E]
X-MC-Unique: 114082110014845001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s7L9200n004514

Hello everyone,

This is version 2 of a small patchset that fixes and improves SCHED_DEADLINE
documentation.

Patch 1/4 fixes and clarifies terminology; patch 2/4 aligns Section 4 to
the current interface; patch 3/4 improves and clarifies what admission
control means on UP an SMP systems; patch 4/4 introduces an appendix about
testing.

Changes since v1:

 - fixed typos spotted by Randy and Peter (thanks!)

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

 Documentation/scheduler/sched-deadline.txt | 200 ++++++++++++++++++++++-------
 1 file changed, 156 insertions(+), 44 deletions(-)

-- 
2.0.4


