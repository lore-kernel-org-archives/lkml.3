Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965061AbaH0UBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:01:21 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:34404 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934955AbaH0UBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:01:18 -0400
MIME-Version: 1.0
In-Reply-To: <12367482.Ifp3ZtRrMQ@dtor-glaptop>
References: <1409062444-12019-1-git-send-email-zyw@rock-chips.com>
	<20140827133936.GD6364@lee--X1>
	<12367482.Ifp3ZtRrMQ@dtor-glaptop>
Date: Wed, 27 Aug 2014 13:01:18 -0700
X-Google-Sender-Auth: ZSPDaidqyqKqjEk1NEZ8oEAeTII
Message-ID: <CAD=FV=X30a5i_F7C24uOAdi9ST9XDJT4cXbmDk4h=x0M8Ak9Ow@mail.gmail.com>
Subject: Re: [PATCH v6 2/5] MFD: RK808: Add new mfd driver for RK808
From: Doug Anderson <dianders@chromium.org>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>, Chris Zhong <zyw@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
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
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

On Wed, Aug 27, 2014 at 10:21 AM, Dmitry Torokhov <dtor@chromium.org> wrote:
> On Wednesday, August 27, 2014 02:39:36 PM Lee Jones wrote:
>> On Tue, 26 Aug 2014, Chris Zhong wrote:
>> > +
>> > +static struct of_device_id rk808_of_match[] = {
>> > +   { .compatible = "rockchip,rk808" },
>> > +};
>> > +MODULE_DEVICE_TABLE(of, rk808_of_match);
>> > +
>> > +static const struct i2c_device_id rk808_ids[] = {
>> > +    { "rk808" },
>> > +};
>> > +
>> > +MODULE_DEVICE_TABLE(i2c, rk808_ids);
>>
>> My OCD senses are tingling.  Either have a blank line above the calls
>> to MODULE_DEVICE_TABLE() or don't.
>
> Wait, don't we also need sentinel entries in both these tables?

Yes!  Good catch.  Last I reviewed the code it was there...
