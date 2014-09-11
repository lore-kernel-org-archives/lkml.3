Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaIKIsC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:48:02 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37936 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbaIKIrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:47:46 -0400
Message-ID: <1410425238.4011.18.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 1/5] ARM: dts: pbab01: move i2c pins and frequency
 configuration into pfla02
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        shawn.guo@freescale.com, kernel@pengutronix.de, linux@arm.linux.org.uk,
        perex@perex.cz, tiwai@suse.de, timur@tabi.org, nicoleotsuka@gmail.com,
        Li.Xiubo@freescale.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org
Date: Thu, 11 Sep 2014 10:47:18 +0200
In-Reply-To: <1410356809-26179-2-git-send-email-d.lavnikevich@sam-solutions.com>
References: <1410356809-26179-1-git-send-email-d.lavnikevich@sam-solutions.com>
	 <1410356809-26179-2-git-send-email-d.lavnikevich@sam-solutions.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 10.09.2014, 16:46 +0300 schrieb Dmitry Lavnikevich:
> Since pins and frequency are specific to module (pfla02), not base board
> (pbab02), it is better to be initialized in corresponding dts file.
> 
> Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>

I have seen boards use the GPIO_3/6 pads instead of EIM_D17/D18 for
I2C3, but the EIM_D17/D18 are indeed documented as "I2C1" pins at the
pfla02 connector level.

regards
Philipp

