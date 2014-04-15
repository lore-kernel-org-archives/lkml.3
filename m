Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaDOR5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:57:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41659 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaDOR5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:57:01 -0400
Date: Tue, 15 Apr 2014 19:56:53 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH v2] clocksource: efm32: use $vendor,$device scheme for
 compatible string
Message-ID: <20140415175653.GL5969@pengutronix.de>
References: <1395757522-6431-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1395759044-10700-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <534D63D7.8000803@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <534D63D7.8000803@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Daniel,

On Tue, Apr 15, 2014 at 06:52:39PM +0200, Daniel Lezcano wrote:
> On 03/25/2014 03:50 PM, Uwe Kleine-König wrote:
> >Wolfgang Sang pointed out that "efm32,$device" is non-standard. So use the
> >common scheme and prefix device with "efm32-". The old compatible string
> >is left in place until arch/arm/boot/dts/efm32* is fixed.
> >
> >Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de
> 
> Applied for 3.16 (and fixed Wolfgang => Wolfram)
thanks for the s/gang/ram/ fix. I'm still mortified.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
