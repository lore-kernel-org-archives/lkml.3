Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaEHOaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:30:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38614 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752733AbaEHOaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:30:18 -0400
Date: Thu, 8 May 2014 09:29:34 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin <kevin@allwinnertech.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        devicetree <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, dev <dev@linux-sunxi.org>
Subject: Re: [PATCH v2 7/7] ARM: sunxi: dt: add PRCM clk and reset controller
 subdevices
Message-ID: <20140508142934.GV7047@lukather>
References: <1399483554-8824-1-git-send-email-boris.brezillon@free-electrons.com>
 <1399483554-8824-8-git-send-email-boris.brezillon@free-electrons.com>
 <20140508031700.GO7047@lukather>
 <CAGb2v664vFwezKVp+C1UYdsUktRhrZDxjsyf9L=kwVHGCUV=HA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U8v/hV883cEE9JJG"
Content-Disposition: inline
In-Reply-To: <CAGb2v664vFwezKVp+C1UYdsUktRhrZDxjsyf9L=kwVHGCUV=HA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U8v/hV883cEE9JJG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 11:40:59AM +0800, Chen-Yu Tsai wrote:
> >> +                     apb0_gates: apb0_gates_clk {
> >> +                             compatible =3D "allwinner,sun6i-a31-apb0=
-gates-clk";
> >> +                             #clock-cells =3D <1>;
> >> +                             clocks =3D <&apb0>;
> >> +                             clock-output-names =3D "apb0_pio", "apb0=
_ir",
> >> +                                             "apb0_timer01", "apb0_p2=
wi",
> >
> > timer01 ? is this a typo?
>=20
> A23 manual lists the clock gate as "r_timer0_1", so I put the name on the=
 wiki.
> Allwinner sun6i code uses "r_tmr" or just "tmr". I see no problem naming =
this
> clock output as "apb0_timer" though.

Yep, it seems better.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--U8v/hV883cEE9JJG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTa5TOAAoJEBx+YmzsjxAgwU8P/j2X+dDTlbYIgu1VHdkQ7vr9
F7dQkhN7I4ZfqA3VTl62UZcMnDsU04Pz97xps3zzMZM5sEGi88u4DEXhDPsdGuVH
QrqWBKV0pfit5ZY/IU/Y7ZhIvQhn60lezctCYfOwC0gtscZRB9jeaHFp5Vx6n9DE
J0WQJS2/khjHP37qlnBdmFgaqekKVEbFHN21xPQY0xtYhyMaQQ1CZ3h5R/WhbI+Z
eFMMY6KMRHhVybvWdAV73bYfCGeXDfbCKon+zl4Z16bf2ymqWnqB0Rz+4nkK8iKB
BCt7H5Jq80MRQT/0RwMy4EMV8djKolCaVdZL6e48DKcMeKKJUg3XjCRlqrNt73Zk
QaejygSnRlRPiEZPf3nGlyAtXQOZuPERT+2qQefSMs16aF3kQMeBnxHLAQIKrToP
T3D6/tnZRX3heL6C0mZTrgx1jKIqahzl/a1NTTnbmMmYm033SS3XRVe2iElu6uVZ
UOlleb7K0oEnPU2bmoc4odUF1uR+fEcNTnx5TXGdnyNnNnKFM5y/PQPpcbIla11n
rGRLe1Kr4/vH4lUi6IkNdm615o0cuHz7ASxebbhPG1XxmHvuaPOG0gQADO1guh4y
3jLgpqbeRFM1FbLn+i6+vLLGzrb7qAS7bvcpY7Qd68hkpiZfXWv2DcujWNOZ4FaH
+Xsr4+ZZb5M5XO2hYMfY
=7LYo
-----END PGP SIGNATURE-----

--U8v/hV883cEE9JJG--
