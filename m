Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaICAxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 20:53:40 -0400
Received: from tundra.namei.org ([65.99.196.166]:34411 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbaICAxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 20:53:39 -0400
Date: Wed, 3 Sep 2014 10:53:30 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: [GIT] keys subsystem fixes for 3.17
Message-ID: <alpine.LRH.2.11.1409031050510.16251@namei.org>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull these fixes for the keys subsystem, one of which addresses a 
use-after-free bug.

The following changes since commit 7505ceaf863590b24a4c0c83b64817d26e0d51e3:

  Merge branch 'irq-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2014-09-01 10:36:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

David Howells (3):
      KEYS: Fix public_key asymmetric key subtype name
      KEYS: Fix use-after-free in assoc_array_gc()
      PEFILE: Relax the check on the length of the PKCS#7 cert

Steve Dickson (1):
      KEYS: Increase root_maxkeys and root_maxbytes sizes

 crypto/asymmetric_keys/public_key.c    |    1 +
 crypto/asymmetric_keys/verify_pefile.c |   49 +++++++++++++++++++++----------
 lib/assoc_array.c                      |    2 +-
 security/keys/key.c                    |    4 +-
 4 files changed, 37 insertions(+), 19 deletions(-)

