Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaGHKCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 06:02:01 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43625 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaGHKCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 06:02:00 -0400
Date: Tue, 8 Jul 2014 13:01:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sanjeev sharma <sanjeevsharmaengg@gmail.com>
Cc: gregkh <gregkh@linuxfoundation.org>, devel <devel@driverdev.osuosl.org>,
        rmfrfs@gmail.com, "peter.senna" <peter.senna@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: Re: [PATCH] staging: rtl8192u: fix checkpatch error/warning in
 r819xU_phy.c
Message-ID: <20140708100142.GR25934@mwanda>
References: <1404799458-8574-1-git-send-email-sanjeev_sharma@mentor.com>
 <20140708074330.GD25880@mwanda>
 <CAGUYZuQgpNQRRg5X_AYv_iW5W60EdEwo0VOe3EJAPJocKrTf3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGUYZuQgpNQRRg5X_AYv_iW5W60EdEwo0VOe3EJAPJocKrTf3g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 03:18:40PM +0530, sanjeev sharma wrote:
> Hi Dan,
> 
> 
> On Tue, Jul 8, 2014 at 1:13 PM, Dan Carpenter <dan.carpenter@oracle.com>
> wrote:
> 
> > On Tue, Jul 08, 2014 at 11:34:18AM +0530, sanjeev sharma wrote:
> > > From: sanjeevs1 <sanjeev_sharma@mentor.com>
> >         ^^^^^^^^^
> > No.
> >
> > >
> > > This is a patch to the r819xU_phy.c file that fixes up all the
> > Error/Warning found by the checkpatch.pl tool
> >
> > Split it into one thing per patch.
> >
> 
> you mean to say Error and Warning should be fixed in separate patches ?

patch 1: remove useless returns
patch 2: too long lines
patch 3: fix sleep ranges
etc.

> > >       /* TODO: we should not delay such a long time. Ask for help from
> > SD3 */
> > > -     usleep_range(1000, 1000);
> > > +     usleep_range(1000, 2000);
> >
> > No.
> >
> > usleep_range(1000, 1001);
> Above could be best fit to resolve the checkpatch error because
> usleep_range() shouldn't use min ==max args; what you would suggest ?

Just leave it alone until someone who knows the answer and has the
hardware can change it.

> > Adapter->HalFunc.LedControlHandler(Adapter, LED_CTL_NO_LINK);
> > > +                                     Adapter->HalFunc.LedControlHandler
> > > +                                     (Adapter, LED_CTL_NO_LINK);
> >
> > The original was more readable.
> >
> Don't we need to focus on Warning rather then readability ?

No.  Readability first.

regards,
dan carpenter

