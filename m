Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab3IPNep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:34:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab3IPNen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:34:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Steve French <smfrench@gmail.com>
Cc: Jeff Layton <jlayton@redhat.com>, Sachin Prabhu <sprabhu@redhat.com>,
        dhowells@redhat.com, linux-cifs@vger.kernel.org,
        linux-cachefs@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] CIFS FS-Cache bugfix
Date: Mon, 16 Sep 2013 14:34:40 +0100
Message-ID: <12400.1379338480@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Steve,

Could you pull a CIFS bugfix from my fscache branch?

David
---
The following changes since commit 5a6f282a2052bb13171b53f03b34501cf72c33f1:

  fscache: Netfs function for cleanup post readpages (2013-09-06 09:17:30 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git fscache

for you to fetch changes up to 19ce0a7c9e94ae975e1c029b65b332cbf77b41ec:

  CIFS: FS-Cache: Uncache unread pages in cifs_readpages() before freeing them (2013-09-06 09:17:30 +0100)

----------------------------------------------------------------
David Howells (1):
      CIFS: FS-Cache: Uncache unread pages in cifs_readpages() before freeing them

 fs/cifs/file.c    |  8 ++++++++
 fs/cifs/fscache.c |  7 +++++++
 fs/cifs/fscache.h | 13 +++++++++++++
 3 files changed, 28 insertions(+)
