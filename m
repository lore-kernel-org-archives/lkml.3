Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966061Ab3DQJdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:33:36 -0400
Received: from sauhun.de ([89.238.76.85]:34976 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965911Ab3DQJde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:33:34 -0400
Date: Wed, 17 Apr 2013 11:32:49 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        grant.likely@secretlab.ca, yuvaraj.cd@gmail.com,
        ben.dooks@codethink.co.uk, u.kleine-koenig@pengutronix.de,
        broonie@opensource.wolfsonmicro.com, girish.shivananjappa@linaro.org,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        prashanth.g@samsung.com, olof@lixom.net, djkurtz@chromium.org,
        swarren@wwwdotorg.org, linux@roeck-us.net,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Stephen Warren <swarren@nvidia.com>, Jean Delvare <khali@linux-fr.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v6 1/3] i2c: mux: Add i2c-arb-gpio-challenge 'mux' driver
Message-ID: <20130417093148.GB4508@the-dreams.de>
References: <1365543270-10736-1-git-send-email-dianders@chromium.org>
 <1366129742-16048-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366129742-16048-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 09:29:00AM -0700, Doug Anderson wrote:
> The i2c-arb-gpio-challenge driver implements an I2C arbitration scheme
> where masters need to claim the bus with a GPIO before they can start
> a transcation.  This should generally only be used when standard I2C
> multimaster isn't appropriate for some reason (errata/bugs).
> 
> This driver is based on code that Simon Glass added to the i2c-s3c2410
> driver in the Chrome OS kernel 3.4 tree.  The current incarnation as a
> mux driver is as suggested by Grant Likely.  See
> <https://patchwork.kernel.org/patch/1877311/> for some history.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Simon Glass <sjg@chromium.org>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>

I fixed the typo myself. Applied to for-next, thanks everyone!

