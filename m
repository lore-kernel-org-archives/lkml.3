Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbaIKUic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 16:38:32 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:35223 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbaIKUib convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 16:38:31 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Robert Baldyga <r.baldyga@samsung.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>
Subject: RE: [PATCH 0/2] usb: dwc2: Revert patches causing problems
Thread-Topic: [PATCH 0/2] usb: dwc2: Revert patches causing problems
Thread-Index: AQHPzb9uAjbYlQN8gkubjUs9hysZ/5v8S7ZQgACJmID//4tioA==
Date: Thu, 11 Sep 2014 20:38:29 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844D6718@US01WEMBX2.internal.synopsys.com>
References: <1410440011-9106-1-git-send-email-r.baldyga@samsung.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844D6693@US01WEMBX2.internal.synopsys.com>
 <20140911201945.GA7349@kroah.com>
In-Reply-To: <20140911201945.GA7349@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, September 11, 2014 1:20 PM
> 
> On Thu, Sep 11, 2014 at 07:11:20PM +0000, Paul Zimmerman wrote:
> > > From: Robert Baldyga [mailto:r.baldyga@samsung.com]
> > > Sent: Thursday, September 11, 2014 5:53 AM
> > >
> > > These two patches breaks dwc2 driver. The first one causes build break,
> > > the second breaks gadget at Samsung platforms.
> > >
> > > Best regards
> > > Robert Baldyga
> > >
> > > Robert Baldyga (2):
> > >   Revert "usb: dwc2: Update Kconfig to support dual-role"
> > >   Revert "usb: dwc2: move "samsung,s3c6400-hsotg" into common platform"
> > >
> > >  drivers/usb/dwc2/Kconfig    | 63 +++++++++++++++++++--------------------------
> > >  drivers/usb/dwc2/Makefile   | 21 +++++++--------
> > >  drivers/usb/dwc2/gadget.c   |  1 +
> > >  drivers/usb/dwc2/platform.c |  1 -
> > >  4 files changed, 38 insertions(+), 48 deletions(-)
> >
> > Yep, I can confirm the build breakage. Greg, we should revert these two
> > before you send your update for the next -rc, if it's not too late.
> >
> > Dinh, before resending the series, please test that each individual
> > patch does not break the build.
> 
> I tested and didn't see the build breakage on my end, but I don't
> test-build arm stuff...
> 
> Anyway, this is in the usb-next branch, not usb-linus, right?

Oops, yes, you're right. So not so urgent I guess. I think we should
still revert, though. The two patches break -next, and are pointless
without the rest of the series.

-- 
Paul

