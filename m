Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbaDKINX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:13:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44077 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755547AbaDKIND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:13:03 -0400
Date: Fri, 11 Apr 2014 10:12:59 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 4/5] Documentation: add the Marvell Berlin pinctrl
 documentation
Message-ID: <20140411081259.GA20147@kwain>
References: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com>
 <1397135274-10764-5-git-send-email-antoine.tenart@free-electrons.com>
 <20140411143318.67e55a17@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140411143318.67e55a17@xhacker>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jisheng,

On Fri, Apr 11, 2014 at 02:33:18PM +0800, Jisheng Zhang wrote:
> On Thu, 10 Apr 2014 06:07:53 -0700
> Antoine Ténart <antoine.tenart@free-electrons.com> wrote:
> > +Required subnode-properties:
> > +- berlin,group: a string describing the group's name.
> > +- berlin,function: the function used to mux the group.
> 
> Would it be better to s/function/mode? Because in mrvl internal technology
> discussion and docs, we usually say "set pinmux Gy as mode z".

The pinctrl framework uses 'function', so I guess it's better not to introduce
an other keyword that may confuse people. But I agree this is not what's used in
the Marvell's docs. What do you think about we mention it in this documentation ?

Thanks for the feedback !

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
