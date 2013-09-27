Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab3I0FVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 01:21:33 -0400
Received: from ozlabs.org ([203.10.76.45]:54826 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab3I0FV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 01:21:29 -0400
Date: Fri, 27 Sep 2013 15:17:18 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Kumar Gala <galak@codeaurora.org>,
        Jon Loeliger <jdl@jdl.com>, Olof Johansson <olof@lixom.net>,
        frowand.list@gmail.com, Tomasz Figa <tomasz.figa@gmail.com>,
        devicetree@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>
Subject: Re: [dtc PATCH V2] Warn on node name unit-address presence/absence
 mismatch
Message-ID: <20130927051718.GE2716@voom.fritz.box>
References: <1379613263-32080-1-git-send-email-swarren@wwwdotorg.org>
 <3D2FE31C-A6BB-4F70-9B3B-C55012CB56B3@codeaurora.org>
 <5244BF7A.4000100@wwwdotorg.org>
 <1380245438.28561.86.camel@pasglop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2qXFWqzzG3v1+95a"
Content-Disposition: inline
In-Reply-To: <1380245438.28561.86.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2qXFWqzzG3v1+95a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2013 at 11:30:38AM +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2013-09-26 at 17:12 -0600, Stephen Warren wrote:
> > Well, ePAPR seems pretty specific that unit address and reg are
> > related,
> > but says nothing about ranges in the section on node naming, nor about
> > node naming in the section about ranges.
> >=20
> > I'd claim that the existing PPC trees are nonconforming, and should be
> > fixed too:-)
>=20
> This is tricky, we should probably fix ePAPR here.
>=20
> If you have a "soc" bus covering a given range of addresses which it
> forwards to its children devices but doesn't have per-se its own
> registers in that area, then it wouldn't have a "reg" property. I would
> thus argue that in the absence of a "reg" property, if a "ranges" one is
> present, the "parent address" entry in there is an acceptable substitute
> for the "reg" property as far as unit addresses are concerned.

So, that's been accepted practice in fdt world for a while; I think
ePAPR already permits that, in fact.

> Also don't forget that in real OFW land, the unit address is something
> that's somewhat bus specific ... for example, PCI uses "dev,fn" rather
> than the full 96-bit number of the "reg" entry :-)
>=20
> Another option which would more strictly conform to ePAPR and in fact to
> of1275 would be to require such bus nodes to have a "reg" property with
> the address value set to the beginning of the range and the size value
> set to 0 :-)
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--2qXFWqzzG3v1+95a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSRRTdAAoJEGw4ysog2bOS4V8P/3sQ8pCeV10i7RR0u4wEBg7j
I9r5EVVegLN6svDp97tCrUu9B4DECDchwk4zXjwU4YJ7cnBFVP4dQqzkhfyFTwG6
9RlzlJV/ewDf9Qpj78jHSUmsAanKR+YmrrfoXa6sDDdvX0wyQW5rmU230c5f4ZBO
ud/LtpTN01tZct12bccgDLSB+XkmxkYgMgwejuPmi7zz/uTc+VcIrOomFG8YJx+6
EhTaYcCezu1JicvL67zhiuqhrPJe6llbvcGZwqd3t4CDrNhEHuSYMAKm4xr4dhjC
6ooWgVpR1rSgCjmzSIXYl7FE2he6s9yk3VIKUW8CH+nlWlPbMK0cyJzlIRjs8Scp
GJXtH1eMIxO7BAWhtWLI22kUN6cPElnBYUVWYEDYec5msuiASQ3htnsIIk1JI+nW
O5a0jtA4dydPjnFPbtbHeZ4UuRtEnoyR5Ov7dUzPmwr7UC/HKyApHUVP5my/Xa9f
+h9atkqHFR9/mDLf9RuRzrhdmEOxc38J05YItDWOPLMPjsYwJKM7D0ShY1AXuoXg
wqz1Ffs8HW3zdNhF7eklafVVovOGUuUAsMyH1fyiqO18WgnURB/n7Fdnak2l6LHn
cGgc5vxhiVC0SF76UDI0nMhqByh5HMGQL/XhI5QrlnbHPYYNHQwXpPHkKurjy/Y4
daM0QMXluNwICjVp86Ib
=lTKI
-----END PGP SIGNATURE-----

--2qXFWqzzG3v1+95a--
