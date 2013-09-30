Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab3I3KNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:13:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43735 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab3I3KNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 078/104] DocBook: upgrade media_api DocBook version to 4.2
Date: Mon, 30 Sep 2013 11:10:55 +0100
Message-Id: <1380535881-9239-79-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Hajda <a.hajda@samsung.com>

commit 8bfd4a68ecc003c1a142f35551be846d6b13e822 upstream.

Fixes the last three errors of media_api DocBook validatation:
(...)
media_api.xml:414: element imagedata: validity error : Value "SVG" for attribute format of imagedata is not among the enumerated set
media_api.xml:432: element imagedata: validity error : Value "SVG" for attribute format of imagedata is not among the enumerated set
media_api.xml:452: element imagedata: validity error : Value "SVG" for attribute format of imagedata is not among the enumerated set
(...)

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 Documentation/DocBook/media_api.tmpl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index 4e8e898..541f22d 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -1,6 +1,6 @@
 <?xml version="1.0"?>
-<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
-	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" [
+<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN"
+	"http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd" [
 <!ENTITY % media-entities SYSTEM "./media-entities.tmpl"> %media-entities;
 <!ENTITY media-indices SYSTEM "./media-indices.tmpl">
 
-- 
1.8.3.2

