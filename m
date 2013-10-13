Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3JMQSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 12:18:22 -0400
Received: from sauhun.de ([89.238.76.85]:56482 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831Ab3JMQSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 12:18:20 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Wolfram Sang <wsa@the-dreams.de>, alsa-devel@alsa-project.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-pwm@vger.kernel.org
Subject: [PATCH 0/4] remove devm_pinctrl_get_select_default from drivers
Date: Sun, 13 Oct 2013 18:17:46 +0200
Message-Id: <1381681071-6021-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core does this automatically, no need to do this explicitly in drivers.
Those patchces should go via the respective subtrees. Thanks!


Wolfram Sang (4):
  drivers/gpu/drm/tilcdc: don't use devm_pinctrl_get_select_default() in
    probe
  drivers/mmc/host: don't use devm_pinctrl_get_select_default() in probe
  drivers/pwm: don't use devm_pinctrl_get_select_default() in probe
  sound/soc/atmel: don't use devm_pinctrl_get_select_default() in probe

 drivers/gpu/drm/tilcdc/tilcdc_panel.c  | 6 ------
 drivers/gpu/drm/tilcdc/tilcdc_slave.c  | 6 ------
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c | 6 ------
 drivers/mmc/host/mvsdio.c              | 7 +------
 drivers/mmc/host/omap_hsmmc.c          | 7 -------
 drivers/mmc/host/sdhci-esdhc-imx.c     | 8 --------
 drivers/pwm/pwm-tiecap.c               | 6 ------
 drivers/pwm/pwm-tiehrpwm.c             | 6 ------
 sound/soc/atmel/atmel_wm8904.c         | 8 --------
 9 files changed, 1 insertion(+), 59 deletions(-)

-- 
1.8.4.rc3

