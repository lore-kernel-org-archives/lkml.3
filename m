Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaH2NFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:05:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53283 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbaH2NFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:05:08 -0400
Date: Fri, 29 Aug 2014 14:03:54 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Matti Vaittinen <matti.vaittinen@nsn.com>,
        ext Guenter Roeck <linux@roeck-us.net>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "arno@natisbad.org" <arno@natisbad.org>,
        "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>,
        "san@rosetechnology.dk" <san@rosetechnology.dk>,
        "hs@denx.de" <hs@denx.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Sverdlin Alexander <alexander.sverdlin@nsn.com>
Subject: Re: [PATCH] rtc: ds1307: add trickle charger device tree binding
Message-ID: <20140829130354.GE21473@leverpostej>
References: <20140828155157.GB23677@roeck-us.net>
 <20140828161025.GO14650@leverpostej>
 <20140828164825.GA12153@roeck-us.net>
 <20140828172842.GF12769@titan.lakedaemon.net>
 <20140828174034.GC15307@roeck-us.net>
 <20140829073413.GN4587@fi-ourus-dhcp00977.emea.nsn-net.net>
 <20140829104001.GB19424@leverpostej>
 <20140829122452.GA3683@titan.lakedaemon.net>
 <20140829124216.GD21473@leverpostej>
 <20140829124829.GD3683@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140829124829.GD3683@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 01:48:29PM +0100, Jason Cooper wrote:
> On Fri, Aug 29, 2014 at 01:42:16PM +0100, Mark Rutland wrote:
> > On Fri, Aug 29, 2014 at 01:24:52PM +0100, Jason Cooper wrote:
> > > On Fri, Aug 29, 2014 at 11:40:02AM +0100, Mark Rutland wrote:
> ...
> Someone wrote:
> > > > > > > > http://datasheets.maximintegrated.com/en/ds/DS1307.pdf
> > > > > > > > http://datasheets.maximintegrated.com/en/ds/DS1337.pdf
> > > > > > > > http://datasheets.maximintegrated.com/en/ds/DS1338.pdf
> > > > > > > > http://datasheets.maximintegrated.com/en/ds/DS1339.pdf
> > > > > > > > http://datasheets.maximintegrated.com/en/ds/DS1340.pdf
> > > > > > > > http://datasheets.maximintegrated.com/en/ds/DS1388.pdf
> > > > > > > > http://datasheets.maximintegrated.com/en/ds/DS3231.pdf
> ...
> > > > I would suggest we have two properties that describe the resistor's
> > > > rating and whether or not there is a diode:
> > > > 
> > > > trickle-resistor-ohms = <250>
> > > > diode-connected;
> > > 
> > > I much prefer this solution over my own suggestion.  With one small
> > > change, s/diode-connected/trickle-diode-enable/  Does that sound ok?
> > 
> > I'm not too keen on 'enable'; I was under the impression that this
> > described whether or not there was an external diode. Perhaps I've
> > misunderstood?
> 
> iiuc from the link ds1339 ds, the register configuration is enabling
> internal diodes and resistors for the trickle charge configuration.  I
> may have read it incorrectly, though.

Ok.

> In either case, my main point was to prepend 'trickle-' to the property
> to more accurately describe what it is toggling.

That's fine by me. My only concern was 'enable' due to the
internal/external confusion.

Thanks,
Mark.
