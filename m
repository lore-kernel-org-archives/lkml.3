Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936280AbaH1Hdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 03:33:52 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:43355 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936184AbaH1Hdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 03:33:51 -0400
Date: Thu, 28 Aug 2014 08:33:42 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, sameo@linux.intel.com, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, mturquette@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, javier.martinez@collabora.co.uk,
        kever.yang@rock-chips.com
Subject: Re: [PATCH v6 2/5] MFD: RK808: Add new mfd driver for RK808
Message-ID: <20140828073342.GH24579@lee--X1>
References: <1409062444-12019-1-git-send-email-zyw@rock-chips.com>
 <20140827133936.GD6364@lee--X1>
 <12367482.Ifp3ZtRrMQ@dtor-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12367482.Ifp3ZtRrMQ@dtor-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Dmitry Torokhov wrote:

> On Wednesday, August 27, 2014 02:39:36 PM Lee Jones wrote:
> > On Tue, 26 Aug 2014, Chris Zhong wrote:
> > > +
> > > +static struct of_device_id rk808_of_match[] = {
> > > +	{ .compatible = "rockchip,rk808" },
> > > +};
> > > +MODULE_DEVICE_TABLE(of, rk808_of_match);
> > > +
> > > +static const struct i2c_device_id rk808_ids[] = {
> > > +	 { "rk808" },
> > > +};
> > > +
> > > +MODULE_DEVICE_TABLE(i2c, rk808_ids);
> > 
> > My OCD senses are tingling.  Either have a blank line above the calls
> > to MODULE_DEVICE_TABLE() or don't.
> 
> Wait, don't we also need sentinel entries in both these tables?

Good spot, yes please.

 { },

Will do fine.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
