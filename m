Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbaAILVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:21:23 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44402 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaAILVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:21:13 -0500
Date: Thu, 9 Jan 2014 11:21:08 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mfd: MAX6650/6651 support
Message-ID: <20140109112108.GC20699@lee--X1>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
 <1387814889-16670-2-git-send-email-lpapp@kde.org>
 <20140108223933.GD18611@lee--X1>
 <CAOMwXhN5JStJgG5Q9cjuJByhyhz-XPb4ThkA45B+fA724Ucqog@mail.gmail.com>
 <20140109094147.GA20699@lee--X1>
 <CAOMwXhO=0K+SL2rNo_7JvKVET2DYZnTSr_=wzFedz2e2z_3u1w@mail.gmail.com>
 <20140109110635.GB20699@lee--X1>
 <CAOMwXhMRtFnAy33v90rZ-Mpa+yksH0054Pwr9M_VqeoJQWnPbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMwXhMRtFnAy33v90rZ-Mpa+yksH0054Pwr9M_VqeoJQWnPbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> > Can you show me where you are using them?
> >>
> >> Perhaps, I was not while submitting this change, but the upcoming
> >> changes should.
> >
> > Again, this adds confusion. Send your best, cleanest, most up-to-date
> > code, or all you're doing is wasting people's time.
> 
> Well, that is the point why I was clarifying it.
> 
> Note that it is not like I can pull off an update within such a short
> while after so many comments.... Especially since there are new
> concepts revealed like "regmap", etc. I also need to make sure it
> works with both latest and 3.2 where the regmap i2c init convenience
> resource manager is not present, etc. It is a time-consuming full-time
> job. :-)

No one is asking you to pull off anything. This is your first
submission and I am reviewing as such.

> An update will be coming addressing all the points.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
