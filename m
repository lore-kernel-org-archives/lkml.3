Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab3LCQEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:04:01 -0500
Received: from libra.uberspace.de ([95.143.172.171]:39690 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752729Ab3LCQD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:03:58 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2013 11:03:58 EST
Date: Tue, 3 Dec 2013 16:57:08 +0100
From: Matthias Beyer <mail@beyermatthias.de>
To: linux-kernel@vger.kernel.org
Subject: Re: How to test my patches for the (staging) android driver?
Message-ID: <20131203155708.GD2264@fu>
Reply-To: Matthias Beyer <mail@beyermatthias.de>
References: <20131203151642.GB2264@fu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1IWgL8yD8uKyf/Tu"
Content-Disposition: inline
In-Reply-To: <20131203151642.GB2264@fu>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1IWgL8yD8uKyf/Tu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Greg-KHs email bot tells me to send this message to a ML. It suggests
to send it to this list or kernelnewbies@nl.linux.org, but the latter
results in a failure notice. So I send this email to this list.

On 03-12-2013 16:16:42, Matthias Beyer wrote:
> Hi,
>=20
> First: I'm really new to the kernel in manner of submitting patches,
> testing etc. Please, if you send me guidelines or pointers on
> what to do, explain how to do things!
>=20
> I'm working on some cleanup patches for code in drivers/staging/android/.
> These patches are cleanup patches as suggested in the appropriate TODO
> file, including fixes for checkpatch, but also function splitting as
> there are some really long functions (mainly in binder.c).
>=20
> How to test my code beside compiling it? Do I even have a possibility
> to test it or should I just send it to you?
>=20
> Besides: Which ML should I post this (and the patches) to? Main Kernel
> ML?
>=20
> --=20
> Mit freundlichen Gr=FC=DFen,
> Kind regards,
> Matthias Beyer
>=20
> Proudly sent with mutt.
> Happily signed with gnupg.



--=20
Mit freundlichen Gr=FC=DFen,
Kind regards,
Matthias Beyer

Proudly sent with mutt.
Happily signed with gnupg.

--1IWgL8yD8uKyf/Tu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnf9UAAoJEJi+S08gyg+UXrQP/2lGe8BPNSWwOxhP736dmubs
GTBDlhudP/pfixd55fx+Zbx2x7GSTlHuvLJBat3QtoURrGKX7iy5GvFkQA3esCpT
dsDM4luDh4bh6zb9xuGaoYO43Y+cXf3bcEqTJ7gATiyUDt3fxmAqbKhDYuUgA0i9
4YriHtkVi+A2FhkW0mGhvmv0K1+rxB9Zx9g2CUcvOmU3L5oKjCRoO8VjN132aF7k
r+k+sMf1ndcntgM8xY0TUyu9HrJNzKAEYuKN6ruPI75HQl5vKgQFGUUiN2tcpfS0
Zfnr1WfXJDbR3Bpa52lsjvPaekqw8dDC7LiTx3v/cyZO8ZqgiCsEQd5vypSr+pcd
uhP+8wIczWmiUeIQ/WeBs4WVHhrqaG28f4CyByRYIaQeV/Kw/43KX8XuyFVE7ZMw
jr3dC5HGJHeIFL8EfvSBGNavSNOELTgBrrnTObzfzU/lPAyIs6mrJkZfBZijaHK6
wwGxpCGcmRHDYTS+L7A7j04gdf41NN27gxFqrF4qLTPiYb2JYMjPFtcCIc8h2cMJ
I/EYNMnGidRK9RdTZT+5N5Dgn5yOUvsEK7oQ9ajz1Z4tngOJ8CinYLR/c7xch7LO
tZKMs5+2DkVGBzPkGOjRSuDMwWMU6xm0OMWsKEHapUUclELXSWbjBTFcpb0P6Sbx
6BLoF3e3oYeRZUSSlo2k
=FeVO
-----END PGP SIGNATURE-----

--1IWgL8yD8uKyf/Tu--
