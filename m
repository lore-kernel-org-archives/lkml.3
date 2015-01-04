Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbbADXFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 18:05:32 -0500
Received: from khitomer.mortis.eu ([185.27.175.75]:43361 "EHLO
	khitomer.mortis.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbbADXFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 18:05:30 -0500
Date: Mon, 5 Jan 2015 00:05:28 +0100
From: Giel van Schijndel <me@mortis.eu>
To: linux-kernel@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steve French <sfrench@samba.org>,
        Rahul Bedarkar <rahulbedarkar89@gmail.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        "open list:CERTIFIED WIRELES..." <linux-usb@vger.kernel.org>,
        "open list:COMMON INTERNET F..." <linux-cifs@vger.kernel.org>,
        "moderated list:COMMON INTERNET F..." 
	<samba-technical@lists.samba.org>
Subject: Re: [PATCH] Use memzero_explicit to clear local buffers
Message-ID: <20150104230527.GJ4806@salidar.dom.custoft.eu>
References: <1420394744-20268-1-git-send-email-me@mortis.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lqaZmxkhekPBfBzr"
Content-Disposition: inline
In-Reply-To: <1420394744-20268-1-git-send-email-me@mortis.eu>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lqaZmxkhekPBfBzr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 04, 2015 at 19:05:40 +0100, Giel van Schijndel wrote:
> When leaving a function use memzero_explicit instead of memset(0) to
> clear locally allocated/owned buffers. memset(0) may be optimized away.
>=20
> All of the affected buffers contain sensitive data, key material or
> derivatives of one of those two.
> ---

Forgot to:
Signed-off-by: Giel van Schijndel <me@mortis.eu>

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
"Question: what do you call your programming methodology?
 Answer: Faith based development. You code and then pray that it works."
  -- John Spelner

--lqaZmxkhekPBfBzr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSpxzcACgkQZBYm/87l50JXdwCghdjEOFoNthiW/f473N2RIPXH
tfAAoIiPfYASW9F/CSGBPBSqKE4tGCwd
=iRgY
-----END PGP SIGNATURE-----

--lqaZmxkhekPBfBzr--
