Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaE2BoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 21:44:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45415 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaE2BoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 21:44:08 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Andy Lutomirski <luto@amacapital.net>, Philipp Kern <pkern@google.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "H. J. Lu" <hjl.tools@gmail.com>, Eric Paris <eparis@redhat.com>,
        security@kernel.org, greg@kroah.com, linux-audit@redhat.com
Subject: [PATCH v2 0/2] Fix auditsc DoS and mark it BROKEN
Date: Wed, 28 May 2014 18:43:59 -0700
Message-Id: <cover.1401327752.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_AUDITSYSCALL is awful.  Patch 2 enumerates some reasons.

Patch 1 fixes a nasty DoS and possible information leak.  It should
be applied and backported.

Patch 2 is optional.  I leave it to other peoples' judgment.

Andy Lutomirski (2):
  auditsc: audit_krule mask accesses need bounds checking
  audit: Move CONFIG_AUDITSYSCALL into staging and update help text

Andy Lutomirski (2):
  auditsc: audit_krule mask accesses need bounds checking
  audit: Mark CONFIG_AUDITSYSCALL BROKEN and update help text

 init/Kconfig     | 13 ++++++++-----
 kernel/auditsc.c | 27 ++++++++++++++++++---------
 2 files changed, 26 insertions(+), 14 deletions(-)

-- 
1.9.3

