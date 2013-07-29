Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab3G2I3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 04:29:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53710 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab3G2I3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 04:29:09 -0400
Message-ID: <1375086510.4223.2.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v2 2/2] regulator: Add Dialog DA9063 voltage regulators
 support.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Date: Mon, 29 Jul 2013 10:28:30 +0200
In-Reply-To: <20130728125111.GW9858@sirena.org.uk>
References: <1374773943-7454-1-git-send-email-p.zabel@pengutronix.de>
	 <1374773943-7454-3-git-send-email-p.zabel@pengutronix.de>
	 <20130728125111.GW9858@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Am Sonntag, den 28.07.2013, 13:51 +0100 schrieb Mark Brown:
> On Thu, Jul 25, 2013 at 07:39:03PM +0200, Philipp Zabel wrote:
> 
> >  - 1x power switch to switch on/off 32 KHz oscilator output (32K_OUT).
> 
> The driver looks good except this should be implemented using the clock
> API not the regulator API - some drivers did this while we didn't have a
> clock API but we do now and in any case the clock shouldn't appear as a
> regulator in the DT bindings.

Thanks, I'll change this to use the clock API then.

regards
Philipp

