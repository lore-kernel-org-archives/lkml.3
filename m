Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbaFYLOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:14:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36706 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754073AbaFYLOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:14:49 -0400
Date: Wed, 25 Jun 2014 12:14:43 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rajendra Nayak <rnayak@ti.com>, Nishanth Menon <nm@ti.com>,
        Sricharan R <r.sricharan@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/2] arm: dts: am4372: let boards access all nodes
 through phandles
Message-ID: <20140625111443.GG14495@leverpostej>
References: <1403547659-24558-1-git-send-email-balbi@ti.com>
 <1403547659-24558-2-git-send-email-balbi@ti.com>
 <CAL_JsqJx_DJqxpEJebi0Etfv5g7=eYje_53vd_44GykreA-rkQ@mail.gmail.com>
 <20140625014016.GA21616@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140625014016.GA21616@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 02:40:16AM +0100, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Jun 24, 2014 at 04:11:48PM -0500, Rob Herring wrote:
> > On Mon, Jun 23, 2014 at 1:20 PM, Felipe Balbi <balbi@ti.com> wrote:
> > > by providing phandles to rtc, wdt, cpu and dispc nodes,
> > > boards can access them to add board-specific data.
> > 
> > Strictly speaking, you are adding labels, not phandles. You can do
> 
> heh, fair point. Easily editable when applying, though (?)
> 
> > phandles without using labels, but the syntax is not so obvious. I'd
> > tell you what it is but offhand I don't remember. :)
> 
> something along the lines of using the full path ?

Yup. The full path in braces:

	phandle-property = <&{/full/path/to/node@0xDEAD}>;

Mark.
