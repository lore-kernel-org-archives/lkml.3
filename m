Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbaICTCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:02:49 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:44007 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752643AbaICTCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:02:48 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Vt0DO13f+E2ay8IyvCdKl
Date: Wed, 3 Sep 2014 12:02:34 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>, linux-omap@vger.kernel.org
Subject: Re: PROBLEM: bindings for drivers/mfd/twl4030-power.c
Message-ID: <20140903190234.GH11766@atomide.com>
References: <FAC7D7E5-1D05-4D63-821F-C56D3AAA8FF9@goldelico.com>
 <20140825212652.GR17254@atomide.com>
 <EBD1E2E6-E596-4B3D-B093-144ABDD7DEDE@goldelico.com>
 <20140903184527.GG11766@atomide.com>
 <54076311.2030306@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54076311.2030306@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140903 11:51]:
> On 09/03/2014 01:45 PM, Tony Lindgren wrote:
> > * Dr. H. Nikolaus Schaller <hns@goldelico.com> [140901 09:54]:
> >> Hi,
> >>
> >> Am 25.08.2014 um 23:26 schrieb Tony Lindgren:
> >>
> >>> * Dr. H. Nikolaus Schaller <hns@goldelico.com> [140817 08:46]:
> >>>> I am trying to make ti,use_poweroff work on 3.17-rc1 for the GTA04 board.
> >>>> Poweroff was broken for a while and I found that the driver isn't loaded at all.
> >>>>
> >>>> It appears to me that commit e7cd1d1eb16fcdf53001b926187a82f1f3e1a7e6
> >>>> did rename the compatible entry from "ti,twl4030-power" to "ti,twl4030-power-reset"
> >>>> but this was not documented in the bindings and of course our DT does not
> >>>> match.
> >>>>
> >>>> Even your commit message talks about "ti,twl4030-power" although I can't find it
> >>>> in the code.
> >>>
> >>> Hmm sorry did I accidentally remove ti,twl4030-power? If so, that should
> >>> be added back for sure. Do you have a patch for that already?
> >>
> >> No, I have only updated our device tree because I don't know if it really should
> >> be added back or not.
> >>
> >> As you say the "ti,twl4030-power" does not configure anything. So what
> >> is it good for?
> > 
> > Only for the poweroff if "ti,use_poweroff" is set. Care to do a patch
> > as you clearly have a use case to test it with?
> 
> Tony, we were talking about supporting ti,system-power-controller as
> the standard way of stating poweroff control is by the PMIC. this
> seems to be standard in various SoCs. use_poweroff seems to predate
> that standardization. Should'nt we start using
> ti,system-power-controller instead?

Sure we can add that. But need to keep also parsing "ti,use_poweroff"
as it's already in use.

Regards,

Tony
