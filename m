Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab3K0LLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:11:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46713 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab3K0LL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:11:26 -0500
Message-ID: <1385550403.4044.3.camel@weser.hi.pengutronix.de>
Subject: Re: [PATCH 3/3] ARM: tegra: set SM2 voltage correct
From: Lucas Stach <l.stach@pengutronix.de>
To: Stefan Agner <stefan@agner.ch>
Cc: mark.rutland@arm.com, dev@lynxeye.de, sameo@linux.intel.com,
        swarren@wwwdotorg.org, linux-kernel@vger.kernel.org,
        thierry.reding@gmail.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 27 Nov 2013 12:06:43 +0100
In-Reply-To: <6311b14be5af09d82e6781160e2aac3a@agner.ch>
References: <cover.1385508112.git.stefan@agner.ch>
	 <c9ceead9e3df77b5a33ad654db23c241cd624096.1385508112.git.stefan@agner.ch>
	 <1385546387.4270.11.camel@weser.hi.pengutronix.de>
	 <6311b14be5af09d82e6781160e2aac3a@agner.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 27.11.2013, 12:05 +0100 schrieb Stefan Agner:
> Hi Lucas,
> 
> Am 2013-11-27 10:59, schrieb Lucas Stach:
> > This isn't a global Tegra change, but very specific to the Colibri, so
> > please reword your commit headline to reflect that.
> Agree, will do that.
> 
> > Also there are other issues with the regulator setup on Colibri, I sent
> > a patch for this a good while ago, but didn't come around to revise it
> > until now. So if you are going to touch things here, please look up that
> > patch and fold it into this one.
> I guess you refer to this patchset:
> http://thread.gmane.org/gmane.linux.ports.tegra/11984
> 
> Ok, I will fold patch 4 into my patchset. Not sure whether I should add
> patch 3 (ULPI phy on Colibri T20) as well, since this one is somewhat
> unrelated...
> 
The ULPI patch is already upstream.

At least the first hunk of patch 4 should be folded into your patch, as
it's a real regulator bugfix like your correction of the sm2 voltage.

Lowering sm0 and sm1 voltages is somewhat an optimization and may be
done as a separate patch.

Regards,
Lucas
-- 
Pengutronix e.K.                           | Lucas Stach                 |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-5076 |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

