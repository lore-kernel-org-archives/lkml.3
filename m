Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaHSR5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:57:49 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:35488 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaHSR5r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:57:47 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Robert Baldyga <r.baldyga@samsung.com>, "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "andrzej.p@samsung.com" <andrzej.p@samsung.com>
Subject: RE: [PATCH RESEND v3 00/12] usb: dwc2/gadget: fix series
Thread-Topic: [PATCH RESEND v3 00/12] usb: dwc2/gadget: fix series
Thread-Index: AQHPu4tEm7Xp0r8L0ECcLL9ohLDz0JvYEGYQgAB/hgD//6aU4A==
Date: Tue, 19 Aug 2014 17:56:47 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844C8D61@US01WEMBX2.internal.synopsys.com>
References: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844C8CA5@US01WEMBX2.internal.synopsys.com>
 <20140819161546.GA32151@kroah.com>
In-Reply-To: <20140819161546.GA32151@kroah.com>
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
> Sent: Tuesday, August 19, 2014 9:16 AM
> 
> On Tue, Aug 19, 2014 at 03:46:58PM +0000, Paul Zimmerman wrote:
> > > From: Robert Baldyga [mailto:r.baldyga@samsung.com]
> > > Sent: Tuesday, August 19, 2014 1:54 AM
> > >
> > > Hi Paul,
> > >
> > > I'm resending this patchset rebased on linux-next. Now it should apply.
> > >
> > > Thanks,
> > > Robert Baldyga
> > >
> > > Changelog:
> > > v3: https://lkml.org/lkml/2014/8/4/617
> > > - use endpoint index instead of FIFO index for EPFIFO
> > > - extend patch description
> > >
> > > v2: https://lkml.org/lkml/2014/7/16/199
> > > - add patch usb: dwc2/gadget: avoid disabling ep0
> > > - fix FIFO flushing when it's assigned to endpoint dynamically
> > > - write to proper FIFO in s3c_hsotg_write_fifo() function
> > > - use real FIFO size in kill_all_requests
> > > - fix comment in s3c_hsotg_init_fifo() function
> > >
> > > v1: https://lkml.org/lkml/2014/6/23/67
> > >
> > > Andrzej Pietrasiewicz (1):
> > >   usb: dwc2/gadget: Fix comment text
> > >
> > > Kamil Debski (3):
> > >   usb: dwc2/gadget: fix phy disable sequence
> > >   usb: dwc2/gadget: fix phy initialization sequence
> > >   usb: dwc2/gadget: move phy bus legth initialization
> > >
> > > Marek Szyprowski (5):
> > >   usb: dwc2/gadget: hide some not really needed debug messages
> > >   usb: dwc2/gadget: ensure that all fifos have correct memory buffers
> > >   usb: dwc2/gadget: break infinite loop in endpoint disable code
> > >   usb: dwc2/gadget: do not call disconnect method in pullup
> > >   usb: dwc2/gadget: delay enabling irq once hardware is configured
> > >     properly
> > >
> > > Robert Baldyga (3):
> > >   usb: dwc2/gadget: assign TX FIFO dynamically
> > >   usb: dwc2/gadget: disable clock when it's not needed
> > >   usb: dwc2/gadget: avoid disabling ep0
> > >
> > >  drivers/usb/dwc2/core.h   |   3 +
> > >  drivers/usb/dwc2/gadget.c | 184 +++++++++++++++++++++++++++-------------------
> > >  2 files changed, 111 insertions(+), 76 deletions(-)
> >
> > Thanks Robert.
> >
> > For the entire series,
> > Acked-by: Paul Zimmerman <paulz@synopsys.com>
> >
> > Greg, can you please apply this to your usb-next tree? Thanks.
> 
> For 3.17-final, or 3.18-rc1?

For 3.18-rc1. Thanks.

-- 
Paul

