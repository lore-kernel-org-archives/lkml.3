Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbaAHLlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:41:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106AbaAHLlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:41:12 -0500
Date: Wed, 8 Jan 2014 19:41:37 +0800
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: README: update about .tar.xz format
Message-ID: <20140108114137.GA19456@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel.org do not provide .bz2 for downloading, see below:
https://www.kernel.org/happy-new-year-and-good-bye-bzip2.html

Thus update README about using xz format.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 README |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux.orig/README
+++ linux/README
@@ -66,7 +66,7 @@ INSTALLING the kernel source:
 
    or
 
-     bzip2 -dc linux-3.X.tar.bz2 | tar xvf -
+     xz -dc linux-3.X.tar.xz | tar xvf -
 
    Replace "X" with the version number of the latest kernel.
 
@@ -76,7 +76,7 @@ INSTALLING the kernel source:
    whatever the kernel-du-jour happens to be.
 
  - You can also upgrade between 3.x releases by patching.  Patches are
-   distributed in the traditional gzip and the newer bzip2 format.  To
+   distributed in the traditional gzip and the newer xz format.  To
    install by patching, get all the newer patch files, enter the
    top level directory of the kernel source (linux-3.X) and execute:
 
@@ -84,7 +84,7 @@ INSTALLING the kernel source:
 
    or
 
-     bzip2 -dc ../patch-3.x.bz2 | patch -p1
+     xz -dc ../patch-3.x.xz | patch -p1
 
    Replace "x" for all versions bigger than the version "X" of your current
    source tree, _in_order_, and you should be ok.  You may want to remove
