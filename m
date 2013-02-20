Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935538Ab3BTC7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 21:59:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38294 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934777Ab3BTC7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 21:59:13 -0500
Message-ID: <1361329144.29126.0.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 00/66] 3.2.39-stable review
From: Ben Hutchings <ben@decadent.org.uk>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Wed, 20 Feb 2013 02:59:04 +0000
In-Reply-To: <87621oc55b.wl%satoru.takeuchi@gmail.com>
References: <20130217225001.621306883@decadent.org.uk>
	 <87621oc55b.wl%satoru.takeuchi@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-B5+LgILkfeeFEnDoRqxz"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-B5+LgILkfeeFEnDoRqxz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-02-20 at 07:25 +0900, Satoru Takeuchi wrote:
> At Sun, 17 Feb 2013 22:50:01 +0000,
> Ben Hutchings wrote:
> >=20
> > This is the start of the stable review cycle for the 3.2.39 release.
> > There are 66 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Tue Feb 19 23:00:00 UTC 2013.
> > Anything received after that time might be too late.
> >=20
> > A combined patch relative to 3.2.38 will be posted as an additional
> > response to this.  A shortlog and diffstat can be found below.
>=20
> This kernel can be built and boot without any problem.
> Building a kernel with this kernel also works fine.
>=20
>  - Build Machine: debian wheezy x86_64
>    CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
>    memory: 8GB
>=20
>  - Test machine: debian wheezy x86_64(KVM guest on the Build Machine)
>    vCPU: x2
>    memory: 2GB
>=20
> I reviewed the following patches and it looks good to me.
[...]

Thanks.

Ben.

--=20
Ben Hutchings
Sturgeon's Law: Ninety percent of everything is crap.

--=-B5+LgILkfeeFEnDoRqxz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUSQ7+Oe/yOyVhhEJAQpPDQ//fLSB1NNNfU2T6eSMw2R61e/aqD7T0Gqw
EskkYg3nSexKVyYObs46R1VQDZ/H1DYLeU19gtCb5qpVQ+u8/8s/mKmitgFZBnjb
s7AjOAPEI5+5lsxWvWMv6bszEDItr63UBbzEktZua3KGY2/60MzRDdcqArpUwcx8
Mpij+Qun3iomE+pgdrElR3Q05nwBvFN4xYaiK5rLdlJGq+vpZgm44wnWYW0Y91/d
U6Gg+hKmAzNUbSnpAyWuEdzhA8KpULtoIoo64KGacOXItjB+4KHHfDg/T7yqsn9F
A+APK6kNFTo/nwhIKyQ5Ikt3TtmwRqBpDh3MoarEXbc2wSouTY8aivhxUPdUf76u
CWSUrlSiSSMAzLKOTn+W0BCLJVwyU2YG1puxMn8GYtESYAx77KXKXBmTU0+pb8ro
DXJ9UIbgTitK+sjp1kTMDVB+zxFSAwyzNxybsMb+ArYulhVDe7IV6HY5cvDQ1hy5
xIm8cQ51/2gLw6ziRQBX0jdkQ8TrUeNJXQPX7x5TbT8OIu9zXhtcCAugwVAnO0/d
9gO6FgfDNLqCXGuoEmar7PwcihCwOBkWY8gcuGxF1if4ZnB3rERp7Umdueg7IOAo
Xhwd11ZyUQ1I39gkXk+TSElRDX9/DoV5Rb7U27O3aFnFkpTNUuVwMnGmF5IIH8jC
3ZBa/yee1eg=
=pMmh
-----END PGP SIGNATURE-----

--=-B5+LgILkfeeFEnDoRqxz--
