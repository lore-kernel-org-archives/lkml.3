Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428AbaGYMbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:31:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760092AbaGYMbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:31:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: James Morris <jmorris@namei.org>, sfr@canb.auug.org.au
cc: dhowells@redhat.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        mimi.e.zohar@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        vgoyal@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Keyrings: PKCS#7 fixup
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22573.1406291448.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Fri, 25 Jul 2014 13:30:48 +0100
Message-ID: <22574.1406291448@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Here's a fixup for the problem that Stephen spotted.

David
---
The following changes since commit 633706a2ee81637be37b6bc02c5336950cc163b5:

  Merge branch 'keys-fixes' into keys-next (2014-07-22 21:55:45 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-next-20140725

for you to fetch changes up to 8f3438ccea149647ad1849651d1e14c7b8b85e63:

  PKCS#7: Missing inclusion of linux/err.h (2014-07-25 11:33:53 +0100)

----------------------------------------------------------------
(from the branch description for keys-next local branch)

Keyrings for linux-next
Keyrings patches

----------------------------------------------------------------
David Howells (1):
      PKCS#7: Missing inclusion of linux/err.h

 crypto/asymmetric_keys/pkcs7_key_type.c | 1 +
 1 file changed, 1 insertion(+)
