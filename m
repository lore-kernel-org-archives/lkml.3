Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab3DVAvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 20:51:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46804 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573Ab3DVAvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 20:51:03 -0400
Message-ID: <1366591846.3408.126.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.8-stable] thermal: return an error on failure to
 register thermal
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "'Zhang Rui'" <rui.zhang@intel.com>,
        "'Richard Guy Briggs'" <rbriggs@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 22 Apr 2013 01:50:46 +0100
In-Reply-To: <20130403144702.GB3047@hercules>
References: <000001ce3003$a1b87aa0$e5296fe0$%choi@samsung.com>
	 <20130403144702.GB3047@hercules>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9V85jtg1IyZCT5CLjUdt"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9V85jtg1IyZCT5CLjUdt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-04-03 at 15:47 +0100, Luis Henriques wrote:
> On Wed, Apr 03, 2013 at 09:38:55AM +0900, Jonghwan Choi wrote:
> > 3.8-stable review patch.  If anyone has any objections, please let me k=
now.
>=20
> I believe this is applicable to all the other stable kernels.

Queued up for 3.2, thanks.

Ben.

> Cheers,
> --
> Luis
>=20
> >=20
> > ------------------
> >=20
> > From: "Richard Guy Briggs <rbriggs@redhat.com>"
> >=20
> > commit da28d966f6aa942ae836d09729f76a1647932309 upstream.
> >=20
> > The return code from the registration of the thermal class is used to
> > unallocate resources, but this failure isn't passed back to the caller =
of
> > thermal_init.  Return this failure back to the caller.
> >=20
> > This bug was introduced in changeset 4cb18728 which overwrote the retur=
n
> > code
> > when the variable was re-used to catch the return code of the registrat=
ion
> > of
> > the genetlink thermal socket family.
> >=20
> > Signed-off-by: Richard Guy Briggs <rbriggs@redhat.com>
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > ---
> >  drivers/thermal/thermal_sys.c |    1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sy=
s.c
> > index 6472e7e..1a19a2f 100644
> > --- a/drivers/thermal/thermal_sys.c
> > +++ b/drivers/thermal/thermal_sys.c
> > @@ -1875,6 +1875,7 @@ static int __init thermal_init(void)
> >  		idr_destroy(&thermal_cdev_idr);
> >  		mutex_destroy(&thermal_idr_lock);
> >  		mutex_destroy(&thermal_list_lock);
> > +		return result;
> >  	}
> >  	result =3D genetlink_init();
> >  	return result;
> > --=20
> > 1.7.9.5
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe stable" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others=
.

--=-9V85jtg1IyZCT5CLjUdt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUXSJZue/yOyVhhEJAQqUzA//WpYCfbyZSODrYWez5sh+QkZxqc+HzxdU
Der9OU8qBFqIpKCJkLdoWNBI6VieYtrKc7aAwgQ6fGKnBuLvefXS2oawo7R5M7qJ
HIyabDTwOqHq2AQ6nx27ymVbmqRplNPt63HtarC0GvETDmUAcZh8HX76PpqXS5m9
96nPJ6bbcL7HaoKI9sAKu7fPM+1ybEl6oROZVvjJ4TNAL9dye3y4nz8eXn4PvgR3
8CX/TWRAEDHZeUi0y7BNnX+Ex1eVEhGjXRpGHkP1CBDF96LSXiBWvhkl/ibJ/z52
fWeAXdSaZ8Vehoy0I6a78qwwRElMCmIEVbZ+PGtJacl948mqT31UDgSc1B3JNAGF
O1MCIVO7ysxMhoWciS7gglu2lFS8+qCrwBSR1bDntH/rOmFWGSTBW8b+9Y+ZUTXc
7E57rZRs7G6mrvTQ8xyEFH27cciZ5ukrf+UW042RwkIJb3tTKmeeXWEaHqoZvd1o
NGh+tJwcWGW6DBYJpsVQU4Y/yB0DgSG3yOZw576EwMtd6QYXAzhXwBzS5rvlbrz9
Q5+3EJCLTbBWyEwq6kWRgkxFcmt8+U2qHtTCrkXP2UrClok96Qx1P1CQAo1CrpkH
lj6cDuTn9EDMpBLb2DUHkN76IfX4Zg1l14EFyjf/R3t1zCfGc0smFAcCUjoY+wL6
RcVw9LyohJo=
=J3zz
-----END PGP SIGNATURE-----

--=-9V85jtg1IyZCT5CLjUdt--
