Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbaG3CGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:06:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbaG3Btn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.14 15/29] Input: synaptics - add min/max quirk for pnp-id LEN2002 (Edge E531)
Date: Tue, 29 Jul 2014 18:48:50 -0700
Message-Id: <20140730014809.975171551@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014809.316066303@linuxfoundation.org>
References: <20140730014809.316066303@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit e76aed9da7189eeb41b9856552ce5721181e8e8d upstream.

https://bugzilla.redhat.com/show_bug.cgi?id=1114768

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -132,7 +132,8 @@ static const struct min_max_quirk min_ma
 		1232, 5710, 1156, 4696
 	},
 	{
-		(const char * const []){"LEN0034", "LEN0036", "LEN2004", NULL},
+		(const char * const []){"LEN0034", "LEN0036", "LEN2002",
+					"LEN2004", NULL},
 		1024, 5112, 2024, 4832
 	},
 	{
@@ -168,7 +169,7 @@ static const char * const topbuttonpad_p
 	"LEN0049",
 	"LEN2000",
 	"LEN2001", /* Edge E431 */
-	"LEN2002",
+	"LEN2002", /* Edge E531 */
 	"LEN2003",
 	"LEN2004", /* L440 */
 	"LEN2005",


