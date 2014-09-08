Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaIHSez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 14:34:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43310 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbaIHSey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 14:34:54 -0400
Date: Mon, 8 Sep 2014 13:34:21 -0500
From: Nishanth Menon <nm@ti.com>
To: Grazvydas Ignotas <notasas@gmail.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>, Keerthy <j-keerthy@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/10] ARM: OMAP5 / DRA7: Enable CPU RET on suspend
Message-ID: <20140908183421.GA31730@kahuna>
References: <1408716154-26101-1-git-send-email-nm@ti.com>
 <1408716154-26101-8-git-send-email-nm@ti.com>
 <7hbnr5dake.fsf@paris.lan>
 <53FE2BF2.3020006@ti.com>
 <20140827194156.GE16006@atomide.com>
 <53FE34D7.7040004@ti.com>
 <53FE3551.2080806@ti.com>
 <20140905211558.GA31011@kahuna>
 <CANOLnONWPdO80XWOYQatmOh+Ek107fBXDiqD3DpMXeazjLcdMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CANOLnONWPdO80XWOYQatmOh+Ek107fBXDiqD3DpMXeazjLcdMg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20:23-20140908, Grazvydas Ignotas wrote:
> On Sat, Sep 6, 2014 at 12:15 AM, Nishanth Menon <nm@ti.com> wrote:
> >
> > Hi,
> >
> > Updated patch below:
> > Do let me know if this is ok with folks.
> >
> > ---8<----
> > From 1b9e11834dac2bd75c396aa7495c806b027653fe Mon Sep 17 00:00:00 2001
> > From: Rajendra Nayak <rnayak@ti.com>
> > Date: Mon, 27 May 2013 15:46:44 +0530
> > Subject: [PATCH V2 7/10] ARM: OMAP5 / DRA7: Enable CPU RET on suspend
> >
> > On OMAP5 / DRA7, prevent a CPU powerdomain OFF and resulting MPU OSWR
> > and instead attempt a CPU RET and side effect, MPU RET in suspend.
> >
> > NOTE: the hardware was originally designed to be capable of achieving
> > deep power states such as OFF and OSWR, however due to various issues
> > and risks, deepest valid state was determined to be CSWR - hence we use
> 
> Would be great to have some more details here..

Sorry, I have no details that can be published publically. Lets say, "TI
refocus"?

> So there is no hope for OFF mode on OMAP5?

Yep, There is *NO* hope for OFF or OSWR on OMAP5/DRA7.

-- 
Regards,
Nishanth Menon
