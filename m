Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaAQO57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:57:59 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:33935 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaAQO5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:57:53 -0500
Date: Fri, 17 Jan 2014 09:57:49 -0500
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH driver-core-next 1/2] kernfs: add struct dentry declaration
 in kernfs.h
Message-ID: <20140117145749.GC8598@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

Two misc fixes for kernfs.

Thanks.
------- 8< -------
struct dentry is used in kernfs.h but its declaration was missing,
leading to compilation errors unless its declaration gets pulled in in
some other way.  Add the declaration.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/kernfs.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -18,6 +18,7 @@
 #include <linux/completion.h>
 
 struct file;
+struct dentry;
 struct iattr;
 struct seq_file;
 struct vm_area_struct;
