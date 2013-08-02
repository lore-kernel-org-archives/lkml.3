Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab3HBE1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 00:27:40 -0400
Received: from ozlabs.org ([203.10.76.45]:56204 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab3HBE1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 00:27:38 -0400
Date: Fri, 2 Aug 2013 13:50:27 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arend van Spriel <arend@broadcom.com>, Mark Brown <broonie@kernel.org>,
        Olof Johansson <olof@lixom.net>, mbizon@freebox.fr,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130802035027.GA19115@voom.redhat.com>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <1999586.84BnWE5EUh@thinkpad>
 <20130731191209.GA8027@netboy>
 <1409617.9untvfnOTJ@flatron>
 <20130731200017.GC8027@netboy>
 <20130731201457.GA24642@n2100.arm.linux.org.uk>
 <CAKON4Ow7rE9cDj_tS7kmYN4incM+ay=BK96q-ph2JxYH3xiQzg@mail.gmail.com>
 <20130731204817.GC24642@n2100.arm.linux.org.uk>
 <CAKON4Ozfe=endqnXWkcWR2HuJ489Otpcu2QsjB0DNg6jpRgG+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <CAKON4Ozfe=endqnXWkcWR2HuJ489Otpcu2QsjB0DNg6jpRgG+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2013 at 05:26:47PM -0400, jonsmirl@gmail.com wrote:
> On Wed, Jul 31, 2013 at 4:48 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Wed, Jul 31, 2013 at 04:37:36PM -0400, jonsmirl@gmail.com
> wrote:
[snip]
> Alternatively you may be of the belief that it is impossible to get
> rid of the board specific code. But x86 doesn't have any of it, why
> should ARM?

Sure x86 has board specific code.  It's just that x86 basically only
has one board - PC.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iEYEARECAAYFAlH7LIMACgkQaILKxv3ab8aT3QCfZx5sxlhYiAf32+bRfDWGeNZK
tiUAn2Xo/QTNCgRW0/LPk+bWYWBQpsPU
=8Uwi
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
