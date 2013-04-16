Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936108Ab3DPQgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 12:36:00 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:57319 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936026Ab3DPQf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 12:35:59 -0400
Date: Tue, 16 Apr 2013 09:36:00 -0700
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
        Linus Walleij <linus.walleij@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/3] ARM: dts: Add sbs-battery for exynos5250-snow
Message-ID: <20130416163600.GC4918@quad.lixom.net>
References: <1365543270-10736-1-git-send-email-dianders@chromium.org>
 <1366129742-16048-1-git-send-email-dianders@chromium.org>
 <1366129742-16048-3-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366129742-16048-3-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 09:29:02AM -0700, Doug Anderson wrote:
> Now that we have i2c-arbitrator in place on bus 4 we can add the
> sbs-battery driver.  Future devices will be added onto bus 4 once
> drivers are in good shape.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
