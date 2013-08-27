Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab3H0QPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:15:53 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34959 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab3H0QPv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:15:51 -0400
Message-ID: <1377620149.6308.28.camel@hornet>
Subject: Re: [PATCH 09/33] ARM: ux500: Supply the I2C clocks lookup to the
 DBX500 DT
From: Pawel Moll <pawel.moll@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>, Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 27 Aug 2013 17:15:49 +0100
In-Reply-To: <CAL_JsqJU6HA46J2HBRFaOgd_23d4UoLuGtMZYKtsZR1+7brKvg@mail.gmail.com>
References: <20130820093034.GL31036@pengutronix.de>
	 <20130822133730.GB23152@e106331-lin.cambridge.arm.com>
	 <20130822141900.GB17154@lee--X1>
	 <20130822151723.GE23152@e106331-lin.cambridge.arm.com>
	 <20130822154116.GC17154@lee--X1>	<20130822211912.GE31036@pengutronix.de>
	 <20130823075607.GD17154@lee--X1>
	 <20130823165539.GD7015@e106331-lin.cambridge.arm.com>
	 <20130827080635.GC6152@lee--X1>
	 <20130827134621.GJ19893@e106331-lin.cambridge.arm.com>
	 <20130827140805.GB10210@lee--X1>
	 <CAL_JsqJU6HA46J2HBRFaOgd_23d4UoLuGtMZYKtsZR1+7brKvg@mail.gmail.com>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 27 Aug 2013 16:15:48.0862 (UTC) FILETIME=[B153D9E0:01CEA340]
X-MC-Unique: 113082717154908201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-27 at 16:51 +0100, Rob Herring wrote:
> >> * pl111 has no driver or binding in mainline, but appears in dts files.
> >>   Those dts files clcdclk and apb_pclk, in that order. We could fix
> >>   those before a driver starts using them.
> 
> I think this was waiting for some generic display bindings? Pawel may know.

Common Display Framework it was ;-)

And yes, it was waiting for it, but it is getting bored with waiting so
I'll cut off the CDF bits and post the rest this or next week.

As to the APB clock, we've been there before...
http://article.gmane.org/gmane.linux.ports.arm.kernel/188927

Cheers!

Pawel


