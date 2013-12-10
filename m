Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab3LJHOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:14:24 -0500
Received: from ozlabs.org ([203.10.76.45]:57584 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab3LJHOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:14:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "David Howells" <dhowells@redhat.com>
Subject: [PATCH] Ignore generated file kernel/x509_certificate_list
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 10 Dec 2013 17:42:50 +1030
Message-ID: <87fvq1ji19.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ git status
# On branch pending-rebases
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#	kernel/x509_certificate_list
nothing added to commit but untracked files present (use "git add" to track)
$ 

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/.gitignore b/kernel/.gitignore
index b3097bde4e9c..790d83c7d160 100644
--- a/kernel/.gitignore
+++ b/kernel/.gitignore
@@ -5,3 +5,4 @@ config_data.h
 config_data.gz
 timeconst.h
 hz.bc
+x509_certificate_list
