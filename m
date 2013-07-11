Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab3GKLZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:25:45 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:38826 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755882Ab3GKLZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:25:43 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>, Arnd Bergmann <arnd@arndb.de>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 11 Jul 2013 04:23:10 -0700
Subject: RE: [PATCH V3 2/3] clocksource: mmp: support CLOCKSOURCE OF DECLARE
Thread-Topic: [PATCH V3 2/3] clocksource: mmp: support CLOCKSOURCE OF DECLARE
Thread-Index: Ac59MoevSoZAZ7aeRumfUKqclsnAVQA9iVdQ
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE3DBC97FDFF@SC-VEXCH4.marvell.com>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
	<1373352166-10064-3-git-send-email-zhangwm@marvell.com>
	<20130709181434.76f6216d@skate>	<201307092316.20905.arnd@arndb.de>
 <CAN1soZyFztVR1XSw9bDS5JexK0Mdbpr6yevatVf+MnBohwCj1Q@mail.gmail.com>
In-Reply-To: <CAN1soZyFztVR1XSw9bDS5JexK0Mdbpr6yevatVf+MnBohwCj1Q@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6BBPvD3022598

Haojian,


> -----Original Message-----
> From: Haojian Zhuang [mailto:haojian.zhuang@gmail.com]
> Sent: 2013Äê7ÔÂ10ÈÕ 13:59
> To: Arnd Bergmann
> Cc: Thomas Petazzoni; Neil Zhang; Grant Likely;
> devicetree-discuss@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH V3 2/3] clocksource: mmp: support CLOCKSOURCE OF
> DECLARE
> 
> On Wed, Jul 10, 2013 at 5:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 09 July 2013, Thomas Petazzoni wrote:
> >> Dear Neil Zhang,
> >>
> >> On Tue, 9 Jul 2013 14:42:45 +0800, Neil Zhang wrote:
> >> > support CLOCKSOURCE OF DECLARE for mmp timer.
> >> >
> >> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> >> > ---
> >> >  arch/arm/mach-mmp/mmp-dt.c  |    5 ++---
> >> >  arch/arm/mach-mmp/mmp2-dt.c |    3 +--
> >> >  arch/arm/mach-mmp/time.c    |   15 ++-------------
> >> >  3 files changed, 5 insertions(+), 18 deletions(-)
> >>
> >> Maybe it would be good to take this opportunity to move
> >> arch/arm/mach-mmp/time.c into drivers/clocksource/.
> >
> > +1
> >
> > Or we might want to have a more coordinated move of all clocksource
> > drivers in arch/arm to drivers/clocksource now, as we have done for
> > some other subsystems.
> >
> >         Arnd
> 
> I already sent some patches on this. But I didn't get response yet. I'll rebase
> them and send them again. I hope that they could be merged in this cycle.
> 
> Regards
> Haojian

Will you submit a patch to move it by yourself or let me update the patch to 
move it to drivers/clocksource in next version?

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
