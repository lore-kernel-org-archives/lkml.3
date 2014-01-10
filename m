Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaAJJ46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 04:56:58 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:35258 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaAJJ4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:56:55 -0500
Date: Fri, 10 Jan 2014 09:56:48 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mfd: MAX6650/6651 support
Message-ID: <20140110095648.GA28141@lee--X1>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
 <1387814889-16670-2-git-send-email-lpapp@kde.org>
 <20140108223933.GD18611@lee--X1>
 <CAOMwXhPhOGn2n2ca1aenxS_-b0pYiZ_KvX7bR666MsoxaQeL9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMwXhPhOGn2n2ca1aenxS_-b0pYiZ_KvX7bR666MsoxaQeL9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Jan 2014, Laszlo Papp wrote:

> >> +int max6651_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
> >> +{
> >
> > Probably best to use Regmap instead.
> >
> > regmap_i2c_read()
> 
> >> +int max6651_write_reg(struct i2c_client *i2c, u8 reg, u8 value)
> >> +{
> >> +    struct max6651_dev *max6651 = i2c_get_clientdata(i2c);
> >> +    int ret;
> >
> > Same here.
> >
> > regmap_i2c_write()
> 
> Hmm, but what Linus linked is using regmap_read/write(...) instead of
> regmap_i2c_read/write(...).
> 
> I thought I would need to be using the former. Perhaps, I
> misunderstand something?
> 
> I do not even find the aforementioend functions used by drivers based
> on this LXR result:
> http://lxr.free-electrons.com/ident?i=regmap_i2c_write

Linus is in a better position to know, use his suggestion.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
