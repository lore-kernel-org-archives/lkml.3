Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbaGHI2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:28:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45814 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbaGHI2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:28:50 -0400
References: <1402393493-3559-1-git-send-email-jbe@pengutronix.de>
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Juergen Borleis <jbe@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, kernel@pengutronix.de
Subject: Re: Power/battery/BQ27xxx: some fixes and hot-plug support
In-reply-to: <1402393493-3559-1-git-send-email-jbe@pengutronix.de>
Date: Tue, 08 Jul 2014 10:28:45 +0200
Message-ID: <7361j8gsoy.fsf@unicorn.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:a61f:72ff:fe69:16d
X-SA-Exim-Mail-From: s.trumtrar@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

Juergen Borleis <jbe@pengutronix.de> writes:
> The BQ27425 support needs some fixes, as it differs from the main
> BQ27000 and the BQ27500 somehow. Also we need to distinguish two existing
> BQ27425 device types due to a firmware change.
>
> And these kind of devices can be part of the attached battery or part of the
> board with an externally attached battery. In both cases we must consider a
> battery change can be handled and at least the battery connection state gets
> reported correctly.
>

ping!

Any comments on this series!?

Regards,
Steffen

-- 
Pengutronix e.K.                           | Steffen Trumtrar            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

