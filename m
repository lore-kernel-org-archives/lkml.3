Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaAGOec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:34:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63872 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaAGOeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:34:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org, sahara <keun-o.park@windriver.com>
Subject: Re: [PATCH 19/19] [INCOMPLETE] ARM: make return_address available for ARM_UNWIND
Date: Tue, 7 Jan 2014 15:33:34 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Keun-O Park" <kpark3469@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Dave Martin <Dave.Martin@arm.com>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <20130128125023.GA2027@linaro.org> <CA+KhAHYvbxANa84FMDVV96udwhif2P2_XirPhWVWTKy_8iK72A@mail.gmail.com>
In-Reply-To: <CA+KhAHYvbxANa84FMDVV96udwhif2P2_XirPhWVWTKy_8iK72A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401071533.35309.arnd@arndb.de>
X-Provags-ID: V02:K0:IClRoAyqG2I+QhOYvw1/in1a8kklY1D/2Z03lvAgcvu
 8sutnxRqyv3ZV3d43gyqX7x5srWRZVDcbGW3GWZob5UCF8x70U
 PC5+Ma4RdAQBVvJ50XzVCn/14pwNAXLhS4Vv3zcQGTADpOQwmr
 VrWa/xN0q6E+PUjunQ3ETVyNm9jvm5rom5R+QCuVbSqUOpyMJt
 raOAUP5YcyIvKRMgugGftX9nlcz7x0up4+42r33S5Fx2E+Prvf
 iIcQWKbDYxTQ/xjbGTHlpKiHBSMtEUf3wFFWgO2nxz4GiGpIKZ
 jQXjISPqO62FabIoe1EjsWBQroL12IGql77tqZLoeNGZvweBk/
 hINnVsitErfeYPHjLlTg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2013, Keun-O Park wrote:
> On Mon, Jan 28, 2013 at 9:50 PM, Dave Martin <dave.martin@linaro.org> wrote:
> > On Mon, Jan 28, 2013 at 11:33:11AM +0900, Keun-O Park wrote:
> >> Hello guys,
> >>
> >> Could you please review the patch of fixing bug first of returning
> >> wrong address when using frame pointer?
> >> I am wondering if the first patch is not delivered to the mailing.
> >
> > I posted a similar patch to alkml a couple of months ago, but I got
> > no response and it looks like I forgot about it.
> >
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2012-November/129381.html
> 
> Yes, same except initialization of data.addr. :)
> This means there might be no one interested in using
> ftrace-irqsoff/premptoff in ARM during a couple of months?


It's been almost a year since we last discussed the patches that were
posted by Dave and sahara, but nothing has changed in the mainline kernel.

Any chance that someone could be motivated to pick this work up again
and finally fix return_address().

	Arnd
