Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760825Ab3JPPyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:54:37 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:37408 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab3JPPyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:54:35 -0400
Date: Wed, 16 Oct 2013 17:52:18 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, David Howells <dhowells@redhat.com>
Subject: Re: linux-next: Tree for Oct 15 (asymmetric keys)
Message-ID: <20131016155217.GB20211@ulmo.nvidia.com>
References: <1381845763-10487-1-git-send-email-treding@nvidia.com>
 <525DC4FB.4010305@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y7xTucakfITjPcLV"
Content-Disposition: inline
In-Reply-To: <525DC4FB.4010305@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y7xTucakfITjPcLV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 15, 2013 at 03:43:07PM -0700, Randy Dunlap wrote:
> On 10/15/13 07:02, Thierry Reding wrote:
> > Hi all,
> >=20
> > I've uploaded today's linux-next tree to the master branch of the
> > repository below:
> >=20
> >         git://gitorious.org/thierryreding/linux-next.git
> >=20
> > A next-20131015 tag is also provided for convenience.
>=20
> on x86_64:
>=20
> crypto/asymmetric_keys/x509_public_key.c: In function 'x509_key_preparse':
> crypto/asymmetric_keys/x509_public_key.c:237:35: error: 'system_trusted_k=
eyring' undeclared (first use in this function)
>=20
> when CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=3Dm
> and  CONFIG_SYSTEM_TRUSTED_KEYRING is not set.
>=20
>=20
> Full randconfig file is attached.

Thanks for catching these Randy!

Thierry

--Y7xTucakfITjPcLV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSXrYxAAoJEN0jrNd/PrOhhTwP/2yM+WqjY4nsUdSHeUtVM3Dl
DE9JhOqsdWCM2fNiMq6wDcN3MaudKi8X5+J4nDD/4JLLKdJIcQ2xrseazHPLGNAb
G0izlpi9RyjrXV03TbU/IagR/xkqVJtAREQymtSfUCoBHtUuXlJYlCUoaQOfpa66
NhaxDcUD4Ogv+RAdXfzwnqxNTX1NbzqKqAQykhUp/vENEZSDWE0txbGt860Vp2Ur
Zszy7xQZaffcbk7x81OpsTlBIiAn9zWgymlHrFO+hM4U3T1oU9muo5tmCgRzXmXW
/fyf0JP13Fn2cm67g//ofzaAC4TNOndnr+ltaJV2LrIMVsiPHlAUJFvudNO8+a9C
PNroKEoCVlkHvmn2DY312luMM5G0Y4Y8oXjL9KSPZxG0QlcQwg5IAIWyvLkIRZKk
j8P0IsaPBSlialCk9YWysfo6S94PUZz6g/UcpsSGjS2cOw6V+vGj9PsXMqJgmzxV
4kiZsrIi54yj5mV6fouOrN3pN973lCa2ja36eF16EmEvX4o+UoxGtSUYvfvc8Wcw
5NB2aeUHTDkzbyW70PHu2LMk7ibpgTfiJKo6klshpoaNJEavy2rRaRDDcGC77IHh
h7dhfUvNoIARIdPB+gxVplR8sMbzF3y170kF28z7iluClC22swM7LRs1llAUyNVu
LnYGHunWk0dChYOoSMqr
=YG0L
-----END PGP SIGNATURE-----

--Y7xTucakfITjPcLV--
