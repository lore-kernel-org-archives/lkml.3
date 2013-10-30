Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab3J3NIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:08:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab3J3NIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:08:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, gang.chen@asianux.com,
        yongjun_wei@trendmicro.com.cn, sgallagh@redhat.com,
        jwboyer@fedoraproject.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KEYS: Fixes for next branch
Date: Wed, 30 Oct 2013 13:08:40 +0000
Message-ID: <30717.1383138520@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi James,

Could you pull these five commits into your next branch?  They are a set of
fixes, some for the commits you have there and some for the upstream kernel.

David
---
The following changes since commit 50b719f811583a47762ecb7e480d253abc2eb22f:

  Merge branch 'smack-for-3.13' of git://git.gitorious.org/smack-next/kernel into ra-next (2013-10-30 14:07:10 +1100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git keys-devel

for you to fetch changes up to 6ef4d2eaf5a46d4ab6db02612b5e883b834017b8:

  kernel/system_certificate.S: use real contents instead of macro GLOBAL() (2013-10-30 12:58:00 +0000)

----------------------------------------------------------------
(from the branch description for keys-devel local branch)

clone of "master"
----------------------------------------------------------------
Chen Gang (1):
      kernel/system_certificate.S: use real contents instead of macro GLOBAL()

David Howells (2):
      KEYS: Fix a race between negating a key and reading the error set
      KEYS: Fix keyring quota misaccounting on key replacement and unlink

Josh Boyer (1):
      KEYS: Make BIG_KEYS boolean

Wei Yongjun (1):
      KEYS: fix error return code in big_key_instantiate()

 kernel/system_certificates.S | 10 ++++------
 security/keys/Kconfig        |  2 +-
 security/keys/big_key.c      |  4 +++-
 security/keys/key.c          |  3 ++-
 security/keys/keyring.c      | 28 ++++++++++++++++------------
 security/keys/request_key.c  |  4 +++-
 6 files changed, 29 insertions(+), 22 deletions(-)
