Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591AbbAYTYm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:24:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbbAYSJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dominique Leuenberger <dimstar@opensuse.org>,
        Takashi Iwai <tiwai@suse.de>, Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 3.14 32/98] hp_accel: Add support for HP ZBook 15
Date: Sun, 25 Jan 2015 10:06:50 -0800
Message-Id: <20150125180714.264515853@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -237,6 +237,7 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("HPB64xx", "HP ProBook 64", xy_swap),
 	AXIS_DMI_MATCH("HPB64xx", "HP EliteBook 84", xy_swap),
 	AXIS_DMI_MATCH("HPB65xx", "HP ProBook 65", x_inverted),
+	AXIS_DMI_MATCH("HPZBook15", "HP ZBook 15", x_inverted),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"


