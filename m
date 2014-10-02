Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbaJBA6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 20:58:22 -0400
Received: from ozlabs.org ([103.22.144.67]:38912 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926AbaJBA6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 20:58:19 -0400
Date: Thu, 2 Oct 2014 10:58:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anatolij Gustschin <agust@denx.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: error trying to fetch the mpc5xxx tree
Message-ID: <20141002105808.24f6196a@canb.auug.org.au>
In-Reply-To: <20141001091125.40546254@crub>
References: <20141001090115.44146aa9@canb.auug.org.au>
	<20141001091125.40546254@crub>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.7nK/I9iARov=BLHuUUQWZN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.7nK/I9iARov=BLHuUUQWZN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Anatolij,

On Wed, 1 Oct 2014 09:11:25 +0200 Anatolij Gustschin <agust@denx.de> wrote:
>
> On Wed, 1 Oct 2014 09:01:15 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> ...
> > Attempting to fetch the mpc5xxx tree
> > (git://git.denx.de/linux-2.6-agust.git#next) produces this error:
> >=20
> > fatal: Could not read from remote repository.
> >=20
> > Please make sure you have the correct access rights
> > and the repository exists.
>=20
> the repository has been moved just recently. Could you please change
> the linux-next tree to pull from
>=20
>  git://git.denx.de/linux-denx-agust.git#next

I have updated to that, thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/.7nK/I9iARov=BLHuUUQWZN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJULKMoAAoJEMDTa8Ir7ZwVNdAP/AiEgCakqUkiByghQcmrSlP3
6+LbcBHCLPtJ9wEUrkrfEOYN+xE+GnY20ToC2cT7Hh7gBKZ/D55GiVqleMfZ4UtZ
zbo94rQoDfO0NeG8NXc1MK1p07NHM6DZILrVbQjQEkS+0g4dVHgQHg7Aemgh8HeZ
5jEkJ/xucabo67zApM1K5Uops5AowFqAyIV3WOnnH30VOprtvLTOf63QAGj0PwAx
jKzvTgHWqyZPasUhrG/jj91jcHFKJppIRKtdYJFaZlmOEJRA5nbNJHmwzZn9FX5L
/weeWJQcqlKv8qhm79u6527q6QlHR4OVBGGpFcraARzQ702OqxqstyYpJBoK+9Cm
ifMBM1bMHY/msnvbtSZgjjGY7FYvndaDmIj6AIf6FvkRNttGc2fOOft82oAmtuVh
ivPPSXf8qMP43PZ0+eMHAZO1zOmWqguAIhbhE6aOpHl2Gi2yDauFeYMj0OOK39NI
OraYI9S/zX62i73EPG2r5raJWgnNay3SJLEipSGBipqIndIl8kGA0sn4kRufUJcN
44pkF7W/R0gB8I7QY17GuCGqNJsRZ6uSBHOdY6wr6x1DQNUlnS9PUm5xieV51A70
RveRsopMvqn+YpgC1uEVma+Su1Os2lXD/8EgR2IB6+rsuaEsTz6n6SX/blURTZV/
VdMYa1giHDsTqwd8Sgm7
=lvap
-----END PGP SIGNATURE-----

--Sig_/.7nK/I9iARov=BLHuUUQWZN--
