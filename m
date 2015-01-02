Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbbABXcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 18:32:12 -0500
Received: from ozlabs.org ([103.22.144.67]:36628 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbbABXcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 18:32:10 -0500
Date: Sat, 3 Jan 2015 10:32:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20150103103202.7f31a7af@canb.auug.org.au>
In-Reply-To: <CA+icZUUmm5=YAZCXtk+iBaewFremZ17M2uShx+jBa4=JcTuaQA@mail.gmail.com>
References: <20150103091101.04b2c11e@canb.auug.org.au>
	<CA+icZUUmm5=YAZCXtk+iBaewFremZ17M2uShx+jBa4=JcTuaQA@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/XuO_5dyW8GnvpiBGTW.M+9w"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XuO_5dyW8GnvpiBGTW.M+9w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Fri, 2 Jan 2015 23:21:05 +0100 Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Fri, Jan 2, 2015 at 11:11 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> >
> > After merging the net-next tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >
> > drivers/net/ethernet/mellanox/mlx4/en_clock.c: In function 'mlx4_en_ini=
t_timestamp':
> > drivers/net/ethernet/mellanox/mlx4/en_clock.c:249:2: error: implicit de=
claration of function 'CLOCKSOURCE_MASK' [-Werror=3Dimplicit-function-decla=
ration]
> >   mdev->cycles.mask =3D CLOCKSOURCE_MASK(48);
> >   ^
> > drivers/net/ethernet/mellanox/mlx4/en_clock.c:257:3: error: implicit de=
claration of function 'clocksource_khz2mult' [-Werror=3Dimplicit-function-d=
eclaration]
> >    clocksource_khz2mult(1000 * dev->caps.hca_core_clock, mdev->cycles.s=
hift);
> >    ^
> > drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c: In function 'ixgbe_ptp_st=
art_cyclecounter':
> > drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c:796:2: error: implicit dec=
laration of function 'CLOCKSOURCE_MASK' [-Werror=3Dimplicit-function-declar=
ation]
> >   adapter->cc.mask =3D CLOCKSOURCE_MASK(64);
> >   ^
> >
> > Presumably caused by commit 74d23cc704d1 ("time: move the
> > timecounter/cyclecounter code into its own file").
>=20
> Just FYI...
>=20
> Richard posted a new patch-series "[PATCH net-next 0/7] Fixing the
> "Time Counter fixes and improvements" on linux-nextdev fixing this.
>=20
> - Sedat -
>=20
> [1] https://lkml.org/lkml/2015/1/1/27

Thanks, so hopefully I won't need my patch for very long.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/XuO_5dyW8GnvpiBGTW.M+9w
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUpyp2AAoJEMDTa8Ir7ZwVW9QP/3XReF6R67XKfGnJDXlnctys
XKUQvi25iGTolXWMoj1kfyFIrq5BRRaCbK7El3kjm8HU16YK3VtURyi7/m2RaPlq
MFBLVyyEn7esNEXoWkDjcEMtbpatpqWPBWD9uOIoFsuBmi5SoIdo7ITPSWvRhwIw
qTK6xCqFiDNlg9q/52w3hwI3uBXI76t5WyjuOGI0dRa1o2mCik8CkMeMu9dcXMJm
eSDgnvlKaQbAkHZCB+045D6yS6PF/UOmvrIbjxn20kEjIsbh77itkTkdvDEoJ1a6
RfJN/SOWHFhufok8hSDv7piU/ZFAuUqourRxfmnbhedyjNBKyGdYUcFKFxxswjTr
+SrF98mIY4PNujNdJn8ij0YfsW74RkLsW9+Hv1YlY7KrMgPa5JevsTT32AUhMgO+
ZjAX8GhcGTIP//f5oJ15KL0FiZzD7GXJ4CTv8xpSiRtvdMdR4QrnNqh140UAyllk
jSDNisOAyngxfW0rUEyK+5WKs4EMwlh4c3k/N//EBLtaJloawCICV6olY25zUTki
saqZ1fjsTpVy9OD2eiOK9aTmqDoYLY3SMgx+JtuVJKvkSsyUKkgapz+Hl/g7CCpP
ahN5XUa6MPbAdLuIDzmJGqsyOWygT/lqTH0jWyt8fX9siHQ6OKKu2pscw5IJiyXt
hc+GRl6nPt3KXaBkCs0G
=S6dn
-----END PGP SIGNATURE-----

--Sig_/XuO_5dyW8GnvpiBGTW.M+9w--
