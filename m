Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaHTG4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:56:12 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:60605 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaHTG4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:56:08 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Thierry Reding <thierry.reding@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Tony Prisk <linux@prisktech.co.nz>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv4 0/4] pwm: imx: support output polarity inversion
Date: Wed, 20 Aug 2014 08:55:52 +0200
Message-Id: <1408517756-9412-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for polarity inversion to the pwm-imx
driver. The patches have been tested on i.MX6, i.MX53 and with the
ti-ehrpwm.c driver.

Changes wrt. v2:
- make the use of '#pwm-cells = <3>' optional, so that the change does
  not break existing DT blobs as suggested by Arnd Bergmann and Sascha
  Hauer.

Changes wrt. v3:
- implemented the approach suggested by Sascha Hauer 
- don't modify struct pwm_ops in the imx_pwm probe function


