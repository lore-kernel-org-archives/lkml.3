Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbaDKIY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:24:27 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:53817 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbaDKIYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:24:24 -0400
Date: Fri, 11 Apr 2014 10:22:18 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: Jisheng Zhang <jszhang@marvell.com>, Jimmy Xu <zmxu@marvell.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH RESEND 4/5] Documentation: add the Marvell Berlin pinctrl
 documentation
Message-ID: <20140411082218.GM10240@lunn.ch>
References: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com>
 <1397135274-10764-5-git-send-email-antoine.tenart@free-electrons.com>
 <20140411143318.67e55a17@xhacker>
 <20140411081259.GA20147@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140411081259.GA20147@kwain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 10:12:59AM +0200, Antoine Ténart wrote:
> Hi Jisheng,
> 
> On Fri, Apr 11, 2014 at 02:33:18PM +0800, Jisheng Zhang wrote:
> > On Thu, 10 Apr 2014 06:07:53 -0700
> > Antoine Ténart <antoine.tenart@free-electrons.com> wrote:
> > > +Required subnode-properties:
> > > +- berlin,group: a string describing the group's name.
> > > +- berlin,function: the function used to mux the group.
> > 
> > Would it be better to s/function/mode? Because in mrvl internal technology
> > discussion and docs, we usually say "set pinmux Gy as mode z".
> 
> The pinctrl framework uses 'function', so I guess it's better not to introduce
> an other keyword that may confuse people.

Agreed. DT is a standard, Marvell datasheets are just datasheets.

> But I agree this is not what's used in the Marvell's docs. What do
> you think about we mention it in this documentation ?

Or ask for the datahsheet to be changed :-)

   Andrew
