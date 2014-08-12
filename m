Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaHLPtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 11:49:49 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52887 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbaHLPts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 11:49:48 -0400
From: Juri Lelli <juri.lelli@arm.com>
To: peterz@infradead.org
Cc: luca.abeni@unitn.it, rdunlap@infradead.org, mingo@redhat.com,
        henrik@austad.us, raistlin@linux.it, juri.lelli@gmail.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Juri Lelli <juri.lelli@arm.com>
Subject: [PATCH 0/4] SCHED_DEADLINE documentation fixes and improvements
Date: Tue, 12 Aug 2014 16:49:11 +0100
Message-Id: <1407858555-14371-1-git-send-email-juri.lelli@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 12 Aug 2014 15:49:41.0907 (UTC) FILETIME=[07EDFE30:01CFB645]
X-MC-Unique: 114081216494504001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s7CFoDlp014541

Hello everyone,

This small patchset fixes and improves SCHED_DEADLINE documentation.

Patch 1/4 fixes and clarifies terminology; patch 2/4 aligns Section 4 to
the current interface; patch 3/4 improves and clarifies what admission
control means on UP an SMP systems; patch 4/4 introduces an appendix about
testing.

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

 Documentation/scheduler/sched-deadline.txt |  200 ++++++++++++++++++++++------
 1 file changed, 156 insertions(+), 44 deletions(-)

-- 
1.7.9.5


