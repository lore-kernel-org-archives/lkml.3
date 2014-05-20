Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaETIno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:43:44 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:42171 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaETInk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:43:40 -0400
Date: Tue, 20 May 2014 09:43:30 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Doug Anderson <dianders@chromium.org>, swarren@nvidia.com,
        abrestic@chromium.org, dgreid@chromium.org, olof@lixom.net,
        sjg@chromium.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sameo@linux.intel.com, jdelvare@suse.de,
        shane.huang@amd.com, maxime.ripard@free-electrons.com,
        laurent.pinchart+renesas@ideasonboard.com,
        u.kleine-koenig@pengutronix.de, bjorn.andersson@sonymobile.com,
        kevin.strasser@linux.intel.com, linux@prisktech.co.nz, andrew@lunn.ch,
        andriy.shevchenko@linux.intel.com, schwidefsky@de.ibm.com,
        matt.porter@linaro.org, ch.naveen@samsung.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 6/7] i2c: ChromeOS EC tunnel driver
Message-ID: <20140520084330.GA24991@lee--X1>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
 <1398879850-9111-7-git-send-email-dianders@chromium.org>
 <20140519105055.GA2612@katana>
 <20140519172258.GD20435@lee--X1>
 <20140519221902.GA2871@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140519221902.GA2871@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Code looks good, so
> > > 
> > > Reviewed-by: Wolfram Sang <wsa@the-dreams.de>
> > > 
> > > I don't mind how it gets upstream. I can take it, but you can also keep
> > > it in this series.
> > 
> > Let's keep the series together.  Are you happy with me just merging it
> > through MFD, or would you like a pull-request, so you can take it in
> > too?
> 
> Just merge it...

Thanks dude.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
