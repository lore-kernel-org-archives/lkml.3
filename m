Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaAWNYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:24:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbaAWNYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:24:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] assoc_array: remove global variable
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
Cc: Stephen Hemminger <stephen@networkplumber.org>, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Thu, 23 Jan 2014 13:24:09 +0000
Message-ID: <20140123132409.17426.59582.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemming@brocade.com>

The associative array code creates unnecessary and potentially problematic
global variable 'status'. Remove it since never used.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 lib/assoc_array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index 1b6a44f1ec3e..c0b1007011e1 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -157,7 +157,7 @@ enum assoc_array_walk_status {
 	assoc_array_walk_tree_empty,
 	assoc_array_walk_found_terminal_node,
 	assoc_array_walk_found_wrong_shortcut,
-} status;
+};
 
 struct assoc_array_walk_result {
 	struct {

