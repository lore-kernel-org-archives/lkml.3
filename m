Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab3AVREF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:04:05 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:54434 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab3AVRED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:04:03 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v3 00/12] video: da8xx-fb: am335x DT support
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <cover.1358871750.git.afzal@ti.com>
Date: Tue, 22 Jan 2013 18:03:58 +0100
Cc: <linux-fbdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <02F0A27B-B16B-42F8-A0BC-29726732226D@dominion.thruhere.net>
References: <cover.1358871750.git.afzal@ti.com>
To: Afzal Mohammed <afzal@ti.com>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 22 jan. 2013, om 17:51 heeft Afzal Mohammed <afzal@ti.com> het volgende geschreven:

> Hi,
> 
> This series adds DT support to da8xx-fb driver (device found on
> DaVinci and AM335x SoC's). It does certain cleanup's in the process.
> 
> This series as compared to previous version handles configuration of
> the LCDC clock rate by modelling as a clock divider of CCF. This would
> take effect only if CCF is selected, if not, no change to  existing
> method.
> 
> This makes use of Steffen Trumtrar's v16 of display timing DT support.

Wouldn't it be better to delete da8xx-fb.* and switch to Rob Clarks DRM based driver for this IP block?

regards,

Koen