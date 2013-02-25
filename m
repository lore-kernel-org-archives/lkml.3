Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab3BYQr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 11:47:26 -0500
Received: from tundra.namei.org ([65.99.196.166]:51287 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab3BYQrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 11:47:23 -0500
Date: Tue, 26 Feb 2013 03:47:27 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem fixes
Message-ID: <alpine.LRH.2.02.1302260345030.31960@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull these fixes for your current tree.

>From Mimi:  "Both of these patches are bug fixes for patches, which were 
upstreamed in this open window.  The first patch addresses a merge issue.  
The second patch addresses a CONFIG_BLOCK dependency."



The following changes since commit ab7826595e9ec51a51f622c5fc91e2f59440481a:
  Linus Torvalds (1):
        Merge tag 'mfd-3.9-1' of git://git.kernel.org/.../sameo/mfd-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Mimi Zohar (2):
      ima: "remove enforce checking duplication" merge fix
      block: fix part_pack_uuid() build error

 include/linux/genhd.h               |   10 ++++++++++
 security/integrity/ima/ima_main.c   |    3 ++-
 security/integrity/ima/ima_policy.c |   11 ++++++-----
 3 files changed, 18 insertions(+), 6 deletions(-)
