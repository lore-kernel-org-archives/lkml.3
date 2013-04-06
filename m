Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423011Ab3DFOTe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 10:19:34 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:48943 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422983Ab3DFOTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 10:19:33 -0400
MIME-Version: 1.0
In-Reply-To: <51602A0B.6020405@pengutronix.de>
References: <1365255828-6416-1-git-send-email-aletes.xgr@gmail.com>
	<51602A0B.6020405@pengutronix.de>
Date: Sat, 6 Apr 2013 11:19:32 -0300
Message-ID: <CAAAP30Gmc+aR1AY2Grd_M5LyXUO9szMxoLLA62ROq7=Hzz3ZEQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: mxs-mmc: Add broken-cd devicetree property
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Chris Ball <cjb@laptop.org>, Shawn Guo <shawn.guo@linaro.org>,
        =?UTF-8?B?TWFyZWsgVmHFoXV0?= <marex@denx.de>,
        fabio.estevam@freescale.com, Otavio Salvador <otavio@ossystems.com.br>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-mmc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 6, 2013 at 10:58 AM, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> According to the documentation broken card detect is something different
> than non-removable:
>
> >   - broken-cd: There is no card detection available; polling must be used.
> >   - non-removable: non-removable slot (like eMMC); assume always present.
>
> But mxs-mmc set MMC_CAP_NEEDS_POLL unconditionally.

I will work on a better way to fix this.
