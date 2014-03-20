Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304AbaCTJnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:43:47 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:41601 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206AbaCTJnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:43:40 -0400
Subject: [PATCH 30/33] README, COPYING, Changelog
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
Date: Thu, 20 Mar 2014 15:13:18 +0530
Message-ID: <20140320094318.14878.36127.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-6102-0000-0000-0000052BBE15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the README, COPYING and ChangeLog for the package.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 COPYING            |   24 ++++++++++++
 COPYING.LIBGENCORE |   24 ++++++++++++
 Changelog          |    7 +++
 README             |  108 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 163 insertions(+)
 create mode 100644 COPYING
 create mode 100644 COPYING.LIBGENCORE
 create mode 100644 Changelog
 create mode 100644 README

diff --git a/COPYING b/COPYING
new file mode 100644
index 0000000..a4163ed
--- /dev/null
+++ b/COPYING
@@ -0,0 +1,24 @@
+-------
+GENCORE
+-------
+
+Gencore produces a coredump of a process non-disruptively
+
+Copyright (C) IBM Corporation, 2013 
+
+Authors:
+	Janani Venkataraman <jananive@in.ibm.com>
+
+This package is free software: you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation, either version 3 of the License, or
+(at your option) any later version.
+
+This package is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+You should have received a copy of the GNU General Public License
+along with this program; if not, write to the Free Software Foundation,
+Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
diff --git a/COPYING.LIBGENCORE b/COPYING.LIBGENCORE
new file mode 100644
index 0000000..e1a7bf6
--- /dev/null
+++ b/COPYING.LIBGENCORE
@@ -0,0 +1,24 @@
+----------
+LIBGENCORE
+----------
+
+Libencore sets up the interface for requesting a selfdump.
+
+Copyright (C) IBM Corporation, 2013 
+
+Authors:
+	Janani Venkataraman <jananive@in.ibm.com>
+
+This package is free software: you can redistribute it and/or modify
+it under the terms of the GNU Lesser General Public License as published by
+the Free Software Foundation, either version 3 of the License, or
+(at your option) any later version.
+
+This package is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU Lesser General Public License for more details.
+
+You should have received a copy of the GNU Lesser General Public License
+along with this program; if not, write to the Free Software Foundation,
+Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
diff --git a/Changelog b/Changelog
new file mode 100644
index 0000000..0c780ca
--- /dev/null
+++ b/Changelog
@@ -0,0 +1,7 @@
+---------
+Changelog
+---------
+
+* Thursday Dec 19 2013 Janani Venkataraman <jananive@linux.vnet.ibm.com> 1.0
+
+- Initial Version
diff --git a/README b/README
new file mode 100644
index 0000000..2935ddb
--- /dev/null
+++ b/README
@@ -0,0 +1,108 @@
+-----------------------------------------------
+How to build and install the package -- src.rpm
+-----------------------------------------------
+
+a) Download the gencore-0.1-0.src.rpm
+b) Rebuild the src.rpm using the following command:
+	rpmbuild --rebuild gencore-0.1-0.src.rpm
+c) In the rpmbuild folder created install the RPMs in RPMS folder
+   through the following command:
+	rpm -ivh gencore-0.1-0.x86_64.rpm gencore-debuginfo-0.1-0.x86_64.rpm libgencore-0.1-0.x86_64.rpm libgencore-devel-0.1-0.x86_64.rpm
+c) The library and executables will be installed in /usr/bin
+   and /usr/lib64 and the daemon will be started automatically.
+
+----------------------------------------------
+How to build and install the package -- tar.gz
+----------------------------------------------
+
+a) Untar it firstly
+b) ./autoreconf --force --install
+c) ./configure --prefix="path"
+d) make
+e) make install
+
+The executable the the client libraries are installed in the path specified by
+the user.
+
+--------------------------------
+Command Line Arguments - gencore
+--------------------------------
+
+We can call the gencore command in two ways.
+a) gencore pid [output-file-name]
+b) gencore --daemon 
+   -- Creates a daemon, for aiding selfdumps.
+c) gencore --socket
+   -- Post installation, systemd will create the socket and listen for connections.
+      Once a process requests a selfdump, the service will be spawned to handle
+      the request. For this we need to have the correct version of systemd which
+      has this socket option enabled.
+
+In the first case, gencore performs a third party dump and we can specify the
+PID of the process to be dumped. The output-filename is optional. If not 
+specified, by default the core filename is core.pid and it is created in the CWD.
+
+In the second case, we start a daemon and we wait for requests from processes
+which requires a self dump. This daemon keeping waiting for such requests.
+It can handle multiple requests for the dump. This method was adapted from the
+CRIU self dump application.
+
+A process which wants a dump, uses the libgencore library and calls the function
+gencore(char *corefile).
+
+----------------------------------
+libgencore - gencore() -- selfdump
+----------------------------------
+
+A program can request a dump of itself. Such a dump is known as a self dump.
+This can be done by using the library libgencore and calling the function
+gencore(char *corefile).
+
+For a selfdump, we need to first start gencore --daemon like mentioned before.
+This daemon waits for requests for dumps. This is already done post installation.
+
+Then in the process, which requests for a dump, we need to call the function 
+gencore(char *absolute/relative pathname);
+
+We use libgencore library to set up this interface.
+
+eg. test.c
+
+#include <dlfcn.h>
+#include <stdio.h>
+#include <string.h>
+#include <signal.h>
+
+int (*gencore)(char *name);
+
+void segv_handler(int signo)
+{
+	int ret;
+
+	ret = gencore("/home/janani/demo/test_core");
+
+	fprintf(stderr, "Status of dump: %s\n", strerror(ret)); 	
+}
+	
+int main ()
+{
+	void *lib;
+
+	signal(SIGSEGV, segv_handler);
+	
+	/* Opening the library, in this case the library is present in the /usr/lib64 */
+	lib = dlopen("libgencore.so", RTLD_LAZY);
+
+	gencore = dlsym(lib, "gencore");
+
+	sleep(100);
+
+	return 0;
+}
+
+-------
+AUTHORS
+-------
+
+Janani Venkataraman <jananive@in.ibm.com>
+

