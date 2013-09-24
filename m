Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3IXIsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:48:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab3IXIsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:48:33 -0400
From: Weiping Pan <wpan@redhat.com>
To: linux-mm@kvack.org
Cc: rob@landley.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH resend] typo: replace kernelcore with Movable
Date: Tue, 24 Sep 2013 16:48:14 +0800
Message-Id: <a1714d6a349ac584626a164631c5e2b74d91326d.1380012101.git.wpan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Han Pingtian found a typo in Documentation/kernel-parameters.txt
about "kernelcore=", that "kernelcore" should be replaced with "Movable" here.

I sent this patch a 8 months ago and got ack from Mel Gorman,
http://marc.info/?l=linux-mm&m=135756720602638&w=2
but it has not been merged so I resent it again.

Signed-off-by: Weiping Pan <wpan@redhat.com>
---
 Documentation/kernel-parameters.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1a036cd9..c3ea235 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1357,7 +1357,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			pages. In the event, a node is too small to have both
 			kernelcore and Movable pages, kernelcore pages will
 			take priority and other nodes will have a larger number
-			of kernelcore pages.  The Movable zone is used for the
+			of Movable pages.  The Movable zone is used for the
 			allocation of pages that may be reclaimed or moved
 			by the page migration subsystem.  This means that
 			HugeTLB pages may not be allocated from this zone.
-- 
1.7.4

