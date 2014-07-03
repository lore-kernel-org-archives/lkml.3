Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbaGCTP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 15:15:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbaGCTPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 15:15:25 -0400
Date: Thu, 3 Jul 2014 12:19:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Konstantin Ryabitsev <mricon@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH kernel.org] Add 3.14 to list of longterm stable kernels
Message-ID: <20140703191937.GA26066@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm going to be maintaining the 3.14 kernel as a "longterm" kernel for
the next two years, so mention that on the kernel.org site.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/content/releases.rst b/content/releases.rst
index d25137e142cb..f3b0f7b92713 100644
--- a/content/releases.rst
+++ b/content/releases.rst
@@ -40,6 +40,7 @@ Longterm
     ======== ==================== ============ ==================
     Version  Maintainer           Released     Projected EOL
     ======== ==================== ============ ==================
+    3.14     Greg Kroah-Hartman   2014-03-30   August 2016
     3.12     Jiri Slaby           2013-11-03   2016
     3.10     Greg Kroah-Hartman   2013-06-30   Sep, 2015
     3.4      Greg Kroah-Hartman   2012-05-20   Oct, 2014
