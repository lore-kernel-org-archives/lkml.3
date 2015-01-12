Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbbALTdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:33:19 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60381 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463AbbALTdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:33:15 -0500
Date: Mon, 12 Jan 2015 13:31:26 -0600
From: Felipe Balbi <balbi@ti.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH v3 3/5] ARM: at91/dt: update udc compatible strings
Message-ID: <20150112193126.GC2858@saruman>
Reply-To: <balbi@ti.com>
References: <1421060278-27329-1-git-send-email-boris.brezillon@free-electrons.com>
 <1421060278-27329-4-git-send-email-boris.brezillon@free-electrons.com>
 <20150112182349.GJ6525@saruman>
 <20150112201816.6e57fe74@bbrezillon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s9fJI615cBHmzTOP"
Content-Disposition: inline
In-Reply-To: <20150112201816.6e57fe74@bbrezillon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--s9fJI615cBHmzTOP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2015 at 08:18:16PM +0100, Boris Brezillon wrote:
> Hi Felipe,
>=20
> On Mon, 12 Jan 2015 12:23:49 -0600
> Felipe Balbi <balbi@ti.com> wrote:
>=20
> > On Mon, Jan 12, 2015 at 11:57:56AM +0100, Boris Brezillon wrote:
> > > at91sam9g45, at91sam9x5 and sama5 SoCs should not use
> > > "atmel,at91sam9rl-udc" for their USB device compatible property since
> > > this compatible is attached to a specific hardware bug fix.
> > >=20
> > > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > > Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> >=20
> > WARNING: DT compatible string "atmel,at91sam9g45-udc" appears un-docume=
nted -- check ./Documentation/devicetree/bindings/
> > #177: FILE: drivers/usb/gadget/udc/atmel_usba_udc.c:1827:
> > +       { .compatible =3D "atmel,at91sam9g45-udc" },
> >=20
> > WARNING: DT compatible string "atmel,sama5d3-udc" appears un-documented=
 -- check ./Documentation/devicetree/bindings/
> > #178: FILE: drivers/usb/gadget/udc/atmel_usba_udc.c:1828:
> > +       { .compatible =3D "atmel,sama5d3-udc" },
> >=20
> > please fix and resend. Also, when resending, could you add Nicolas'
> > Acked-by since he's already given it ?
>=20
> Actually these compatible strings are documented in the first patch
> (where they were introduced), but I'll send a v4 with Nicolas' ack.

heh, checkpatch stupidity :-) My bad.

--=20
balbi

--s9fJI615cBHmzTOP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtCEOAAoJEIaOsuA1yqREYJgP/jw3tJvofFrxtQdj6udzChik
n2Nw2d2qHhmJzEaRTz8KUGD4OBdQtMJcrGI01FLUZltwBTOxN2VYf99F4Zz8KxQg
hVYOMT0oymawNEN9LjRk0xJBpdfPyuDcgDIWCUkpn7jbY01dpPGPCnGmgM7UKHqO
FY9BY288gJcTA9aGUz0FPcGnUarbP+mziYt4jjwJqcQ8Vx8nGslN6V0RlFg6slkE
hT0IvF7TpL1OvJaDZxTlKkgM1bMkkUdmuktldQhZ4T7pYJFw20cNr7ftf3kUU+Qj
up0nVdSRM5K6iCtjlqH71ey9eABMi9BBT36l6f3gG1PL0IShGmFQX8YZoemX2/sC
XGzAG2N9uBvQB0Z4KvmyGVsCZ6XIVmgR99AVlUN4VrOSoVNcLS5H4GZfNDGJX2ED
BAsfUhxN+dNpSuNRNGyHfB9sbsVRRLRbhsExbkzZWy474KtimnbsM947gdeOfzdb
SMooNZnMmnVuKgVSxv15vlKB5iaISmhly8mETPZK8QtnpirJRYJF1DdD2J3ZJ/m1
nxdefa/vpHXNWrM1eg1LTnE/NSfrQ+JJdGKx0N/k51cKtiEDF6gi4BdAeORkrmjl
Zi9l4MUXl+fsKmJsoQvn/46aRyD7Km2RDRhJp7WUYVY+UV5S+CkhXcwIThowgnxH
U8EKsRVkd8IrmJGRjF6A
=bKXD
-----END PGP SIGNATURE-----

--s9fJI615cBHmzTOP--
