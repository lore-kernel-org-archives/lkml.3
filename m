Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaEEHRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:17:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38689 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbaEEHRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:17:41 -0400
Message-ID: <1399274253.3871.3.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 2/3] regulator: ltc3589: Add DT binding documentation
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Date: Mon, 05 May 2014 09:17:33 +0200
In-Reply-To: <20140501180428.GO3245@sirena.org.uk>
References: <1398789430-23897-1-git-send-email-p.zabel@pengutronix.de>
	 <1398789430-23897-2-git-send-email-p.zabel@pengutronix.de>
	 <20140501180428.GO3245@sirena.org.uk>
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

Am Donnerstag, den 01.05.2014, 11:04 -0700 schrieb Mark Brown:
> On Tue, Apr 29, 2014 at 06:37:09PM +0200, Philipp Zabel wrote:
> > This patch adds the device tree binding documentation for Linear
> > Technology LTC3589, LTC3589-1, and LTC3589-2 8-port regulators.
> 
> This is all good apart from the vendor prefix change thing.

Thanks, I'll change that and resubmit.

regards
Philipp

