Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965469AbaDJIPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 04:15:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36832 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933287AbaDJIPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 04:15:07 -0400
Date: Thu, 10 Apr 2014 10:10:31 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 00/15] ARM: sunxi: add A31 PL pins support
Message-ID: <20140410081031.GM28585@lukather>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
 <CAGb2v66XCN2ar1wj+a1+ZwdcdJ3gzJ+nDiO9bu52OwK+mBB_Hg@mail.gmail.com>
 <20140409151747.GH28585@lukather>
 <CAGb2v67+YNhw2MXSu9DTKSUfXH=v+uD7KEaxyiPezyf9CYtmPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4oQnj4jcM03NhqPN"
Content-Disposition: inline
In-Reply-To: <CAGb2v67+YNhw2MXSu9DTKSUfXH=v+uD7KEaxyiPezyf9CYtmPw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4oQnj4jcM03NhqPN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 10, 2014 at 12:27:32AM +0800, Chen-Yu Tsai wrote:
> >> > Let me know if these changes are too intrusive.
> >>
> >> I wonder if we should do a separate driver for the new PIO controller.
> >> Clearly it's a separate IP block, with it's own clock and reset contro=
ls.
> >
> > It's been merged together in the A23, hence why we did it like that.
>=20
> I'm not sure I understand. The clock gate and reset control are still sep=
arate,
> are they not?

On the A31 the "regular" port controler handles PA to PH banks, while
the R_PIO handles the PL and PM banks.

On the A23, the regular port controler handles PA to PL banks, and the
R_PIO and PM bank doesn't exist.

So we're not quite in the same situation. The A31 is troublesome,
while the A23 (except for the external interrupts), is pretty much
what we've seen so far with the A10/A20/...

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--4oQnj4jcM03NhqPN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTRlH3AAoJEBx+YmzsjxAgGBIP/3BR71Fgu+cyZxrqBOKilVrq
lN5AwGgc0Uw0Ivt1a6dUxW6qobI8oF0MQT9hHtrNLYqErfdJ+lU6awhtI9j/QNyb
EEv2+JitoYKfek2gbRVVpnJ2mlnAQot9fZfQDBQtc3LYN6SD77S3AW1YnhPLD2Ag
CiCGb2E8BAHZM9sPjbNE6ZUzW1w3X/mwqesIRQWLU4ZJH+GH3v5uGS5BUsKhBelC
7/JqvVsEEfS40k4Ic5rmg0JmP3eRB55zT23Jr/SJwzPwxtNMpB3Sb43ccHvgtCCN
YQEJsWbv+OF5wF5qJgunvmk0kMTgGzytEznZ91hn9/q6hqhUhY10SDeBIodZiU4w
0O9YJOBLS0oNeHNAhgDXRJCp8ls2kg4h1QJ9AC0QKoTgwGofk+baEQh5Do5CwvhK
2YshynJabqItpWFZ6VvkuPk+wHxxhcDpgKAPI1c9zRiKQ45P5B75k84Fi29NANPM
eDhjPbGOgo+39dAGjD/UF1SZD+bT8PJYRQEM47tT36x2piS5+ik714H2vEXRWzdn
upXOIx+AREpMkw6mM6uc4UjXdH+cx5iTol3b84vNgkct8HqDoua9hMnExjY532kI
yB6KOjC8acIv6SmzONNeDxEtndZnU9hfoIUUKG7RzTQK+iBGgl6RoJXcOcKzkbpo
H2YS/MLBbUm0Utj/u5jR
=mY0X
-----END PGP SIGNATURE-----

--4oQnj4jcM03NhqPN--
