Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaBYFMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 00:12:39 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:33201
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707AbaBYFMh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 00:12:37 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dIc89bh542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097hz2dh2a8h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
Date: Tue, 25 Feb 2014 12:17:31 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Neil Zhang <zhangwm@marvell.com>
CC: Matthieu CASTET <matthieu.castet@parrot.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] bug fix for mv_udc_core.c
Message-ID: <20140225041730.GA14793@shlinux1.ap.freescale.net>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
 <20140224113153.64c5a772@parrot.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC4133CD@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE54EC4133CD@SC-VEXCH4.marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 04:42:40AM -0800, Neil Zhang wrote:
> 
> > -----Original Message-----
> > From: Matthieu CASTET [mailto:matthieu.castet@parrot.com]
> > Sent: 2014年2月24日 18:32
> > To: Neil Zhang
> > Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH 0/6] bug fix for mv_udc_core.c
> > 
> > Le Mon, 24 Feb 2014 16:03:10 +0800,
> > Neil Zhang <zhangwm@marvell.com> a écrit :
> > 
> > > This patch set is mainly for bug fix.
> > >
> > > Neil Zhang (6):
> > >   usb: gadget: mv_udc: remove redundant pull up in udc_start
> > >   usb: gadget: mv_udc: disable HW zlt for ep0
> > >   usb: gadget: mv_udc: clear corresponding interrupt when flush fifo
> > >   usb: gadget: mv_udc: check endpoint before queue dtd
> > >   USB: gadget: mv_udc: workaroud for missing dTD
> > >   USB: gadget: mv_udc: fix corner case for missiong dTD
> > >
> > >  drivers/usb/gadget/mv_udc_core.c |   47
> > ++++++++++++++++++++++++++++++++++----
> > >  1 file changed, 42 insertions(+), 5 deletions(-)
> > >
> > 
> > Do you have plan to move to the chipidea udc driver ?
> > 
> > You could have some bug fix for free or share your bug fix with others.
> > 
> 
> 
> Not yet.
> Will estimate it later.
> > 

Freescale uses mv udc driver at u-boot, so the chipidea IP should be
compatible for two SoCs , both Intel and msm are using chipidea driver
at linux kernel, it should be not difficult for marvell to use it. 

For this patchset, some of them may already be fixed at chipidea driver
(3/6, 4/6), some of them may not (5/6, 6/6).

-- 

Best Regards,
Peter Chen

