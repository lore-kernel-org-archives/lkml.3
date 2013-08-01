Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab3HAKKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:10:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39315 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3HAKKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:10:14 -0400
Date: Thu, 1 Aug 2013 11:09:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
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
        Olof Johansson <olof@lixom.net>, mbizon@freebox.fr,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130801100956.GL9858@sirena.org.uk>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <1999586.84BnWE5EUh@thinkpad>
 <20130731191209.GA8027@netboy>
 <1409617.9untvfnOTJ@flatron>
 <20130731200017.GC8027@netboy>
 <20130731201457.GA24642@n2100.arm.linux.org.uk>
 <CAKON4Ow7rE9cDj_tS7kmYN4incM+ay=BK96q-ph2JxYH3xiQzg@mail.gmail.com>
 <20130731204817.GC24642@n2100.arm.linux.org.uk>
 <CAKON4Ozfe=endqnXWkcWR2HuJ489Otpcu2QsjB0DNg6jpRgG+Q@mail.gmail.com>
 <51FA3117.1080905@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ooHSKNPLSqqBf85v"
Content-Disposition: inline
In-Reply-To: <51FA3117.1080905@broadcom.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ooHSKNPLSqqBf85v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 01, 2013 at 11:57:43AM +0200, Arend van Spriel wrote:
> On 07/31/2013 11:26 PM, jonsmirl@gmail.com wrote:

> >Alternatively you may be of the belief that it is impossible to get
> >rid of the board specific code. But x86 doesn't have any of it, why
> >should ARM?

> Well, I am curious whether that will stay that way once x86 is truly
> moving into the embedded arena (if ever).

There's shipping phones using x86, they do actually have board code due
to their use of SFI.

--ooHSKNPLSqqBf85v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+jPxAAoJELSic+t+oim91DAP+waZkqqd9zcYkdRHw+p1guOY
F/oIKtB/uC09T2OPBoJ19Fq6ia7TD/dowzUODks0cx6j4tiZ90DRn9M+5OIfUFLM
yCw18A8VnlaKm/bg9BTCFSnHXREZNSJ6eXYvn0c9Fb2KXJEIb8zCrHTKMsiLQKDN
6o7TZmA+tnkSvVBahc4XTQtVbitjQPG82YZnpq1+5ragJXq9mWgOFyr0XTf3B/d8
3JUctNvE9rx3OF6BgER3/Lg9RQi+CAbbvJkBcEkAX0oAAGNs4R77Y/RH1fkcaK//
8PhShSnmJHT8/2AAjJ2isdrgN09ElKEiQlszGNKEGcobC7/PQ+a7awPicpbRi9W3
uSkHcl8v3MeBs8u4ddsB1ekAXy4mYh/F9F6OOZ7rVmg/O4PiMVdMaOIdHoS9P1Th
ALEjKciyb1EbhJ/EDg9sPmIAttxW3+EpNtJHzkOtjgD6YSSstSXnBaScwyquFnso
wk8r6/yPNj1rin6s6oIS3g2f1UtsUXkiX74BxiVNn0sAjuCT+YpHQcOyBSrsE2Ed
2Mf7WMpkgEGZywiewf/JoHQ/8fZQs6eyOMTUgI1+ALO7GPbxDHBP5m57n10FJ0hg
0AuzRxzSkvQ/t/NGPoOzWj966EP3PHVqzhNMtJ//aFtKtrvACr7fccfvnGEvnW57
+c/U1x8wQ5DwLnEKJ7Ev
=04vz
-----END PGP SIGNATURE-----

--ooHSKNPLSqqBf85v--
