Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965205Ab3DJLCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:02:48 -0400
Received: from sauhun.de ([89.238.76.85]:49380 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965013Ab3DJLCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:02:47 -0400
Date: Wed, 10 Apr 2013 13:02:27 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Doug Anderson'" <dianders@chromium.org>,
        "'Simon Glass'" <sjg@chromium.org>,
        "'Naveen Krishna Chatradhi'" <ch.naveen@samsung.com>,
        grant.likely@secretlab.ca, yuvaraj.cd@gmail.com,
        ben.dooks@codethink.co.uk, u.kleine-koenig@pengutronix.de,
        broonie@opensource.wolfsonmicro.com, girish.shivananjappa@linaro.org,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        prashanth.g@samsung.com, olof@lixom.net, djkurtz@chromium.org,
        swarren@wwwdotorg.org, linux@roeck-us.net,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] ARM: dts: Add i2c-arbitrator bus for
 exynos5250-snow
Message-ID: <20130410110226.GA3533@the-dreams.de>
References: <1363192583-26363-1-git-send-email-dianders@chromium.org>
 <1365543270-10736-1-git-send-email-dianders@chromium.org>
 <1365543270-10736-2-git-send-email-dianders@chromium.org>
 <310301ce35da$724dff60$56e9fe20$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <310301ce35da$724dff60$56e9fe20$%kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 07:59:17PM +0900, Kukjin Kim wrote:
> Doug Anderson wrote:
> > 
> > We need to use the i2c-arbitrator to talk to any of the devices on i2c
> > bus 4 on exynos5250-snow so that we don't confuse the embedded
> > controller (EC).  Add the i2c-arbitrator to the device tree.  As we
> > add future devices (keyboard, sbs, tps65090) we'll add them on top of
> > this.
> > 
> > The arbitrated bus is numbered 104 simply as a convenience to make it
> > easier for people poking around to guess that it might have something
> > to do with the physical bus 4.
> > 
> > The addition is split between the cros5250-common and the snow device
> > tree file since not all cros5250-class devices use arbitration.
> > 
> > Signed-off-by: Doug Anderson <dianders@chromium.org>
> 
> I'm fine on 2nd and 3rd patches. Shall I take only two patches without 1st
> one in samsung tree?

Please wait for my OK on patch 1. Or ack patches 2 and 3 and I will pick
them up. I am fine with both.

