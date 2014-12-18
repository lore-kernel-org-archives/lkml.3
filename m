Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbaLRKeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 05:34:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45260 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaLRKeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 05:34:05 -0500
Message-ID: <1418898812.4212.11.camel@pengutronix.de>
Subject: Re: [PATCH RFC v2 06/14] ARM: dts: imx6qdl: Move existing MIPI DSI
 ports into a new 'ports' node
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Liu Ying <Ying.Liu@freescale.com>
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        kernel@pengutronix.de, thierry.reding@gmail.com, shawn.guo@linaro.org,
        mturquette@linaro.org, airlied@linux.ie, linux-kernel@vger.kernel.org
Date: Thu, 18 Dec 2014 11:33:32 +0100
In-Reply-To: <1418886696-11636-7-git-send-email-Ying.Liu@freescale.com>
References: <1418886696-11636-1-git-send-email-Ying.Liu@freescale.com>
	 <1418886696-11636-7-git-send-email-Ying.Liu@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 18.12.2014, 15:11 +0800 schrieb Liu Ying:
> The MIPI DSI node contains some ports which represent possible DRM CRTCs
> it can connect with.  Each port has a 'reg' property embedded.  This
> property will be wrongly interpretted by the MIPI DSI bus driver, because
> the driver will take each subnode which contains a 'reg' property as a
> DSI peripheral device.  This patch moves the existing MIPI DSI ports into
> a new 'ports' node so that the MIPI DSI bus driver may distinguish its
> DSI peripheral device(s) from the existing ports.
> 
> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

