Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3GKLXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:23:42 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:58925 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932349Ab3GKLXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:23:41 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Jason Cooper <jason@lakedaemon.net>, Matt Sealey <neko@bakuhatsu.net>
CC: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 11 Jul 2013 04:20:31 -0700
Subject: RE: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
Thread-Topic: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
Thread-Index: Ac59t10J6pZpU3XaTMKVC5Do/xelVwAcTB5Q
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE3DBC97FDFA@SC-VEXCH4.marvell.com>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
 <1373352166-10064-2-git-send-email-zhangwm@marvell.com>
 <20130709124900.GG11908@titan.lakedaemon.net>
 <CAHCPf3u=Zu2-4RsWzi17rB_FmStwcf-Pt_7oRzAEnxN_w=a7cA@mail.gmail.com>
 <20130710214922.GQ11908@titan.lakedaemon.net>
In-Reply-To: <20130710214922.GQ11908@titan.lakedaemon.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6BBNliT022582

Arnd£¬


> -----Original Message-----
> From: Jason Cooper [mailto:jason@lakedaemon.net]
> Sent: 2013Äê7ÔÂ11ÈÕ 5:49
> To: Matt Sealey
> Cc: Neil Zhang; grant.likely@linaro.org; haojian.zhuang@gmail.com;
> arnd@arndb.de; devicetree-discuss@lists.ozlabs.org;
> linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
> 
> On Wed, Jul 10, 2013 at 03:50:10PM -0500, Matt Sealey wrote:
> > On Tue, Jul 9, 2013 at 7:49 AM, Jason Cooper <jason@lakedaemon.net>
> wrote:
> > > Neil,
> > >
> > > I agree with the need to change, however, this has been in the
> > > binding documentation since v3.5.  I wish we had caught this when we
> > > decided against using stock ticker symbols (not all stock markets
> > > use alphabetical abbreviated names, not all companies are listed on
> > > any stock exchange).
> >
> > Who decided that?
> 
> Now you're going to make me dig ;-)  iirc, we were going the stock ticker
> route, but then noticed that powerpc dts files had been using "marvell,..."
> for a _long_ time.  How long?  I'll leave that as an exercise for the
> reader. :-P  Because we shared at least the ethernet driver with them, we
> decided to conform with what was already present in the kernel and use
> "marvell,..." for all of the dt bindings we were creating for
> kirkwood/dove/mvebu (and eventually orion5x, mv78xx0).
> 
> As for who is 'we'?
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2012-May/101337.htm
> l
> 
> > You can't just "stop using stock ticker symbols" - FDT is inherently
> > based on the original OpenFirmware device tree and therefore any
> > existing bindings which are done on real OpenFirmware solutions where
> > using stock ticker symbols is entirely appropriate (although, these
> > days, not useful) is counter-productive.
> >
> > If Marvell had originally had mrvl as their ticker, and used this in
> > OF DTs (and it is..), then mrvl it stays. In the case where new
> > devices are added with marvell, this is in this case wrong. You should
> > keep using the old one. A good example of this; Freescale. Nobody is
> > saying everyone should move to "freescale,imx-this" or
> > "freescale,vybrid-that" - it's fsl and it stays fsl for
> > backwards/forwards compatibility because things exist already.
> 
> I agree, that's why I'm arguing for *maintaining* backwards compatibility.
> 
> > Any new companies can have a long, descriptive name; a privilege of
> > being late to the party, you might say :)
> >
> > Having an odd mix of mrvl and marvell or moving to marvell is just
> > completely obtuse, whether they had that stock ticker, will have it in
> > the future, it is how they're defined and you can't in good conscience
> > change the binding after devices ship with it.
> 
> See above regarding the marvell ethernet driver and powerpc...
> 
> > > To do this properly, the drivers are going to have to be compatible
> > > with the old and the new names, and the binding docs updated to
> > > reflect the legacy name and the preferred name.
> >
> > Properly would be as above. You can stop using stock tickers for new
> > company names, but anything that has been defined in a device tree
> > before has to stay that way, and all the manufacturer prefixes to
> > device names should be the same. What you're proposing is purely
> > driver bloat and increasing the size of kernel.
> 
> *I'm* not proposing to change the name, Neil is.  I'm proposing that
> *iff* they chose to do that, don't break sh*t along the way.
> 

What's your opinion?

> thx,
> 
> Jason.

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
