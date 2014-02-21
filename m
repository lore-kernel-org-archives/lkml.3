Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbaBUTJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:09:33 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50356 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbaBUTJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:09:32 -0500
Date: Fri, 21 Feb 2014 20:09:17 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH] phy: restrict Samsung S5P/Exynos drivers to the
 respective architectures
Message-ID: <20140221190917.GN6988@pengutronix.de>
References: <1392991526-20895-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <53077707.9060409@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53077707.9060409@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 04:55:51PM +0100, Sylwester Nawrocki wrote:
> Hi,
> 
> On 21/02/14 15:05, Uwe Kleine-König wrote:
> > Enabling these drivers on platforms not created by Samsung is useless
> > unless you're doing compile tests. So don't offer the users to enable
> > them without COMPILE_TEST for configs with S5P/Exynos disabled.
> 
> Thanks for the patch, I've already sent something similar to Kishon, but
> I've messed up the mailing list address. A bit improved v2 I just posted
> can be found here:
> 
> https://patchwork.kernel.org/patch/3698271/
> https://patchwork.kernel.org/patch/3698251/
fine for me. If you need to repost feel free to add my Ack for these.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
