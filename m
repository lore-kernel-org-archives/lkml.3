Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbaIIJ5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:57:11 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42898 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077AbaIIJ5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:57:07 -0400
From: Juri Lelli <juri.lelli@arm.com>
To: peterz@infradead.org
Cc: luca.abeni@unitn.it, rdunlap@infradead.org, mingo@redhat.com,
        henrik@austad.us, raistlin@linux.it, juri.lelli@gmail.com,
        juri.lelli@arm.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/5] SCHED_DEADLINE documentation fixes and improvements
Date: Tue,  9 Sep 2014 10:57:11 +0100
Message-Id: <1410256636-26171-1-git-send-email-juri.lelli@arm.com>
X-Mailer: git-send-email 2.0.4
X-OriginalArrivalTime: 09 Sep 2014 09:57:02.0048 (UTC) FILETIME=[673CBE00:01CFCC14]
X-MC-Unique: 114090910570403701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s899vF9V005179

Hello everyone,

This is version 4 of a small patchset that fixes and improves SCHED_DEADLINE
documentation.

Patch 1/5 fixes and clarifies terminology; patch 2/5 aligns Section 4 to
the current interface; patch 3/5 improves and clarifies what admission
control means on UP an SMP systems; patch 4/5 introduces an appendix about
testing; patch 5/5 introduces an appendix with a minimal main() for
application developers.

Changes since v1:

 - fixed typos spotted by Randy and Peter (thanks!)

Changes since v2:

 - fixed typos and rewrote paragraphs as suggested by Ingo (thanks!)

Changes since v3:

 - addressed comments made by Henrik (thanks!)
 - added patch 5/5 (as Henrik asked)

Best Regards,

- Juri

Juri Lelli (3):
  Documentation/scheduler/sched-deadline.txt: Rewrite section 4 intro
  Documentation/scheduler/sched-deadline.txt: add tests suite appendix
  Documentation/scheduler/sched-deadline.txt: add minimal main()
    appendix

Luca Abeni (2):
  Documentation/scheduler/sched-deadline.txt: fix terminology and
    improve clarity
  Documentation/scheduler/sched-deadline.txt: improve and clarify AC
    bits

 Documentation/scheduler/sched-deadline.txt | 340 +++++++++++++++++++++++++----
 1 file changed, 292 insertions(+), 48 deletions(-)

-- 
2.0.4


