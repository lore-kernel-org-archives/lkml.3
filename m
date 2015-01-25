Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbbAYS2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:28:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbbAYSK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yi ju Hong <sam.hung@emc.com.tw>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.18 158/183] Input: elantech - support new ICs types for version 4
Date: Sun, 25 Jan 2015 10:08:00 -0800
Message-Id: <20150125180817.046974729@linuxfoundation.org>
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

From: Sam hung <sam.hung@emc.com.tw>

commit 810aa0918b2b032684c8cad13f73d6ba37ad11c0 upstream.

This change allows the driver to recognize newer Elantech touchpads.

Signed-off-by: Yi ju Hong <sam.hung@emc.com.tw>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/elantech.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1520,6 +1520,8 @@ static int elantech_set_properties(struc
 		case 7:
 		case 8:
 		case 9:
+		case 10:
+		case 13:
 			etd->hw_version = 4;
 			break;
 		default:


