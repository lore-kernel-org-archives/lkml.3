Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893Ab3AOXyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:54:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:45630 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758804Ab3AOWtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:49:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [ 026/171] mfd: wm8994: Add support for WM1811 rev E
Date: Tue, 15 Jan 2013 14:43:11 -0800
Message-Id: <20130115224315.282873150@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit fee546ce8cfd9dea1f53175f627e17ef5ff05df4 upstream.

This is supported identically to the previous revisions.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/wm8994-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -541,6 +541,7 @@ static __devinit int wm8994_device_init(
 		case 1:
 		case 2:
 		case 3:
+		case 4:
 			regmap_patch = wm1811_reva_patch;
 			patch_regs = ARRAY_SIZE(wm1811_reva_patch);
 			break;


