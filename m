Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934776Ab3E1QLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 12:11:24 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54499 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934726Ab3E1QLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 12:11:23 -0400
MIME-Version: 1.0
Date: Tue, 28 May 2013 11:11:22 -0500
Message-ID: <CAH2r5muTx5hxSDQxBe1H8dN9FArSOOY4w63DicpXWBb__V0hMQ@mail.gmail.com>
Subject: [GIT] CIFS FIxes
From: Steve French <smfrench@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes for a couple of DFS problems, a problem with extended security
negotiation and two other small cifs fixes.

The following changes since commit 62106e96279f66c52e2123782f9420af9dbe8cbe:

  cifs: only set ops for inodes in I_NEW state (2013-05-24 12:55:39 -0500)

are available in the git repository at:
  git://git.samba.org/sfrench/cifs-2.6.git for-3.10

Jeff Layton (5):
      cifs: fix potential buffer overrun when composing a new options string
      cifs: allow sec=none mounts to work against servers that don't
support extended security
      cifs: fix error handling when calling cifs_parse_devname
      cifs: stop printing the unc= option in /proc/mounts
      cifs: fix composing of mount options for DFS referrals

 fs/cifs/cifs_dfs_ref.c |  141 ++++++++++++++++++++++++-----------------------
 fs/cifs/cifsfs.c       |    3 -
 fs/cifs/connect.c      |   23 +++++---
 fs/cifs/dns_resolve.c  |    4 +-
 4 files changed, 88 insertions(+), 83 deletions(-)


--
Thanks,

Steve
