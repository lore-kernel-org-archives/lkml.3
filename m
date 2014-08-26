Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123AbaHZIcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:32:22 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33182 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744AbaHZIcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:32:16 -0400
Date: Tue, 26 Aug 2014 09:32:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH v5 2/5] MFD: RK808: Add new mfd driver for RK808
Message-ID: <20140826083206.GD9574@lee--X1>
References: <1408973516-21395-1-git-send-email-zyw@rock-chips.com>
 <CAD=FV=Wz1yssGvB05ExPaYxsiizcPRYrfP9OWE+HdoSDKVc_Tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=FV=Wz1yssGvB05ExPaYxsiizcPRYrfP9OWE+HdoSDKVc_Tw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2014, Doug Anderson wrote:
> On Mon, Aug 25, 2014 at 6:31 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> > The RK808 chip is a power management IC for multimedia and handheld
> > devices. It contains the following components:
> >
> > - Regulators
> > - RTC
> >
> > The RK808 core driver is registered as a platform driver and provides
> > communication through I2C with the host device for the different
> > components.
> >
> > Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> 
> You need a Signed-off-by: Zhang Qing <zhangqing@rock-chips.com>
> 
> > ---

[...]

> > +static struct rk808 *g_rk808;
> 
> I think Lee's "Grim" comment here was that prefixing globals with "g_"
> is not consistent with the Linux coding style.  Just remove the "g_".

That and the seemingly unavoidable use of a global pointer.

[...]

> > +static const struct i2c_device_id rk808_ids[] = {
> > +        { "rk808", 0 },
> 
> I think Lee wanted the above to be:
> 
>        { "rk808", },

Right, but the ',' is now superfluous.

[...]

> I didn't do a thorough review, just compared to Lee's old feedback.
> Maybe a good idea to get in the habit to responding to others comments
> with "Done" so others know you have addressed each comment?

Please only do this locally or in your head.  Reading replies to
reviews containing only a break-down of what has been fixed is a waste
of everyone's time.  If/when replying to comments/observations that
you do _not_ agree with, please snip out all of the ones that you _do_
agree with.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
