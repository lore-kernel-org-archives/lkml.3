Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab3DVJZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 05:25:13 -0400
Received: from ozlabs.org ([203.10.76.45]:37640 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490Ab3DVJZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 05:25:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "lkml" <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] kernel/hz.bc: ignore.
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 22 Apr 2013 18:51:50 +0930
Message-ID: <87zjwqgbtd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/.gitignore b/kernel/.gitignore
index ab4f109..b3097bd 100644
--- a/kernel/.gitignore
+++ b/kernel/.gitignore
@@ -4,3 +4,4 @@
 config_data.h
 config_data.gz
 timeconst.h
+hz.bc
