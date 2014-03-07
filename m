Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaCGRzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:55:06 -0500
Received: from top.free-electrons.com ([176.31.233.9]:40367 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751453AbaCGRzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:55:03 -0500
Date: Fri, 7 Mar 2014 18:52:55 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH] i2c: mv64xxx: Fix compilation breakage
Message-ID: <20140307175255.GW607@lukather>
References: <1394204370-22979-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140307160836.GM21483@n2100.arm.linux.org.uk>
 <20140307171932.GU607@lukather>
 <20140307172949.GL28943@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S2CovAv8lqFB/Tem"
Content-Disposition: inline
In-Reply-To: <20140307172949.GL28943@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--S2CovAv8lqFB/Tem
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 07, 2014 at 06:29:49PM +0100, Wolfram Sang wrote:
>=20
> > > Another question is... why do we need to check pd->dev.of_node here?
> > > If CONFIG_RESET_CONTROLLER is set, we always try to get the reset
> > > controller node, so drv_data->rstc is either going to be a valid
> > > pointer, or it's going to be an error pointer - neither
> > > reset_control_get() nor devm_reset_control_get return NULL.
> >=20
> > Hmmm, right. I'll fix this in a later version.
> >=20
> > Wolfram, do you want me to respin the patch making use of
> > reset_get_optional introduced by Philip in its other mail?
>=20
> I think I'd prefer both issues fixed with one patch like in "fixing up
> reset controller handling".

You mean the of_node check and the use of reset_control_get_optional, right?

> And you might want to give a Tested- or Reviewed-by tag to Philipp's
> patch if you are going to use it.

Yes, I will. I'll only have access to the hardware on monday though,
so I won't be able to actually test it before then.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--S2CovAv8lqFB/Tem
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTGgd3AAoJEBx+YmzsjxAgCWIP/1kR5EomWB2oqSQuytFTGr5b
1ce9987z30+Go6xniqV9f39z6zPoJuEztfbXa6kU5a9IIRy8cTZHpThQKrPrdPRW
7bFBt3ikxYwdKJPgoh01MgFGQcuAHezdrUQllvI8zNQ3gI80oqp27jLKNpV4+327
FVNSNi5t8AWmhusmBLv5zuOiVeUE8diQCGqPrXrE3au1zk+WJNRR7y3c9sIx/fHB
TQO/w0Hgg+Ox6rHPy+NzbIlBYjb+PsRzLyxLMu9ZEfsBiI+sSrXiVSU2jL6ynvex
zvV9KqUNortvDb5ec7zNZR0tCi/RGDnc8IW8uvRui80w7zDszybrn7cNd9YoeBUD
jR07I0UfbrJquuxPlMTsvVPavn7PjN+bAV+a+/J0Sg9cdCNVdByIUOuqv847rNq3
IRSYlWcQXg1sYLXks7N7Ibftl/2jfBM1t/B4z4LkOG9H6+UJXbAkp5eg8RqVAkH/
75Qn2CTHt3xQGdcFjDNEbxUZelfq+4CYTW9Ciykq9lE+83CVopklVm0wB2Wvbz98
SldA45pDxb6UJQI7FYFUWy5Yw/nSP8bso8CDlVPToeM/8nabhfvab80Rr21S2L+q
Ydk/1a0CT/KU+MM7ViJ07F6EtKqMAPwSxI3kkL+6P4NVhPaYX5ebywhg10Rel3Ex
jCkXNiw/DX0W5IsEVnup
=zprG
-----END PGP SIGNATURE-----

--S2CovAv8lqFB/Tem--
