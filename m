Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab3LPUyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:54:10 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38937 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab3LPUyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:54:09 -0500
Date: Mon, 16 Dec 2013 21:54:00 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Axel Lin <axel.lin@ingics.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] clocksource: time-efm32: Select CLKSRC_MMIO
Message-ID: <20131216205400.GD14866@pengutronix.de>
References: <1384913711.13115.2.camel@phoenix>
 <20131210132431.GB18888@pengutronix.de>
 <52A71746.6080809@linaro.org>
 <20131210160548.GC18888@pengutronix.de>
 <52AF5DB5.8090302@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52AF5DB5.8090302@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Daniel,

On Mon, Dec 16, 2013 at 09:08:21PM +0100, Daniel Lezcano wrote:
> On 12/10/2013 05:05 PM, Uwe Kleine-König wrote:
> >On Tue, Dec 10, 2013 at 02:29:42PM +0100, Daniel Lezcano wrote:
> >>I sent the PR with this patch. If everything is ok, it should be in
> >>the next -rc.
> >ok. Thanks for your quick reply.
It seems to have missed 3.13-rc4 btw :-(

> >It would be great if your tree were included in linux-next. Don't you
> >think this is feasible?
> 
> Well, yes it could be a good idea. But if you are suggesting to use
> linux-next for the fixes, that should be already taken into account
> with the #auto-latest branch of tip.
I might be wrong, but it seems that the window when the patches are in
your tree but not yet in tip is big. At least I hit that window I think
three times already.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
