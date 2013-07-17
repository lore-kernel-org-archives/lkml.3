Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3GQNje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:39:34 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:54799 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754896Ab3GQNjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:39:33 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Jason Cooper <jason@lakedaemon.net>, Matt Sealey <neko@bakuhatsu.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 17 Jul 2013 06:37:57 -0700
Subject: RE: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
Thread-Topic: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
Thread-Index: Ac6AyJObx/Amk3D5TmihoRR4yBqOvgCKhNxg
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE3DBCDAF7C4@SC-VEXCH4.marvell.com>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
 <20130710214922.GQ11908@titan.lakedaemon.net>
 <175CCF5F49938B4D99B2E3EF7F558EBE3DBC97FDFA@SC-VEXCH4.marvell.com>
 <201307142129.43271.arnd@arndb.de>
In-Reply-To: <201307142129.43271.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6HDddex026111

Arnd

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: 2013Äê7ÔÂ15ÈÕ 3:30
> To: Neil Zhang
> Cc: Jason Cooper; Matt Sealey; grant.likely@linaro.org;
> haojian.zhuang@gmail.com; devicetree-discuss@lists.ozlabs.org;
> linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
> 
> On Thursday 11 July 2013, Neil Zhang wrote:
> > > > > To do this properly, the drivers are going to have to be
> > > > > compatible with the old and the new names, and the binding docs
> > > > > updated to reflect the legacy name and the preferred name.
> > > >
> > > > Properly would be as above. You can stop using stock tickers for
> > > > new company names, but anything that has been defined in a device
> > > > tree before has to stay that way, and all the manufacturer
> > > > prefixes to device names should be the same. What you're proposing
> > > > is purely driver bloat and increasing the size of kernel.
> > >
> > > *I'm* not proposing to change the name, Neil is.  I'm proposing that
> > > iff they chose to do that, don't break sh*t along the way.
> > >
> >
> > What's your opinion?
> 
> We discussed the topic of fixing bad bindings vs. keeping backwards compatibility
> during last week's Linaro Connect.
> 
> The main outcome was that we need to have a better review for new bindings
> getting merged to avoid this situation in the future, but the general consensus
> seems that bindings that are already in use but were never reviewed properly
> (which should have caught this) should be changed.

So would you mind if I leave it there (discard this patch) and still use the current 'mvrl' prefix for this patch set.

> We will likely establish an annotation in the binding soon to mark those that can
> not be changed as opposed to those that are not considered stable yet.
> 
> 	Arnd


Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
