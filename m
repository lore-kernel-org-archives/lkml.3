Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbaKMETP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 23:19:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbaKMETO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 23:19:14 -0500
From: Paul Moore <pmoore@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Audit fixes for 3.18
Date: Wed, 12 Nov 2014 23:19:11 -0500
Message-ID: <4297973.SuVNDTyoQA@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.2 (Linux/3.16.7-gentoo; KDE/4.14.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

After he sent the initial audit pull request for 3.18, Eric asked me to take 
over the management of the audit tree, hence this pull request to fix a couple 
of problems with audit.  As you can see below, the changes are minimal: adding 
some whitespace to a string so userspace parses it correctly, and fixing a 
problem with audit's usage of fsnotify that was causing audit watch rules to 
be lost.  Neither of these patches were very controversial on the mailing 
lists and they fix real problems, getting them into 3.18 would be a good 
thing.

As of about ten minutes ago, the audit tree applied cleanly on top of your 
tree.

Thanks,
-Paul

---
The following changes since commit 2991dd2b0117e864f394c826af6df144206ce0db:

  audit: rename audit_log_remove_rule to disambiguate for trees (2014-10-10 
15:30:25 -0400)

are available in the git repository at:

  git://git.infradead.org/users/pcmoore/audit stable-3.18

for you to fetch changes up to 799b601451b21ebe7af0e6e8f6e2ccd4683c5064:

  audit: keep inode pinned (2014-11-11 14:20:22 -0500)

----------------------------------------------------------------
Miklos Szeredi (1):
      audit: keep inode pinned

Richard Guy Briggs (1):
      audit: AUDIT_FEATURE_CHANGE message format missing delimiting space

 kernel/audit.c      | 2 +-
 kernel/audit_tree.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
paul moore
security and virtualization @ redhat

