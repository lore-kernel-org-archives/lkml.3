Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaJBUpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 16:45:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43726 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751192AbaJBUpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 16:45:54 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: m.chehab@samsung.com, jkosina@suse.cz
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [media] doc: fix broken v4l-utils URL
Date: Thu,  2 Oct 2014 22:45:48 +0200
Message-Id: <1412282748-16204-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces http://git.linuxtv.org/v4l-utils/ (broken link)
by http://git.linuxtv.org/cgit.cgi/v4l-utils.git/

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 Documentation/DocBook/media/v4l/common.xml | 2 +-
 drivers/media/rc/keymaps/Kconfig           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
index 71f6bf9e735e..8b5e014224d6 100644
--- a/Documentation/DocBook/media/v4l/common.xml
+++ b/Documentation/DocBook/media/v4l/common.xml
@@ -110,7 +110,7 @@ makes no provisions to find these related devices. Some really
 complex devices use the Media Controller (see <xref linkend="media_controller" />)
 which can be used for this purpose. But most drivers do not use it,
 and while some code exists that uses sysfs to discover related devices
-(see libmedia_dev in the <ulink url="http://git.linuxtv.org/v4l-utils/">v4l-utils</ulink>
+(see libmedia_dev in the <ulink url="http://git.linuxtv.org/cgit.cgi/v4l-utils.git/">v4l-utils</ulink>
 git repository), there is no library yet that can provide a single API towards
 both Media Controller-based devices and devices that do not use the Media Controller.
 If you want to work on this please write to the linux-media mailing list: &v4l-ml;.</para>
diff --git a/drivers/media/rc/keymaps/Kconfig b/drivers/media/rc/keymaps/Kconfig
index 8e615fd55852..767423bbbdd0 100644
--- a/drivers/media/rc/keymaps/Kconfig
+++ b/drivers/media/rc/keymaps/Kconfig
@@ -12,4 +12,4 @@ config RC_MAP
 	   The ir-keytable program, available at v4l-utils package
 	   provide the tool and the same RC maps for load from
 	   userspace. Its available at
-			http://git.linuxtv.org/v4l-utils
+		http://git.linuxtv.org/cgit.cgi/v4l-utils.git/
-- 
1.9.1

