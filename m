Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936057Ab3DPQf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 12:35:27 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:59599 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936026Ab3DPQfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 12:35:25 -0400
Date: Tue, 16 Apr 2013 09:35:26 -0700
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@chromium.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        grant.likely@secretlab.ca, yuvaraj.cd@gmail.com,
        ben.dooks@codethink.co.uk, u.kleine-koenig@pengutronix.de,
        broonie@opensource.wolfsonmicro.com, girish.shivananjappa@linaro.org,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        prashanth.g@samsung.com, djkurtz@chromium.org, swarren@wwwdotorg.org,
        linux@roeck-us.net, Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] ARM: dts: Add i2c-arbitrator bus for
 exynos5250-snow
Message-ID: <20130416163526.GB4918@quad.lixom.net>
References: <1365543270-10736-1-git-send-email-dianders@chromium.org>
 <1366129742-16048-1-git-send-email-dianders@chromium.org>
 <1366129742-16048-2-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366129742-16048-2-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 09:29:01AM -0700, Doug Anderson wrote:
> We need to use the i2c-arbitrator to talk to any of the devices on i2c
> bus 4 on exynos5250-snow so that we don't confuse the embedded
> controller (EC).  Add the i2c-arbitrator to the device tree.  As we
> add future devices (keyboard, sbs, tps65090) we'll add them on top of
> this.
> 
> The arbitrated bus is numbered 104 simply as a convenience to make it
> easier for people poking around to guess that it might have something
> to do with the physical bus 4.
> 
> The addition is split between the cros5250-common and the snow device
> tree file since not all cros5250-class devices use arbitration.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
