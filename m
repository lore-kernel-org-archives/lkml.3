Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750889AbbAUOWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:22:02 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:65203 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbbAUOVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:21:53 -0500
Date: Wed, 21 Jan 2015 01:21:57 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com, rui.zhang@intel.com,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] ti-soc-thermal: implement eocz bit to make driver useful
 on omap3
Message-ID: <20150121052156.GB13468@developer.hsd1.ca.comcast.net>
References: <20150103114632.GA21883@amd>
 <20150103122634.GB22356@developer>
 <20150103162241.GA26680@amd>
 <20150105213557.GD31536@developer>
 <20150118201821.GA28530@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <20150118201821.GA28530@amd>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 18, 2015 at 09:18:21PM +0100, Pavel Machek wrote:
> Hi!
>=20
> > > Ok, what do you suggest? AFAICT, without MODE_CONFIG, continuous ADC
> > > mode is not available, so we have to force it periodically, so this
> > > should be correct.
> >=20
> > I will have a better look and let you know. for now, adding a single
> > read should not hurt ( but I will double check)
>=20
> Any news there?

I believe it is OK to keep your code the way you posted.

Thanks.

>=20
> > > > > +		if (ret)
> > > > > +			return ret;
> > > > > +	}
> > > > > +
> > > > >  	spin_lock(&bgp->lock);
> > > > >  	temp =3D ti_bandgap_read_temp(bgp, id);
> > > > >  	spin_unlock(&bgp->lock);
> > > > > =20
> > > > > -	ret |=3D ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
> > > > > +	ret =3D ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
> > > >=20
> > > > this one should be part of your clean up patch
> > >=20
> > > Ok, can you apply the cleanup patch and I'll prepare one on the top of
> > > it?
> >=20
> > I mean, you should resend the cleanup patch including the above '|=3D' =
removal, as you are already doing in the cleanup patch.
> >=20
>=20
> Ok, little patch-editing can not hurt :-).
>=20
> 									Pavel
> --=20
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/b=
log.html

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUvzdpAAoJEMLUO4d9pOJWwjcH/32vXc//2M5ZyN6q35OPXZ93
iOMnoRkEzBrUVtLrCShZ/48Q+eJcofcvSba5IYXfd4a2KBBfp+mKJFPvnYOvdzox
AOGFKidlnmtX4fGYET7dj75e2Z+qnOY3rA0V0OsDbL6wgvX7/oRVZUa/FnCq6Ejx
jhpd7kMAyrzfNDRFGLqt+PT/DYNCGP2hsLf7H6oAdzItvDeHXW1/hWrCfTluwZzr
8IyNfBZKuoB7lwPpvKPQQkjbndxQLAYjZmwTPIilbOymRa1puCbvJOlgI6e/LSGe
Mr1XNcyRVWaQ649K8xA4FtC6b9k5ffCWYGvhf35zJjHTYxw79enTCNB38h7uuiI=
=tStF
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
