Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaAXFcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 00:32:10 -0500
Received: from linuxhacker.ru ([217.76.32.60]:44284 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaAXFbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 00:31:44 -0500
X-Greylist: delayed 2738 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jan 2014 00:31:40 EST
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 5/5] lustre: add myself to list of people to CC on lustre patches
Date: Thu, 23 Jan 2014 23:45:08 -0500
Message-Id: <1390538708-4120-6-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390538708-4120-1-git-send-email-green@linuxhacker.ru>
References: <1390538708-4120-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/TODO | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/TODO b/drivers/staging/lustre/TODO
index 22742d6..0a2b6cb 100644
--- a/drivers/staging/lustre/TODO
+++ b/drivers/staging/lustre/TODO
@@ -9,5 +9,6 @@
 * Other minor misc cleanups...
 
 Please send any patches to Greg Kroah-Hartman <greg@kroah.com>, Andreas Dilger
-<andreas.dilger@intel.com> and Peng Tao <tao.peng@emc.com>. CCing
-hpdd-discuss <hpdd-discuss@lists.01.org> would be great too.
+<andreas.dilger@intel.com>, Oleg Drokin <oleg.drokin@intel.com> and
+Peng Tao <tao.peng@emc.com>. CCing hpdd-discuss <hpdd-discuss@lists.01.org>
+would be great too.
-- 
1.8.5.3

