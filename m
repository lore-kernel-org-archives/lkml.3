Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbaCDVMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:12:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424AbaCDUDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13 087/172] ASoC: rt5640: Add ACPI ID for Intel Baytrail
Date: Tue,  4 Mar 2014 12:02:51 -0800
Message-Id: <20140304200302.509171954@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

commit b31b2b6d5de71c569413d8dc4f7b050cbe25a09e upstream.

Realtek RT5640 uses ACPI ID "10EC5640" for Intel Baytrail platforms.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/rt5640.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2093,6 +2093,7 @@ MODULE_DEVICE_TABLE(i2c, rt5640_i2c_id);
 #ifdef CONFIG_ACPI
 static struct acpi_device_id rt5640_acpi_match[] = {
 	{ "INT33CA", 0 },
+	{ "10EC5640", 0 },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, rt5640_acpi_match);


