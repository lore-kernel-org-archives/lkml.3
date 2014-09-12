Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaILKZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:25:54 -0400
Received: from sauhun.de ([89.238.76.85]:60663 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbaILKZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:25:52 -0400
Date: Fri, 12 Sep 2014 12:26:08 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Marc Dietrich <marvin24@gmx.de>, Linux I2C <linux-i2c@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jean Delvare <jdelvare@suse.de>, Magnus Damm <magnus.damm@gmail.com>,
        Andrey Danin <danindrey@mail.ru>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [RFC 4/4] ARM: shmobile: r8a7790: adapt DTS for I2C slave support
Message-ID: <20140912102607.GC1930@katana>
References: <1410274470-12712-1-git-send-email-wsa@the-dreams.de>
 <9935938.eKOCvCAtLt@fb07-iapwap2>
 <20140912083348.GA1289@katana>
 <7627175.tG5quZH0VN@fb07-iapwap2>
 <20140912095821.GB1930@katana>
 <CAMuHMdVi+6TXH68ddQ-UWfUif0Mv=ETu6dnpiy1Apike6zfAbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Content-Disposition: inline
In-Reply-To: <CAMuHMdVi+6TXH68ddQ-UWfUif0Mv=ETu6dnpiy1Apike6zfAbg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > DT pseudocode:
> >
> >         i2c {
> >                 compatible =3D "nvidia, tegra-i2c";
> >
> >                 ec-slave@42 {
> >                         compatible =3D "nvidia, ax100-ec-slave";
> >                         reg =3D <0x42>;
> >                 };
> >         };
>=20
> So distinguishing between drivers providing slave services (using slave
> mode) and drivers driving actual slave hardware (using master mode) is
> done based on the compatible-property.

We describe users of one specific I2C bus. And the drivers that go along
with them. No?


--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEso/AAoJEBQN5MwUoCm2dqUQAIJYjozB+npQ2xeKh/n7t2wT
nThOrcgorY4NuCbm6ZdWpjdgCjcIdduRCh8c8iei+Sh73z7FXxC2RvM7smzLstif
xKftDaLK0YVIn76pC0hfWQyu2rc57eQUm+JtrjK+IK9cMgJ33/NkwJw6J3yb9Z9j
4GWQMO42NsxSltYHTUAsmX6l9ASLMaDy1IBJEyTFla2+0HAwK9e8Os/WO7coCEV9
dknuH/18D/zVL/ZwaEGSJaxZQ6JhrYNUIIwcuty+QG4z1eLXko9seLXP67ARS0mB
kDqpaY0auznfSDav5d4lL/8b8xpE6+cce4ZESfA3pqVOXR9F8CCud6zzEtV4ui1S
oq1F34EYnxDOD/wJX03Iw3n+2KHTVvf5Js48F8WNQyv74bbUQK1otIyax2OpsoDL
t6vpCOImgQuEt96+Q5Yu+HIPdpCivxzSsHNgnuIpeAZFjpFhtEs8zD0MzapB73fl
z5OHqLZpQbyq38ZtVgT10cReQvq66Enyr081fJhJFK69sU8m1YqHyFG3L+SpJf73
xW1etxa3RpygDITlJ6iZxrceB6KpnRnURH65HE60aKBxYAMCZ/WixmfT0tP4CVd4
7bUgInDoHcle4SFDhn7Z0tPT3QW80Ztkd6FE604MOo0xjwNfb9zc72jgxOaPqoTX
kcPjy04MLtEHtbZp/9xf
=ci9g
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
