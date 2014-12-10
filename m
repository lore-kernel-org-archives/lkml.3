Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbaLJCfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 21:35:52 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:61725 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaLJCfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 21:35:51 -0500
From: Paul Moore <paul@paul-moore.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Audit patches for 3.19
Date: Tue, 09 Dec 2014 21:35:48 -0500
Message-ID: <2676941.D86tdbjuKD@sifl>
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Two small patches from the audit next branch; only one of which has any real 
significant code changes, the other is simply a MAINTAINERS update for audit.  
The single code patch is pretty small and rather straightforward, it changes 
the audit "version" number reported to userspace from an integer to a bitmap 
which is used to indicate the functionality of the running kernel.  This 
really doesn't have much impact on the kernel, but it will make life easier 
for the audit userspace folks.  Thankfully we were still on a version number 
which allowed us to do this without breaking userspace.

For what it is worth, as of a few minutes ago, the branch below applied 
cleanly on top of your tree.

Thanks,
-Paul

---
The following changes since commit 799b601451b21ebe7af0e6e8f6e2ccd4683c5064:

  audit: keep inode pinned (2014-11-11 14:20:22 -0500)

are available in the git repository at:

  git://git.infradead.org/users/pcmoore/audit upstream

for you to fetch changes up to 0f7e94ee40d06f7a04e039392dfee8244bd8a7e0:

  Merge branch 'next' into upstream for v3.19 (2014-12-09 14:38:30 -0500)

----------------------------------------------------------------
Paul Moore (2):
      audit: add Paul Moore to the MAINTAINERS entry
      Merge branch 'next' into upstream for v3.19

Richard Guy Briggs (1):
      audit: convert status version to a feature bitmap

 MAINTAINERS                |  5 +++--
 include/uapi/linux/audit.h | 17 +++++++++++++----
 kernel/audit.c             |  2 +-
 3 files changed, 17 insertions(+), 7 deletions(-)


