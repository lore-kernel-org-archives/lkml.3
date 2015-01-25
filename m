Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbbAYSnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:43:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbbAYSKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dominique Leuenberger <dimstar@opensuse.org>,
        Takashi Iwai <tiwai@suse.de>, Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 3.18 064/183] hp_accel: Add support for HP ZBook 15
Date: Sun, 25 Jan 2015 10:06:26 -0800
Message-Id: <20150125180812.958039600@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Leuenberger <dimstar@opensuse.org>

commit 6583659e0f92e38079a8dd081e0a1181a0f37747 upstream.

HP ZBook 15 laptop needs a non-standard mapping (x_inverted).

BugLink: http://bugzilla.opensuse.org/show_bug.cgi?id=905329
Signed-off-by: Dominique Leuenberger <dimstar@opensuse.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/hp_accel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -246,6 +246,7 @@ static const struct dmi_system_id lis3lv
 	AXIS_DMI_MATCH("HPB64xx", "HP ProBook 64", xy_swap),
 	AXIS_DMI_MATCH("HPB64xx", "HP EliteBook 84", xy_swap),
 	AXIS_DMI_MATCH("HPB65xx", "HP ProBook 65", x_inverted),
+	AXIS_DMI_MATCH("HPZBook15", "HP ZBook 15", x_inverted),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"


