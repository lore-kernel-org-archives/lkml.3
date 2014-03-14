Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbaCNOhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:37:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42031 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbaCNOhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:37:20 -0400
Message-ID: <1394807833.3710.57.camel@paszta.hi.pengutronix.de>
Subject: Re: [RFC V2] mfd: da9063: Add support for production silicon
 variant code
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 14 Mar 2014 15:37:13 +0100
In-Reply-To: <20140214164319.GB30687@lee--X1>
References: <201402141506.s1EF6iYr002690@swsrvapps-01.diasemi.com>
	 <20140214164319.GB30687@lee--X1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Freitag, den 14.02.2014, 16:43 +0000 schrieb Lee Jones:
> > From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> > 
> > Add the correct silicon variant code ID (0x5) to the driver. This
> > new code is the 'production' variant code ID for DA9063.
> > 
> > This patch will remove the older variant code ID which matches the
> > pre-production silicon ID (0x3) for the DA9063 chip.
> > 
> > There is also some small amount of correction done in this patch:
> > it splits the revision code and correctly names it according to
> > the hardware specification and moves the dev_info() call before
> > the variant ID test.
> > 
> > Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> 
> Applied, thanks.

we have a few i.MX6 Modules (imx6q-phytec-pfla02) with DA9063 PMICs that
all report the model/revision ID as 0x61/0x03. Those are marked as
follows:
    dialog DA9063 44 1240EHDA
    dialog DA9063 44 1312ECAF
We now have received a report from Phytec that those PMICs were not
marketed as preproduction in any way, but as a normal mask revision.
Their Dialog Semiconductor contact talked about AD, BA, and BB silicon
variants. How do those relate to the variant register value and to the
markings on the chips?
There seems to be a serious miscommunication somewhere.

regards
Philipp

