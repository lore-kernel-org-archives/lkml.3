Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbaABAZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 19:25:48 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:46901 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbaABAZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 19:25:46 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+zBYQz7wUG6+jZAm7l3h2AW3Iqfdi4fbA=
X-DKIM: OpenDKIM Filter v2.0.1 titan 7A5824FFB3E
Date: Wed, 1 Jan 2014 19:25:15 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Gerhard Sittig <gsi@denx.de>, Herbert Xu <herbert@gondor.apana.org.au>,
        Randy Dunlap <rdunlap@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Christian Hohnstaedt <chohnstaedt@innominate.com>,
        Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [ARM] Fix kernel compile error: drivers/crypto/ixp4xx_crypto.c.
Message-ID: <20140102002515.GD19878@titan.lakedaemon.net>
References: <m3d2kduwd7.fsf@t19.piap.pl>
 <20131231134820.GS8064@book.gsilab.sittig.org>
 <52C3066E.1070909@infradead.org>
 <20140101123746.GB20094@book.gsilab.sittig.org>
 <20140101124625.GF16456@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140101124625.GF16456@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 01, 2014 at 12:46:25PM +0000, Russell King - ARM Linux wrote:
> On Wed, Jan 01, 2014 at 01:37:46PM +0100, Gerhard Sittig wrote:
> > Last time I checked (few days ago, 'git grep -w Fixes:') it
> > wasn't, at least not within the kernel source tree and its
> > Documentation hierarchy.  Today's master still does not have it.
> > 
> > But a quick search in recent LAKML messages reveals that it's
> > been in use by e.g. Olof Johansson, Jason Cooper, Rusty Russell,
> > Dan Carpenter, Russell King, Mark Brown, Stephen Warren, Paul
> > Walmsley, and I'm not making this up but am just referring to
> > what repeatedly was requested in the past.  The form used there
> > was "Fixes: <hash> (<oneline>)" though.  A doc update may be due
> > to have a canonical format.
> 
> It was discussed at kernel summit, and I believe the resulting format
> was only published in one of the kernel summit mailing lists.  The
> outcome of it as I understand was that the format is:
> 
> Fixes: <hash> ("<one line summary>")

fwiw, Linus also recommended setting core.abbrev = 12.

thx,

Jason.
