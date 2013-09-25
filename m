Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab3IYBA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:00:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab3IYAQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [ 077/110] media: DocBook: upgrade media_api DocBook version to 4.2
Date: Tue, 24 Sep 2013 17:15:15 -0700
Message-Id: <20130925001331.755316462@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/DocBook/media_api.tmpl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
 


