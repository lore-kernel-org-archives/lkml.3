Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbbADXEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 18:04:45 -0500
Received: from khitomer.mortis.eu ([185.27.175.75]:26725 "EHLO
	khitomer.mortis.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbbADXEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 18:04:44 -0500
Date: Mon, 5 Jan 2015 00:04:43 +0100
From: Giel van Schijndel <me@mortis.eu>
To: linux-kernel@vger.kernel.org
Cc: Armin Schindler <mac@melware.de>, Karsten Keil <isdn@linux-pingi.de>,
        "open list:ISDN SUBSYSTEM" <netdev@vger.kernel.org>
Subject: Re: [PATCH] Fix NUL (\0 or \x00) specification in string
Message-ID: <20150104230443.GI4806@salidar.dom.custoft.eu>
References: <1420394722-20197-1-git-send-email-me@mortis.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bygAmIonOAIqBxQB"
Content-Disposition: inline
In-Reply-To: <1420394722-20197-1-git-send-email-me@mortis.eu>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bygAmIonOAIqBxQB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 04, 2015 at 19:05:22 +0100, Giel van Schijndel wrote:
> In C one can either use '\0' or '\x00' (or '\000') to add a NUL byte to
> a string. '\0x00' isn't part of these and will in fact result in a
> single NUL followed by "x00". This fixes that.
> ---

Forgot to:
Signed-off-by: Giel van Schijndel <me@mortis.eu>

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
"There are 2 types of people in this world - those who like Chuck
 Norris and those who are dead."
  -- Jus12

--bygAmIonOAIqBxQB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSpxwoACgkQZBYm/87l50KkDgCfX3bEP7hKA8bQv5RaLHlkgsjA
sOAAoJo2xp2t02Fe32uGIcVNtrguKX2E
=VciB
-----END PGP SIGNATURE-----

--bygAmIonOAIqBxQB--
