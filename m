Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936560Ab3DJUV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:21:29 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56226 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936370Ab3DJUV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:21:27 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/sQ9zI5LPdebqNTkfQkGSn
Date: Wed, 10 Apr 2013 13:21:21 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Roger Quadros <rogerq@ti.com>, Mike Turquette <mturquette@linaro.org>,
        linux-usb@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org,
        lkml <linux-kernel@vger.kernel.org>, balbi@ti.com,
        grygorii.strashko@ti.com, linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support
 for AUXCLKs
Message-ID: <20130410202121.GM10155@atomide.com>
References: <20130405155851.GA10155@atomide.com>
 <5163E589.1040809@ti.com>
 <20130409164928.GL10155@atomide.com>
 <20130409174319.GP10155@atomide.com>
 <20130409204900.GA8815@kahuna>
 <20130410080630.14359.68178@quantum>
 <5165453E.6090503@ti.com>
 <20130410173921.GA31017@kahuna>
 <20130410184919.GJ10155@atomide.com>
 <CAGo_u6rqN6YFQ6vX87-Cg28RbiR9UU2JHgLecOU5Nd=B5XPUEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGo_u6rqN6YFQ6vX87-Cg28RbiR9UU2JHgLecOU5Nd=B5XPUEA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [130410 12:23]:
> On Wed, Apr 10, 2013 at 1:49 PM, Tony Lindgren <tony@atomide.com> wrote:
> >
> > We can avoid the concern of storing the struct clk * and do the
> > look up lazily on consumer driver probe by setting a dummy struct
> > clk * here. Then replace of_clk_src_simple_get() with a custom
> > omap_clk_src_get() that does the lookup and replaces the struct
> > clk * with the real one.
> Hmm.. this is interesting. will give it a try. Thanks on the suggestion.

Setting the struct clk * to NULL initially might work too, but that
needs to be checked.

Regards,

Tony
