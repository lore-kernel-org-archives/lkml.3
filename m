Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3KFP0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 10:26:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab3KFP0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 10:26:04 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
cc: dhowells@redhat.com, sgallagh@redhat.com, rdunlap@infradead.org,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] KEYS: More fixes for next branch
Date: Wed, 06 Nov 2013 15:25:29 +0000
Message-ID: <14663.1383751529@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi James,

Here are another couple of fixes.  Could you apply them to your next branch?

David
---
The following changes since commit 217091dd7a7a1bdac027ddb7c5a25f6ac0b8e241:

  ima: define '_ima' as a builtin 'trusted' keyring (2013-10-31 20:20:48 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git keys-devel

for you to fetch changes up to fbf8c53f1a2ac7610ed124043600dc074992e71b:

  KEYS: Fix UID check in keyctl_get_persistent() (2013-11-06 14:01:51 +0000)

----------------------------------------------------------------
(from the branch description for keys-devel local branch)

clone of "master"
----------------------------------------------------------------
David Howells (2):
      KEYS: The RSA public key algorithm needs to select MPILIB
      KEYS: Fix UID check in keyctl_get_persistent()

 crypto/asymmetric_keys/Kconfig | 1 +
 security/keys/persistent.c     | 6 ++----
 2 files changed, 3 insertions(+), 4 deletions(-)
