Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab3KSViy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 16:38:54 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:42703 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3KSVii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 16:38:38 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Sebastian Reichel <sre@debian.org>
Subject: Re: [PATCH v2 0/3] Add support for charging battery in Nokia RX-51
Date: Tue, 19 Nov 2013 22:38:34 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.2; x86_64; ; )
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, freemangordon@abv.bg, aaro.koskinen@iki.fi,
        pavel@ucw.cz
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com> <1384856285-19593-1-git-send-email-pali.rohar@gmail.com> <20131119144407.GB28455@earth.universe>
In-Reply-To: <20131119144407.GB28455@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1481251.M8gYiG9GiM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311192238.34764@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1481251.M8gYiG9GiM
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 19 November 2013 15:44:09 Sebastian Reichel wrote:
> Hi Pali,
>=20
> On Tue, Nov 19, 2013 at 11:18:02AM +0100, Pali Roh=C3=A1r wrote:
> > This patch series finally bringing support for charging
> > battery on Nokia N900 (RX-51) without any proprietary Nokia
> > bits in userspace.
>=20
> YAY! :)
>=20
> > I removed hook function from bq2415x_charger driver and
> > replaced it by Jenny TC power_supply notifier code. This
> > simplify usage of bq2415x driver and also allow adding DT
> > support in future because driver does not need board
> > specific function anymore (only static data).
> >=20
> > I tested this series with linux 3.12-rc5 on Nokia N900.
>=20
> cool :)
>=20
> Do you want me to take this up and add DT support?
>=20
> -- Sebastian

Hello, if you have time, can you add DT support code?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1481251.M8gYiG9GiM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKL2loACgkQi/DJPQPkQ1KIZgCfYqrsQGgu1GMAF8/MlppAoRzD
CTQAn2YnouSDDB6lMSdAr2b9cxAUbzt2
=dgeJ
-----END PGP SIGNATURE-----

--nextPart1481251.M8gYiG9GiM--
