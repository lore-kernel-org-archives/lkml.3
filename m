Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab3GZN6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:58:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39795 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab3GZN6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:58:07 -0400
Date: Fri, 26 Jul 2013 14:57:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130726135734.GE9858@sirena.org.uk>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <CAL_JsqJQWOLC9f1igEpsgJB2X8mFDpqLDaFFRjGGVHctjWZLgQ@mail.gmail.com>
 <20130725193135.GT23879@titan.lakedaemon.net>
 <20130725231848.GJ24642@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O4mGAVrr2vwGVaZ3"
Content-Disposition: inline
In-Reply-To: <20130725231848.GJ24642@n2100.arm.linux.org.uk>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in	device tree janitoring / cleanup?]
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O4mGAVrr2vwGVaZ3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 26, 2013 at 12:18:48AM +0100, Russell King - ARM Linux wrote:

> It's actually extremely simple.  If the bindings are in development,
> they must not appear in a -final released kernel.  Anything that appears
> in a -final kernel becomes part of the ABI at that point.

Of course from that point of view there's also an argument that once
people have shipped something on a device or generally out of the review
process then we have to support it no matter how depressing their
choices may have been.

--O4mGAVrr2vwGVaZ3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8oBLAAoJELSic+t+oim9nkYP/2+KGeINvPKIBntBA06VyYCP
loW9ENn0lCGYhea5PNkPAv5FyrpiWRIdU+t/VztkoCLz7CG+48qBjzEA9vD8uavk
2RrZSznQbF2KQLWLswy/TjJR9AXEYu/R4tLLIKCprDDuGx55z6+OoMhcm5LdDJCg
iN/xXmiO92Wr8kK94aF24rmzcdwXRzubOVFzgeVHim3+k0G76OsxxPdNSAbbaQZN
4AwFgA2iA3LD3f3unqtl+chGAV52LVQqm3ybggj+NscKRyb61RsXq8gBdm+kWDQ3
tSzEZbHXoSoscs04urgmxHFi8boDN/NclSMwQaeW799NUQ9PPN16oSxZL8+ZJcr+
dGc7toeUuHtkPglJm6CdSHd6t8KStYECvw+Ag40BsseSk8YriWetpNSa1kmLcd53
LROwscq3gfUuiqHYfPV3jIY8+qi6W7JFvV4cIMrierv0tjva51QFCZEa+cpIL6xR
gI79jninnRVUSh2OueEZxnHHw8Z7UjTxfrE1vOMaknXR8WE7mSkMsY+Y3TmAwy4Q
VVhy0j/fJCOAsSvkOkPs/rhvMNPgMdOj5HpV2eg/wwbEBrfduRD/VSBhEmcvbnJt
hZa3OYCsiHkVGXrK9+TTmlvcgcGmPfRPMSIEtJMIyVcGvw40KzAAWdGa5RR4/PYk
IN5sdpsS0klTGd6Z/6nt
=/YFf
-----END PGP SIGNATURE-----

--O4mGAVrr2vwGVaZ3--
