Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935644AbaH0RVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:21:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34618 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935629AbaH0RVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:21:41 -0400
From: Dmitry Torokhov <dtor@chromium.org>
To: Lee Jones <lee.jones@linaro.org>
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
Date: Wed, 27 Aug 2014 10:21:38 -0700
Message-ID: <12367482.Ifp3ZtRrMQ@dtor-glaptop>
User-Agent: KMail/4.13.3 (Linux/3.13.0-34-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140827133936.GD6364@lee--X1>
References: <1409062444-12019-1-git-send-email-zyw@rock-chips.com> <20140827133936.GD6364@lee--X1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 27, 2014 02:39:36 PM Lee Jones wrote:
> On Tue, 26 Aug 2014, Chris Zhong wrote:
> > +
> > +static struct of_device_id rk808_of_match[] = {
> > +	{ .compatible = "rockchip,rk808" },
> > +};
> > +MODULE_DEVICE_TABLE(of, rk808_of_match);
> > +
> > +static const struct i2c_device_id rk808_ids[] = {
> > +	 { "rk808" },
> > +};
> > +
> > +MODULE_DEVICE_TABLE(i2c, rk808_ids);
> 
> My OCD senses are tingling.  Either have a blank line above the calls
> to MODULE_DEVICE_TABLE() or don't.

Wait, don't we also need sentinel entries in both these tables?

Thanks,
Dmitry
