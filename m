Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaGGWdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:33:19 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56018 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaGGWcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:32:03 -0400
X-Originating-IP: 78.210.48.61
From: Guillaume Clement <gclement@baobob.org>
To: Julian Andres Klode <jak@jak-linux.org>, Marc Dietrich <marvin24@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ac100@lists.launchpad.net, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 3/5] staging:nvec: Add missing blank line after declarations.
Date: Tue,  8 Jul 2014 00:31:35 +0200
Message-Id: <1404772297-6549-4-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1404772297-6549-1-git-send-email-gclement@baobob.org>
References: <1404772297-6549-1-git-send-email-gclement@baobob.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guillaume Clément <gclement@baobob.org>
---
 drivers/staging/nvec/nvec_paz00.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/nvec/nvec_paz00.c b/drivers/staging/nvec/nvec_paz00.c
index 934b796..e2e675a 100644
--- a/drivers/staging/nvec/nvec_paz00.c
+++ b/drivers/staging/nvec/nvec_paz00.c
@@ -35,6 +35,7 @@ static void nvec_led_brightness_set(struct led_classdev *led_cdev,
 {
 	struct nvec_led *led = to_nvec_led(led_cdev);
 	unsigned char buf[] = NVEC_LED_REQ;
+
 	buf[4] = value;
 
 	nvec_write_async(led->nvec, buf, sizeof(buf));
-- 
1.8.5.5

