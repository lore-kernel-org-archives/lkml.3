Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaAWJFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 04:05:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50269 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaAWJF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 04:05:28 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Cc: linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] pwm: imx: support polarity inversion
Date: Thu, 23 Jan 2014 10:04:56 +0100
Message-Id: <1390467898-9216-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <20140123083714.3c6e86ae@ipc1.ka-ro>
References: <20140123083714.3c6e86ae@ipc1.ka-ro>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thinking more of the following. I haven't tested it, but it has a negative
diffstat, so it must be good ;)

Sascha

----------------------------------------------------------------
Sascha Hauer (2):
      PWM: let of_xlate handlers check args count
      PWM: handle additional flags in of_pwm_simple_xlate

 drivers/pwm/core.c            | 41 +++++++----------------------------------
 drivers/pwm/pwm-atmel-tcb.c   |  2 --
 drivers/pwm/pwm-renesas-tpu.c |  2 --
 drivers/pwm/pwm-samsung.c     |  3 ---
 drivers/pwm/pwm-tiecap.c      |  2 --
 drivers/pwm/pwm-tiehrpwm.c    |  2 --
 drivers/pwm/pwm-vt8500.c      |  2 --
 include/linux/pwm.h           |  3 ---
 8 files changed, 7 insertions(+), 50 deletions(-)
