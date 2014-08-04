Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaHDS63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 14:58:29 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:42647 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaHDS62 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 14:58:28 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Robert Baldyga <r.baldyga@samsung.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "andrzej.p@samsung.com" <andrzej.p@samsung.com>
Subject: RE: [PATCH v3 00/12] usb: dwc2/gadget: fix series
Thread-Topic: [PATCH v3 00/12] usb: dwc2/gadget: fix series
Thread-Index: AQHPonz7gqe01pljGkOIwrls9oIhIJumNHEggBqw+mA=
Date: Mon, 4 Aug 2014 18:58:23 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844C400E@US01WEMBX2.internal.synopsys.com>
References: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com> 
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

> From: Paul Zimmerman
> Sent: Friday, July 18, 2014 12:19 PM
> 
> > From: Robert Baldyga [mailto:r.baldyga@samsung.com]
> > Sent: Friday, July 18, 2014 4:39 AM
> >
> > This patchset contains fixes for dwc2 gadget driver. It touches PHY,
> > FIFO configuration, initialization sequence and adds many other small fixes.
> >
> > Best regards
> > Robert Baldyga
> > Samsung R&D Institute Poland
> >
> > Changelog:
> > v3:
> >  - use endpoint index instead of FIFO index for EPFIFO
> >  - extend patch description
> >
> > v2: https://lkml.org/lkml/2014/7/16/199
> >  - add patch usb: dwc2/gadget: avoid disabling ep0
> >  - fix FIFO flushing when it's assigned to endpoint dynamically
> >  - write to proper FIFO in s3c_hsotg_write_fifo() function
> >  - use real FIFO size in kill_all_requests
> >  - fix comment in s3c_hsotg_init_fifo() function
> >
> > v1: https://lkml.org/lkml/2014/6/23/67
> >
> > Andrzej Pietrasiewicz (1):
> >   usb: dwc2/gadget: Fix comment text
> >
> > Kamil Debski (3):
> >   usb: dwc2/gadget: fix phy disable sequence
> >   usb: dwc2/gadget: fix phy initialization sequence
> >   usb: dwc2/gadget: move phy bus legth initialization
> >
> > Marek Szyprowski (5):
> >   usb: dwc2/gadget: hide some not really needed debug messages
> >   usb: dwc2/gadget: ensure that all fifos have correct memory buffers
> >   usb: dwc2/gadget: break infinite loop in endpoint disable code
> >   usb: dwc2/gadget: do not call disconnect method in pullup
> >   usb: dwc2/gadget: delay enabling irq once hardware is configured properly
> >
> > Robert Baldyga (3):
> >   usb: dwc2/gadget: assign TX FIFO dynamically
> >   usb: dwc2/gadget: disable clock when it's not needed
> >   usb: dwc2/gadget: avoid disabling ep0
> >
> >  drivers/usb/dwc2/core.h   |   3 +
> >  drivers/usb/dwc2/gadget.c | 184 +++++++++++++++++++++++++++-------------------
> >  2 files changed, 111 insertions(+), 76 deletions(-)
> 
> For the entire series:
> 
> Acked-by: Paul Zimmerman <paulz@synopsys.com>

Hi Greg,

I don't see this series from Robert in your tree yet. Is it still in
your queue, or should Robert resend it?

-- 
Paul

