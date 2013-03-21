Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab3CUWlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:41:19 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:34882 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab3CUWlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 18:41:18 -0400
MIME-Version: 1.0
Date: Thu, 21 Mar 2013 17:41:17 -0500
Message-ID: <CAH2r5msOBKtD1QSoToLNbR0Uvf=z2f41+BRcxqm3fd8f1EE5jw@mail.gmail.com>
Subject: [GIT] CIFS Fixes
From: Steve French <smfrench@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3 small CIFS Fixes (the most important of the three fixes a recent
problem authenticating
to Windows 8 using cifs rather than SMB2)

The following changes since commit 6c23cbbd5056b155401b0a2b5567d530e6c750c4:
  Randy Dunlap (1):
        futex: fix kernel-doc notation and spello

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

Jeff Layton (1):
      cifs: ignore everything in SPNEGO blob after mechTypes

Mateusz Guzik (1):
      cifs: delay super block destruction until all cifsFileInfo
objects are gone

Sachin Prabhu (1):
      cifs: map NT_STATUS_SHARING_VIOLATION to EBUSY instead of ETXTBSY

 fs/cifs/asn1.c    |   53 +++++------------------------------------------------
 fs/cifs/cifsfs.c  |   24 ++++++++++++++++++++++++
 fs/cifs/cifsfs.h  |    4 ++++
 fs/cifs/file.c    |    6 +++++-
 fs/cifs/inode.c   |   10 ++++------
 fs/cifs/netmisc.c |    2 +-
 6 files changed, 43 insertions(+), 56 deletions(-)

-- 
Thanks,

Steve
