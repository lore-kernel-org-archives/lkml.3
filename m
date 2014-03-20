Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771AbaCTPXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:23:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52801 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933546AbaCTPXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:23:14 -0400
Date: Thu, 20 Mar 2014 16:23:07 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC V2] mfd: da9063: Add support for production silicon variant
 code
Message-ID: <20140320152307.GR1629@pengutronix.de>
References: <201402141506.s1EF6iYr002690@swsrvapps-01.diasemi.com>
 <20140214164319.GB30687@lee--X1>
 <1394807833.3710.57.camel@paszta.hi.pengutronix.de>
 <6ED8E3B22081A4459DAC7699F3695FB7A18F5A46@SW-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ED8E3B22081A4459DAC7699F3695FB7A18F5A46@SW-EX-MBX02.diasemi.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:18:24 up 208 days, 49 min, 54 users,  load average: 1,38, 0,80,
 0,40
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Wed, Mar 19, 2014 at 05:14:54PM +0000, Opensource [Steve Twiss] wrote:
> > > > > This patch will remove the older variant code ID which matches the
> > > > > pre-production silicon ID (0x3) for the DA9063 chip.

[...]

> > > we have a few i.MX6 Modules (imx6q-phytec-pfla02) with DA9063 PMICs that
> > > all report the model/revision ID as 0x61/0x03. Those are marked as
> > > follows:
> > >    dialog DA9063 44 1240EHDA
> > >    dialog DA9063 44 1312ECAF
> > >
> > > We now have received a report from Phytec that those PMICs were not
> > > marketed as preproduction in any way, but as a normal mask revision.
> > > Their Dialog Semiconductor contact talked about AD, BA, and BB silicon
> > > variants. How do those relate to the variant register value and to the
> > > markings on the chips?
> > >
> > > There seems to be a serious miscommunication somewhere.

[...]

> Phytec informs us that you already asked them for this and have
> confirmed that you should have all necessary information now

No, it's completely unclear:

a) You said above that the 0x3 silicon is pre-production and thus you
   removed that from the kernel.

b) Phytec says you didn't mark the PMICs as preproduction in any way.

The question is still, which one is correct? If a), I'm wondering why
Phytec didn't get that information. If b), the 0x3 variant must not be
removed from the kernel.

Could you clarify that?

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
