Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaGVGAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 02:00:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53193 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaGVGAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 02:00:12 -0400
References: <1405995634-3297-1-git-send-email-cdhmanning@gmail.com>
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Charles Manning <cdhmanning@gmail.com>
Cc: linux-kernel@vger.kernel.org, dinguyen@altera.com, cslee@altera.com
Subject: Re: [PATCH 0/3] clk : Fix SOCFPGA clk crash and some clean up
In-reply-to: <1405995634-3297-1-git-send-email-cdhmanning@gmail.com>
Date: Tue, 22 Jul 2014 08:00:07 +0200
Message-ID: <738unmvspk.fsf@unicorn.hi.pengutronix.de>
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

As you touch clk.c, you should Cc

   Mike Turquette <mturquette@linaro.org>

He is the maintainer for that code.

Regards,
Steffen

-- 
Pengutronix e.K.                           | Steffen Trumtrar            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

