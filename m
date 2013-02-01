Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3BAPlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 10:41:10 -0500
Received: from mail.kernel.org ([198.145.19.201]:50238 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab3BAPlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 10:41:05 -0500
Date: Fri, 1 Feb 2013 16:43:06 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] SubmittingPatches: add penalty for forcing a maintainer to
 edit a patch
Message-ID: <20130201154306.GA28473@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Maintainers have to hand-edit patches (body of patches and changelog
entries) all the time.  There needs to be some kind of penalty put into
place to keep developers from abusing maintainers.

Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index c379a2a..d1bec01 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -93,7 +93,9 @@ includes updates for subsystem X.  Please apply."
 
 The maintainer will thank you if you write your patch description in a
 form which can be easily pulled into Linux's source code management
-system, git, as a "commit log".  See #15, below.
+system, git, as a "commit log".  See #15, below.  If the maintainer has
+to hand-edit your patch, you owe them the beverage of their choice the
+next time you see them.
 
 If your description starts to get long, that's a sign that you probably
 need to split up your patch.  See #3, next.
