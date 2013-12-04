Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767Ab3LDR5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:57:19 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:58580 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab3LDR5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:57:18 -0500
MIME-Version: 1.0
Date: Wed, 4 Dec 2013 12:57:15 -0500
Message-ID: <CA+X2d=AHdivGF+s_uOC2ns5okoOdZHX1kEg4iuB32zUkBjsszg@mail.gmail.com>
Subject: Re: [PATCHv2] drivers/input/mouse: add support for newer elantech
 touchpads (released ca. August 2013);
From: Matt Walker <matt.g.d.walker@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: backports@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001a11c223deba01c804ecb92415
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c223deba01c804ecb92415
Content-Type: text/plain; charset=ISO-8859-1

From: Matt Walker <matt.g.d.walker@gmail.com>

Added detection for newer Elantech touchpads, so that kernel doesn't
fall-back to default PS/2 driver. Supports touchpads released after
~August 2013.  Fixes bug:
https://lists.launchpad.net/kernel-packages/msg18481.html

Signed-off by: Matt Walker <matt.g.d.walker@gmail.com> on an Acer
Aspire S7-392-6302

----

Thanks to Hauke for the reference on how to submit a patch properly.
Thanks to Dmitry for correction to Signed-off line.

Diff Output:

--- linux-3.13-rc1/drivers/input/
mouse/elantech.c.orig    2013-12-03
12:14:52.829173656 -0500
+++ linux-3.13-rc1/drivers/input/mouse/elantech.c    2013-12-03
12:15:11.833173880 -0500
@@ -1313,6 +1313,7 @@ static int elantech_set_properties(struc
             break;
         case 6:
         case 7:
+        case 8:
             etd->hw_version = 4;
             break;
         default:

--001a11c223deba01c804ecb92415
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hosvo7380

LS0tIGxpbnV4LTMuMTMtcmMxL2RyaXZlcnMvaW5wdXQvbW91c2UvZWxhbnRlY2guYy5vcmlnCTIw
MTMtMTItMDMgMTI6MTQ6NTIuODI5MTczNjU2IC0wNTAwCisrKyBsaW51eC0zLjEzLXJjMS9kcml2
ZXJzL2lucHV0L21vdXNlL2VsYW50ZWNoLmMJMjAxMy0xMi0wMyAxMjoxNToxMS44MzMxNzM4ODAg
LTA1MDAKQEAgLTEzMTMsNiArMTMxMyw3IEBAIHN0YXRpYyBpbnQgZWxhbnRlY2hfc2V0X3Byb3Bl
cnRpZXMoc3RydWMKIAkJCWJyZWFrOwogCQljYXNlIDY6CiAJCWNhc2UgNzoKKwkJY2FzZSA4Ogog
CQkJZXRkLT5od192ZXJzaW9uID0gNDsKIAkJCWJyZWFrOwogCQlkZWZhdWx0Ogo=
--001a11c223deba01c804ecb92415--
