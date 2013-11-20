Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab3KTAKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:10:42 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57293 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3KTAKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:10:40 -0500
Date: Wed, 20 Nov 2013 11:10:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: John Doe <foobar5252@hotmail.com>
Cc: linux-next@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>
Subject: Re: Windows does not like `aux` file names.
Message-Id: <20131120111025.32a2033aa7ef205e3d39c572@canb.auug.org.au>
In-Reply-To: <loom.20131120T000349-818@post.gmane.org>
References: <loom.20131120T000349-818@post.gmane.org>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__20_Nov_2013_11_10_25_+1100_1zz+Dqgvml6S33nR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Nov_2013_11_10_25_+1100_1zz+Dqgvml6S33nR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 19 Nov 2013 23:15:07 +0000 (UTC) John Doe <foobar5252@hotmail.com> =
wrote:
>
> drivers/gpu/drm/nouveau/core/subdev/i2c/aux.c=20
>=20
> When trying to clone the linux kernel on Windows, that file will fail due=
 to
> Windows not liking the file name `aux` since it's one of the reserved wor=
ds
> used for DOS devices.

That file was created by commit 4196faa86232 ("drm/nouveau/i2c: port to
subdev interfaces") and has been in the main kernel tree since v3.7-rc1.

This is not a problem with linux-next as such.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__20_Nov_2013_11_10_25_+1100_1zz+Dqgvml6S33nR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSi/31AAoJEMDTa8Ir7ZwVc8gP/1GH6mot62/s8BzZski45HCm
uSRfNSBEVkUpFuS4cNy+4gNTgPIFkkOpI6YYZNTO7akXXEAXCPgDEvhqTsg6DS/o
kKRKpiVpF6HDgdmOwuLz3T8819dxh6tuKwxCaiZ6wTP+jK1t1qZj9nOETR+pyPo/
zeKmArPsPmV5SKK4A+iMZiMEe2z1N0n328Lh/yAMUI7jiCX9pM8iO/clQxlUTOec
cw2n39O6U8vQL9I6/epD395AGhsTSPKHxuYYt90/f5OuWwVInrFi68fPyin6m/Eu
URbgaVBD81yapzt2jMS2U+aRMbnRaUA6P6tQvYt8+FlaLBMLLl7ExJjhIroCx8NB
WKB4OEogEU2lTmUDlLfqpCrJMPGFkmxnyoavwu0Uf4lIk3cLLfYdLkuhenCK8TR2
VEaqadYPfGi71AUxaDqneClcDHkrxfDfhF2IomrLWNFOK9osXgitpUNG/5u55HsS
TZ4yF6ExDfQbTmTxp3tIlisn9Abn4SVR4LjAD3UKj1IRn3cIuSRHbHGTlyRZC52C
jRg0cU/kWVB4BUC5JJeanZW0u+wSZpHIm2XXBHkR15tpDLsuShHwbFNJ0Hc8SANr
jcnj3MisUNkURRJYZF+LbCxRFe1mc34uTc5jZ/YwubaIJSlXkIJ895GcgO5TjY9D
kh90s14pjtFfqpYA8H2X
=JTo0
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Nov_2013_11_10_25_+1100_1zz+Dqgvml6S33nR--
