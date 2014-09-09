Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbaIILmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:42:21 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:18253 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbaIILmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:42:20 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+/kDdyUFqWQYCeKBX7zKDOOlZRokGSoOo=
X-DKIM: OpenDKIM Filter v2.0.1 titan BE28D5DC2D4
Date: Tue, 9 Sep 2014 07:42:03 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Pavel Machek <pavel@denx.de>
Cc: Matti Vaittinen <matti.vaittinen@nsn.com>,
        ext Mark Rutland <mark.rutland@arm.com>,
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
Message-ID: <20140909114203.GL30828@titan.lakedaemon.net>
References: <20140828161025.GO14650@leverpostej>
 <20140828164825.GA12153@roeck-us.net>
 <20140828172842.GF12769@titan.lakedaemon.net>
 <20140828174034.GC15307@roeck-us.net>
 <20140829073413.GN4587@fi-ourus-dhcp00977.emea.nsn-net.net>
 <20140829104001.GB19424@leverpostej>
 <20140908135242.GA21412@amd>
 <20140908145825.GO12081@leverpostej>
 <20140909062158.GB21342@fi-ourus-dhcp00977.emea.nsn-net.net>
 <20140909113425.GC15404@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909113425.GC15404@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 01:34:25PM +0200, Pavel Machek wrote:
...
> > _Maybe_ 
> > diode-connected = <1>; or 
> > diode-connected = <0>; 
> 
> That should work.

meh.  The presence or absence of the property should express the
boolean.

The safe state should be the default (property absent), and the property
name should describe the state when the property is present.

thx,

Jason.
