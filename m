Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbaEPQrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:47:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42016 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752032AbaEPQry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:47:54 -0400
Date: Fri, 16 May 2014 18:47:51 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] Documentation: add the Marvell Berlin pinctrl
 documentation
Message-ID: <20140516164751.GA8406@kwain>
References: <1399267649-20218-1-git-send-email-antoine.tenart@free-electrons.com>
 <1399267649-20218-7-git-send-email-antoine.tenart@free-electrons.com>
 <CACRpkdaL9tzfUrY=wLjSR3dcD7JC1mUX3kdG+Wh5gDyxGY2Yqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaL9tzfUrY=wLjSR3dcD7JC1mUX3kdG+Wh5gDyxGY2Yqw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Fri, May 16, 2014 at 03:35:48PM +0200, Linus Walleij wrote:
> On Mon, May 5, 2014 at 7:27 AM, Antoine Ténart
> <antoine.tenart@free-electrons.com> wrote:
> 
> > Add the documentation related to the Berlin pin-controller driver and
> > explain how to configure this group based controller.
> >
> > Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> > Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> (...)
> 
> When I see this:
> 
> > +Required subnode-properties:
> > +- marvell,groups: a list of strings describing the group names.
> > +- marvell,function: a string describing the function used to mux the groups.
> > +
> > +Example:
> > +
> > +sm_pinctrl: pin-controller@0 {
> > +       compatible = "marvell,berlin2q-sysmgr-pinctrl";
> > +       reg = <0xfc0000 0x44>;
> > +
> > +       uart0_pmux: uart0-pmux {
> > +               marvell,groups = "GSM12", "GSM13";
> > +               marvell,function = "uart0";
> > +       };
> > +}
> 
> I feel like ... can't we just standardize that and make it a common
> pinctrl binding, and name the properties "groups" and "function"
> for a family of pin controllers just mapping N groups to 1 function?
> 
> I will merge the patches as are, but maybe we can make it generic
> on top of this before the merge window?

Do you mean just changing:

s/marvell,groups/groups/
s/marvell,function/function/

and updating the documentation ?

If so, I can definitely do that.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
