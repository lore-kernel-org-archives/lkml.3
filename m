Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423128Ab3DFPHB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 11:07:01 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35388 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423040Ab3DFPHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 11:07:00 -0400
X-Auth-Info: fbkJQ9oJ1LePb/GwjhkhTW42dsj7rxn9jTlUx/mxe5Y=
From: Marek Vasut <marex@denx.de>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: Re: [PATCH] mmc: mxs-mmc: Add broken-cd devicetree property
Date: Sat, 6 Apr 2013 17:06:54 +0200
User-Agent: KMail/1.13.7 (Linux/3.8-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: "Marc Kleine-Budde" <mkl@pengutronix.de>, Chris Ball <cjb@laptop.org>,
        Shawn Guo <shawn.guo@linaro.org>, fabio.estevam@freescale.com,
        Otavio Salvador <otavio@ossystems.com.br>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-mmc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <1365255828-6416-1-git-send-email-aletes.xgr@gmail.com> <51602A0B.6020405@pengutronix.de> <CAAAP30Gmc+aR1AY2Grd_M5LyXUO9szMxoLLA62ROq7=Hzz3ZEQ@mail.gmail.com>
In-Reply-To: <CAAAP30Gmc+aR1AY2Grd_M5LyXUO9szMxoLLA62ROq7=Hzz3ZEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304061706.54320.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alexandre Pereira da Silva,

> On Sat, Apr 6, 2013 at 10:58 AM, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > According to the documentation broken card detect is something different
> > 
> > than non-removable:
> > >   - broken-cd: There is no card detection available; polling must be
> > >   used. - non-removable: non-removable slot (like eMMC); assume always
> > >   present.
> > 
> > But mxs-mmc set MMC_CAP_NEEDS_POLL unconditionally.
> 
> I will work on a better way to fix this.

NEEDS_POLL looks nice and seems to fit this case.

Best regards,
Marek Vasut
