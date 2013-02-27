Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab3B0GKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 01:10:45 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:56226 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab3B0GHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 01:07:34 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: mchehab@redhat.com
Cc: andrew.smirnov@gmail.com, hverkuil@xs4all.nl, sameo@linux.intel.com,
        sam@ravnborg.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 5/9] v4l2: Fix the type of V4L2_CID_TUNE_PREEMPHASIS in the documentation
Date: Tue, 26 Feb 2013 22:06:49 -0800
Message-Id: <1361945213-4280-6-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361945213-4280-1-git-send-email-andrew.smirnov@gmail.com>
References: <1361945213-4280-1-git-send-email-andrew.smirnov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the type of V4L2_CID_TUNE_PREEMPHASIS from 'integer' to 'enum
v4l2_preemphasis'

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Singed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
---
 Documentation/DocBook/media/v4l/controls.xml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 9e8f854..1ad20cc 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3848,7 +3848,7 @@ in Hz. The range and step are driver-specific.</entry>
 	  </row>
 	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_TUNE_PREEMPHASIS</constant>&nbsp;</entry>
-	    <entry>integer</entry>
+	    <entry>enum v4l2_preemphasis</entry>
 	  </row>
 	  <row id="v4l2-preemphasis"><entry spanname="descr">Configures the pre-emphasis value for broadcasting.
 A pre-emphasis filter is applied to the broadcast to accentuate the high audio frequencies.
-- 
1.7.10.4

