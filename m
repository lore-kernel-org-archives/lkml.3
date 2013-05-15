Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab3EOQjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:39:15 -0400
Received: from sentry-two.sandia.gov ([132.175.109.14]:43758 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab3EOQjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:39:13 -0400
X-WSS-ID: 0MMUM99-0B-0Q6-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
From: "Jim Schutt" <jaschut@sandia.gov>
To: elder@inktank.com
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jim Schutt" <jaschut@sandia.gov>
Subject: [PATCH v2 1/3] ceph: fix up comment for ceph_count_locks() as
 to which lock to hold
Date: Wed, 15 May 2013 10:38:12 -0600
Message-ID: <1368635894-114707-2-git-send-email-jaschut@sandia.gov>
X-Mailer: git-send-email 1.7.8.2
In-Reply-To: <1368635894-114707-1-git-send-email-jaschut@sandia.gov>
References: <1368635894-114707-1-git-send-email-jaschut@sandia.gov>
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379,
 Antispam-Data: 2013.5.15.163017
X-PMX-Spam: Gauge=IIIIIIII, Probability=8%, Report=' MULTIPLE_RCPTS 0.1,
 HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0,
 BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0,
 BODY_SIZE_600_699 0, BODY_SIZE_7000_LESS 0, DATE_TZ_NA 0, __ANY_URI 0,
 __HAS_FROM 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __IN_REP_TO 0,
 __MIME_TEXT_ONLY 0, __MULTIPLE_RCPTS_CC_X2 0, __SANE_MSGID 0,
 __SUBJ_ALPHA_END 0, __TO_MALFORMED_2 0, __TO_NO_NAME 0, __URI_NO_PATH
 0, __URI_NO_WWW 0, __URI_NS '
X-TMWD-Spam-Summary: TS=20130515163843; ID=1; SEV=2.3.1;
 DFV=B2013022509; IFV=NA; AIF=B2013022509; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230362E35313933424131332E303038423A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAAAAAAAAAAAAAAAAAAAAAAAfQ==
X-MMS-Spam-Filter-ID: B2013022509_5.03.0010
MIME-Version: 1.0
X-WSS-ID: 7D8D659A2IW2829900-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-RSA-Inspected: yes
X-RSA-Classifications: public
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jim Schutt <jaschut@sandia.gov>
---
 fs/ceph/locks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index 202dd3d..ffc86cb 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -169,7 +169,7 @@ int ceph_flock(struct file *file, int cmd, struct file_lock *fl)
 }
 
 /**
- * Must be called with BKL already held. Fills in the passed
+ * Must be called with lock_flocks() already held. Fills in the passed
  * counter variables, so you can prepare pagelist metadata before calling
  * ceph_encode_locks.
  */
-- 
1.7.8.2


