Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3C0Kf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:35:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37760 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab3C0Kf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:35:56 -0400
Date: Wed, 27 Mar 2013 21:35:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warnings after merge of the regmap tree
Message-Id: <20130327213542.ebbac5f00544f89ae369e7cc@canb.auug.org.au>
In-Reply-To: <20130327102456.GR18316@opensource.wolfsonmicro.com>
References: <20130327154737.bdcc835ec2ea56409fa0c7e8@canb.auug.org.au>
	<20130327102456.GR18316@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__27_Mar_2013_21_35_42_+1100_/EClizkvt6eejYb0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Mar_2013_21_35_42_+1100_/EClizkvt6eejYb0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Mar 2013 10:24:57 +0000 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> On Wed, Mar 27, 2013 at 03:47:37PM +1100, Stephen Rothwell wrote:
>=20
> > Introduced by commit 45c6a3e449ea ("regmap: cache: Provide a get address
> > of value operation").
>=20
> Don't know when you grabbed the tree but that's not what's there now.

Just before 10:30 am my time (UTC+1100) - so about 11 hours ago.  I just
refetched and the regmap tree
(git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git#for-next)
is still the same as what I fetched this morning (top commit is
b32667515168 "Merge remote-tracking branch 'regmap/topic/range' into
regmap-next").  Probably just the mirroring delays.

Anyway, good to know it is fixed.  Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__27_Mar_2013_21_35_42_+1100_/EClizkvt6eejYb0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUst+AAoJEECxmPOUX5FE/WUP/j5Ddcw4qct+HPROP0htQbc5
nVLc6TPIQE84/8izX2bYxT7ILaIYAqSqCM+0oXyeBw37uhuVPiUk5FjKzFOhTQGm
6NPgk2xPglG1fb5INm9Px44xLOA60iv5KNT0d60gfeS6Pv14cde4odV3vs2LKi3j
9+T6A0HA+OpG/Gk/uLOsc8uyd/Rrc1Y4q5UFrdEei2de1X8U2WPNyhlNKH7KjeA+
+enUkALHlCxgx4iXEkEZN7XW/y+V63WxvMh20SqNkpuQoqJQATpPQyufyfFARUkl
kK9DjUjDX/kpTsTDXELli7Xl5+jbGDNlIkJ0rnlsAaOBGjfSrukxFRhS2wuzkO/E
LrSSLs/VfgalYFbP6UT3qWAmTdNbhcs1omkCTppnYYqxmjWRHhEUo3CwLSL0g/Hc
UzhWRDdDkoyuMcag9o3NakJuhkanwhQIkrDW5l5RagoH5Ln8BYtJKUxOT14veNmt
L0fCEjjADJ3TLf2i+k7ginkuyazD6+O8vf3zuh9ROClvFxb+O3lGxZsp6Jpdpmmo
ZXewjB6d87uTVdSX2Z64O82CrxerRR2UaWilXClDmcJLwKD/PghUI5TfqUp28d2N
eFAT3/dIOG27u/GOpRkxwkL9YCLlzFYPuhWz5+CywqUEkkE+Hy+3Hn5OBIa7yR/J
b+bTONtwEQTHc2K2vUm9
=llUM
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Mar_2013_21_35_42_+1100_/EClizkvt6eejYb0--
