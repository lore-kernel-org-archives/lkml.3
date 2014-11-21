Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbaKUHfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 02:35:13 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:44823 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbaKUHfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 02:35:11 -0500
Message-ID: <1416555331.28873.8.camel@mm-sol.com>
Subject: Re: [PATCH 3/7] pinctrl: pinconf-generic: Allow driver to specify
 DT params
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: =?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Date: Fri, 21 Nov 2014 09:35:31 +0200
In-Reply-To: <7e2f4984733343fdb4ea51cf7eb4c339@BY2FFO11FD046.protection.gbl>
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
	 <1415041531-15520-4-git-send-email-soren.brinkmann@xilinx.com>
	 <CACRpkdYfj2ydLQ4q_FKwXo73jzNsvj9u2Aem9EiuEw-OCvurrg@mail.gmail.com>
	 <1416300621.30131.6.camel@mm-sol.com>
	 <995406b8e0244c63a3ef8e58314e81f6@BL2FFO11FD037.protection.gbl>
	 <1416383379.30131.14.camel@mm-sol.com>
	 <84517404cda34124930ec838a639f538@BL2FFO11FD030.protection.gbl>
	 <1416470777.28873.1.camel@mm-sol.com>
	 <7e2f4984733343fdb4ea51cf7eb4c339@BY2FFO11FD046.protection.gbl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.7-fta1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2014-11-20 at 08:22 -0800, Sören Brinkmann wrote:
> 
> 
> Also, I hope all my changes here don't break the current behavior. So,
> those 27 driver should still be able to do what they currently do. But I
> hope they could migrated over to use the generic bindings only in the
> longer term, so that these custom properties disappear.
> 
> > > The pinctrl driver just assembles
> > > some data structure that has the information regarding custom properties
> > > and the core handles the rest.
> > 
> > Yup, that is nice. What will be really nice if it also handle custom,
> > "function", "groups" and "pins" properties. Otherwise most of the drivers
> > will not be able to benefit from this.
> 
> Why would you still need those? 

I don't need them :-). The point was that still majority of the drivers
will have custom parsing functions. It would be nice if we could fix
that too. I do understand that using custom "pins", "functions"... is
something which is deprecated, but if core parsing functions allow
passing custom strings for above purposes, in a similar way as your
proposal, it will be easier for those drivers to migrate, I believe.

Regards,
Ivan
