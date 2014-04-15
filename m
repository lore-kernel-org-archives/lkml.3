Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaDOIfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:35:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37859 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbaDOIf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:35:29 -0400
Message-ID: <1397550925.3836.30.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v4 2/2] reset: Add GPIO support to reset controller
 framework
From: Philipp Zabel <p.zabel@pengutronix.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann Arnd Bergmann <arnd@arndb.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>, Roger Quadros <rogerq@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Date: Tue, 15 Apr 2014 10:35:25 +0200
In-Reply-To: <20140414115758.2c0c8a9d@alan.etchedpixels.co.uk>
References: <1397463709-19405-1-git-send-email-p.zabel@pengutronix.de>
	 <1397463709-19405-2-git-send-email-p.zabel@pengutronix.de>
	 <20140414115758.2c0c8a9d@alan.etchedpixels.co.uk>
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

Hi Alan,

Am Montag, den 14.04.2014, 11:57 +0100 schrieb One Thousand Gnomes:
> > This adds support for GPIO controlled reset pins on peripheral ICs to the reset
> > controller framework. Currently there is no support for specifying a delay
> > between assertion and de-assertion of the reset signal, so this has to be
> > handled by the drivers.
> 
> Lots of GPIO controllers are doing posted writes to the fabric so surely
> your delay will be wrong ?

I haven't seen hardware yet where this is an issue, but it's a valid
point. I can also imagine boards where the GPIO is connected to some
board specific timed reset logic or where the reset length has to be
altered just due to capacitance.

regards
Philipp

