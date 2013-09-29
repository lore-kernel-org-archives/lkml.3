Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab3I2Pjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 11:39:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38814 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab3I2Pjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 11:39:36 -0400
From: John Johansen <john.johansen@canonical.com>
To: jmorris@namei.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 0/2] apparmor: fix issues with the 3.12 pull request
Date: Sun, 29 Sep 2013 08:39:20 -0700
Message-Id: <1380469162-18604-1-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James,

could you pull and forward the follow fixes for the 3.12 kernel. Both
issues have had multiple reports.

thanks

---


The following changes since commit eb8948a03704f3dbbfc7e83090e20e93c6c476d2:

  X.509: remove possible code fragility: enumeration values not handled (2013-09-25 17:17:01 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jj/linux-apparmor.git security-next

for you to fetch changes up to 94ecad0c9ca2c9345013d2417081cea7cf842c16:

  apparmor: fix suspicious RCU usage warning in policy.c/policy.h (2013-09-29 08:28:11 -0700)

----------------------------------------------------------------
John Johansen (1):
      apparmor: fix suspicious RCU usage warning in policy.c/policy.h

Tyler Hicks (1):
      apparmor: Use shash crypto API interface for profile hashes

 security/apparmor/crypto.c         | 34 ++++++++++++++++------------------
 security/apparmor/include/policy.h |  4 +++-
 security/apparmor/policy.c         |  3 ++-
 3 files changed, 21 insertions(+), 20 deletions(-)


