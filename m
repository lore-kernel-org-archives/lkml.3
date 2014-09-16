Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaIPN35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:29:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbaIPN3y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:29:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: James Morris <jmorris@namei.org>
cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KEYS: Fixes for keyrings
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23654.1410874187.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Tue, 16 Sep 2014 14:29:47 +0100
Message-ID: <23655.1410874187@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Can you please pull these fixes and send them on upstream:

 (1) Reinstate the production of EPERM for key types beginning with '.' in
     requests from userspace.

 (2) Tidy up the cleanup of PKCS#7 message signed information blocks and fix a
     bug this made more obvious.

David
---
The following changes since commit 2324067fa9a41b2d0b6ddbc7ac0497d105593b76:

  Merge tag 'regmap-v3.17-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap (2014-09-15 16:20:56 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-fixes-20140916

for you to fetch changes up to 553619918a85dd66a24059b95a4f5625502f2df7:

  PKCS#7: Fix the parser cleanup to drain parsed out X.509 certs (2014-09-16 14:18:28 +0100)

----------------------------------------------------------------
(from the branch description for keys-fixes local branch)

Keyrings fixes
Keyrings fixes

----------------------------------------------------------------
David Howells (3):
      KEYS: Reinstate EPERM for a key type name beginning with a '.'
      PKCS#7: Provide a single place to do signed info block freeing
      PKCS#7: Fix the parser cleanup to drain parsed out X.509 certs

 crypto/asymmetric_keys/pkcs7_parser.c | 61 +++++++++++++++++++----------------
 security/keys/keyctl.c                |  2 ++
 2 files changed, 35 insertions(+), 28 deletions(-)
