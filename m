Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab3ILSRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:17:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265Ab3ILSPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:15:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 13/16] imx-drm: imx-drm-core: Export imx_drm_encoder_get_mux_id
Date: Thu, 12 Sep 2013 11:15:05 -0700
Message-Id: <20130912181157.635745076@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912181156.173326121@linuxfoundation.org>
References: <20130912181156.173326121@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit ea8d15832016b0d07a8121159904e6b1d21b5b8b upstream.

When building imx_v6_v7_defconfig with imx-drm drivers selected as modules, we
get the following build error:

ERROR: "imx_drm_encoder_get_mux_id" [drivers/staging/imx-drm/imx-ldb.ko] undefined!

Export the required function to avoid this problem.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/imx-drm/imx-drm-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -678,6 +678,7 @@ found:
 
 	return i;
 }
+EXPORT_SYMBOL_GPL(imx_drm_encoder_get_mux_id);
 
 /*
  * imx_drm_remove_encoder - remove an encoder


