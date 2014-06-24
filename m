Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbaFXLOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:14:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55507 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaFXLOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:14:16 -0400
Message-ID: <1403608445.2910.16.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v2 02/12] Documentation: bindings: add reset bindings
 docs for Marvell Berlin SoCs
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Antoine =?ISO-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 24 Jun 2014 13:14:05 +0200
In-Reply-To: <1403606121-6368-3-git-send-email-antoine.tenart@free-electrons.com>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
	 <1403606121-6368-3-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 24.06.2014, 12:35 +0200 schrieb Antoine Ténart:
> Add the reset binding documentation to the SoC binding documentation as
> the reset driver in Marvell Berlin SoC is part of the chip/system
> control registers. This patch adds the required properties to configure
> the reset controller.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

