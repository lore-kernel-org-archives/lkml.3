Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab3APAcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:32:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:41542 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757792Ab3AOW2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:28:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [ 051/221] mfd: wm8994: Add support for WM1811 rev E
Date: Tue, 15 Jan 2013 10:49:38 -0800
Message-Id: <20130115185001.709162032@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -557,6 +557,7 @@ static __devinit int wm8994_device_init(
 		case 1:
 		case 2:
 		case 3:
+		case 4:
 			regmap_patch = wm1811_reva_patch;
 			patch_regs = ARRAY_SIZE(wm1811_reva_patch);
 			break;


