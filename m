Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbaDXODU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:03:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35439 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbaDXODS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:03:18 -0400
References: <20140424125421.GA19526@amd.pavel.ucw.cz>
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: dinh@amd.pavel.ucw.cz, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: socfpga in 3.15-rc2
In-reply-to: <20140424125421.GA19526@amd.pavel.ucw.cz>
Date: Thu, 24 Apr 2014 16:03:38 +0200
Message-ID: <734n1i25ad.fsf@unicorn.hi.pengutronix.de>
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

Pavel Machek <pavel@ucw.cz> writes:
> Hi!
>
> Does socfpga boot for you on 3.15-rc2? Mainline worked on 3.14 pretty
> well, but I get no output from serial from 3.15-rc2. Any ideas?
>

You need:

[PATCH] clk: socfpga: fix clock driver for 3.15
Message-Id: 1397481336-5592-1-git-send-email-dinguyen@altera.com

Regards,
Steffen

-- 
Pengutronix e.K.                           | Steffen Trumtrar            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

