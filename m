Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbaCTJja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:39:30 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:33555 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191AbaCTJj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:39:28 -0400
Subject: [PATCH 01/33] Configure and Make files
To: linux-kernel@vger.kernel.org
From: Janani Venkataraman <jananive@linux.vnet.ibm.com>
Cc: amwang@redhat.com, procps@freelists.org, rdunlap@xenotime.net,
        james.hogan@imgtec.com, aravinda@linux.vnet.ibm.com, hch@lst.de,
        mhiramat@redhat.com, jeremy.fitzhardinge@citrix.com,
        xemul@parallels.com, d.hatayama@jp.fujitsu.com, coreutils@gnu.org,
        kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com,
        util-linux@vger.kernel.org, tarundsk@linux.vnet.ibm.com,
        vapier@gentoo.org, roland@hack.frob.com, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, suzuki@linux.vnet.ibm.com, andi@firstfloor.org,
        tj@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Date: Thu, 20 Mar 2014 15:09:09 +0530
Message-ID: <20140320093909.14878.91133.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-7014-0000-0000-0000048ABA30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

configure.ac and automake files for the repository.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 Makefile.am  |    2 ++
 configure.ac |    7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index e69de29..2cc6dc7 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -0,0 +1,2 @@
+AUTOMAKE_OPTIONS = foreign
+SUBDIRS =
diff --git a/configure.ac b/configure.ac
index e69de29..f34a0c3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -0,0 +1,7 @@
+AC_INIT([Gencore], [0.1], [jananive@linux.vnet.ibm.com], [gencore], [])
+LT_INIT()
+AM_INIT_AUTOMAKE([-Wall -Werror foreign])
+AC_CONFIG_HEADERS([config.h])
+AC_PROG_CC
+AC_CONFIG_FILES(Makefile)
+AC_OUTPUT()

