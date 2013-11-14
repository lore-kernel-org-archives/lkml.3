Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab3KNS6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:58:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab3KNS60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:58:26 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
cc: dhowells@redhat.com, sgallagh@redhat.com, rdunlap@infradead.org,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, simo@redhat.com
Subject: [GIT PULL] KEYS: More fixes for next branch
Date: Thu, 14 Nov 2013 18:57:57 +0000
Message-ID: <9945.1384455477@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi James,

Here are some fixes that are needed for the keyrings stuff in your next
branch.  Could you pull them please?

David
---
The following changes since commit 217091dd7a7a1bdac027ddb7c5a25f6ac0b8e241:

  ima: define '_ima' as a builtin 'trusted' keyring (2013-10-31 20:20:48 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git keys-devel

for you to fetch changes up to 62fe318256befbd1b4a6765e71d9c997f768fe79:

  KEYS: Fix keyring content gc scanner (2013-11-14 14:09:53 +0000)

----------------------------------------------------------------
(from the branch description for keys-devel local branch)

Keyrings development
----------------------------------------------------------------
David Howells (4):
      KEYS: The RSA public key algorithm needs to select MPILIB
      KEYS: Fix UID check in keyctl_get_persistent()
      KEYS: Fix error handling in big_key instantiation
      KEYS: Fix keyring content gc scanner

 crypto/asymmetric_keys/Kconfig |  1 +
 security/keys/big_key.c        |  1 +
 security/keys/gc.c             | 42 +--------------------------------------
 security/keys/keyring.c        | 45 ++++++++++++++++++++++++++++++++----------
 security/keys/persistent.c     |  6 ++----
 5 files changed, 40 insertions(+), 55 deletions(-)
