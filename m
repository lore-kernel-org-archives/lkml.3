Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaGIHYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 03:24:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48437 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaGIHYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 03:24:35 -0400
Date: Wed, 9 Jul 2014 09:24:20 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: a case for a common efuse API?
Message-ID: <20140709072420.GI7827@pengutronix.de>
References: <53BC4DD7.20906@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53BC4DD7.20906@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 08, 2014 at 01:00:23PM -0700, Stephen Boyd wrote:
> On MSM chips we have some efuses (called qfprom) where we store things
> like calibration data, speed bins, etc.
I don't have something constructive to say here, just want to point out
that on efm32 there is something similar. It's called "Device
Information (DI) Page" and contains "calibration values, a
unique identification number and other useful data".

Currently it is unused in mainline, but in my tree I access it directly
to determine cpu type (part number, part family number and Production
ID), flash and ram size, and the calibration settings for the ADC.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
