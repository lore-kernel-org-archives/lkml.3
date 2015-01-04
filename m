Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbbADXET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 18:04:19 -0500
Received: from khitomer.mortis.eu ([185.27.175.75]:51059 "EHLO
	khitomer.mortis.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbbADXES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 18:04:18 -0500
Date: Mon, 5 Jan 2015 00:04:17 +0100
From: Giel van Schijndel <me@mortis.eu>
To: linux-kernel@vger.kernel.org
Cc: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>,
        "supporter:QLOGIC QLA3XXX NE..." <linux-driver@qlogic.com>,
        "open list:QLOGIC QLA3XXX NE..." <netdev@vger.kernel.org>
Subject: Re: [PATCH] Fix an infinite retry-loop
Message-ID: <20150104230417.GH4806@salidar.dom.custoft.eu>
References: <1420394696-20099-1-git-send-email-me@mortis.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5UGlQXeG3ziZS81+"
Content-Disposition: inline
In-Reply-To: <1420394696-20099-1-git-send-email-me@mortis.eu>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5UGlQXeG3ziZS81+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 04, 2015 at 19:04:55 +0100, Giel van Schijndel wrote:
> This was clearly intended as a retry-10-times loop, but due to the
> absence of code incrementing the loop-counter it was practically a
> retry-forever loop.
>=20
> Rewritten it as a for-loop as well to make the loop-counter increment
> (as well as its potential absence) easier to spot.
> ---

Forgot to:
Signed-off-by: Giel van Schijndel <me@mortis.eu>

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
"A computer is a stupid machine with the ability to do incredibly smart
 things, while computer programmers are smart people with the ability to
 do incredibly stupid things. They are, in short, a perfect match.
  -- Bill Bryson

--5UGlQXeG3ziZS81+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSpxvEACgkQZBYm/87l50LRDQCcCMx8dYOG+/+CiMdPjWXciVn2
YZEAoL626qFUWptTYUEd+4rRhtHFTJbF
=/mlU
-----END PGP SIGNATURE-----

--5UGlQXeG3ziZS81+--
