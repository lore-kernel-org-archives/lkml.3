Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaFMOTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:19:54 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:44674
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaFMOTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:19:52 -0400
Date: Fri, 13 Jun 2014 16:19:50 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, zohar@linux.vnet.ibm.com,
        akpm@linux-foundation.org, linux-security-module@vger.kernel.org
Subject: [security-next] Pull request (merge window)
Message-ID: <20140613141950.GA3995@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A few more commits had previously failed to make it through security-next
into linux-next but this week made it into linxu-next.  At least commit
"ima: introduce ima_kernel_read()" was deemed critical by Mimi to make
this merge window.

This is a temporary tree just for this request.  Mimi has pointed me to
some previous threads about keeping maintainer trees at the previous
release, which I'll certainly do for anything long-term, after talking
with James.

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The following changes since commit 0e04c641b199435f3779454055f6a7de258ecdfc:

  Merge tag 'dm-3.16-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm (2014-06-12 13:33:29 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/sergeh/linux-security serge-next-2

for you to fetch changes up to 0430e49b6e7c6b5e076be8fefdee089958c9adad:

  ima: introduce ima_kernel_read() (2014-06-12 17:58:08 -0400)

- ----------------------------------------------------------------
Dmitry Kasatkin (5):
      evm: replace HMAC version with attribute mask
      evm: provide option to protect additional SMACK xattrs
      ima: prevent unnecessary policy checking
      ima: check inode integrity cache in violation check
      ima: introduce ima_kernel_read()

Mimi Zohar (2):
      ima: prevent new digsig xattr from being replaced
      evm: prohibit userspace writing 'security.evm' HMAC value

 security/integrity/evm/Kconfig        | 42 ++++++++++++++++++++++++++++-------
 security/integrity/evm/evm.h          |  5 ++++-
 security/integrity/evm/evm_crypto.c   |  2 +-
 security/integrity/evm/evm_main.c     | 29 +++++++++++++++++++++---
 security/integrity/ima/ima_appraise.c | 10 ++++++---
 security/integrity/ima/ima_crypto.c   | 32 +++++++++++++++++++++++++-
 security/integrity/ima/ima_main.c     | 22 +++++++++---------
 7 files changed, 114 insertions(+), 28 deletions(-)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJTmwUGAAoJELF1z6mPGSryM5EIAKrW054UihG58o+efleMBqpk
Tur6eoFyFOjRlU0iRRjSyZpvNjGVsaEe46rBfrXkdV4D6lgPhAwCyUVkQGyHjetd
MbK1o17I4gHqQK2rHa5fkIGmWEzoRART32WJuCHrniIZJ+fv2vn1S2Veb1ei0Q+a
PyUHsvWdcmSsqA0wCcAaBSNekjdi+Wrs35OrHI2+SMdpTbTGJJdgOLtNzBMYLid6
cSGoarLC+ST1rJWxSI5hsaDnzgURUWk9dElzQCcEeSa0924mKBa4t0EwUmeaUQC9
kB3RGMS3OJEFwTxJXfSRolprftWEYkKd+3ovLE+P/Kp+0ZsJ74ohCCbk/5x6CMQ=
=eBeq
-----END PGP SIGNATURE-----
