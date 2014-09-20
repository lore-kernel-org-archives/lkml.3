Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbaITOH0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 10:07:26 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:43977 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754054AbaITOHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 10:07:24 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Q7FYRv4A+eG766sXExy2F
Date: Sat, 20 Sep 2014 07:07:12 -0700
From: Tony Lindgren <tony@atomide.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Nishanth Menon <nm@ti.com>, lee.jones@linaro.org,
        LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>, Mark Brown <broonie@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-omap@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH V3 3/3] mfd: palmas: Add support for optional wakeup
Message-ID: <20140920140712.GA27096@atomide.com>
References: <1411067086-16613-4-git-send-email-nm@ti.com>
 <alpine.DEB.2.10.1409181749170.4206@nanos>
 <20140919030333.GA6088@kahuna>
 <alpine.DEB.2.10.1409190710320.5612@nanos>
 <20140919161927.GA28613@kahuna>
 <alpine.DEB.2.10.1409191027330.5612@nanos>
 <20140919191649.GQ14505@atomide.com>
 <alpine.DEB.2.10.1409191233590.4213@nanos>
 <20140919195738.GR14505@atomide.com>
 <alpine.DEB.2.10.1409192100380.23826@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1409192100380.23826@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner <tglx@linutronix.de> [140919 19:08]:
> On Fri, 19 Sep 2014, Tony Lindgren wrote:
> > * Thomas Gleixner <tglx@linutronix.de> [140919 12:47]:
> > > Why on earth are you wanting tasklets in there? That's just silly,
> > > really.
> > 
> > Lack of a framework on driver side to cope with this in a generic
> > way? :p
> 
> So instead of creating such a thing we rather have a completely ass
> backward workaround which spreads itself all over the tree?

I'm not kidding, you're the first one who was able to come up with
such a simple solution and also describe why it should be done
that way.
 
> You SoC folks really need a quarterly sanity check.

Probably time for me to file a bios bug on that yeah :)

Regards,

Tony
