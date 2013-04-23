Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab3DWTzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 15:55:11 -0400
Received: from mout.gmx.net ([212.227.17.20]:51917 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab3DWTzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 15:55:09 -0400
X-Authenticated: #815327
X-Provags-ID: V01U2FsdGVkX1/89cY+9mH86fc5U7d7+2S+xcZ2HA7O22O497P16S
	eBZfKPa72UxVhd
Message-ID: <5176E715.2070201@gmx.de>
Date: Tue, 23 Apr 2013 21:55:01 +0200
From: =?ISO-8859-1?Q?Malte_Schr=F6der?= <maltesch@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130413 Icedove/17.0.5
MIME-Version: 1.0
To: linux-nfs@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: NFS4 sec=krb5 broken in 3.9-rc8
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2KMLOTBWEQBFAFLRLUUAS"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2KMLOTBWEQBFAFLRLUUAS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,
when I update my server from kernel 3.8.5 to 3.9-rc8 I cannot mount its
NFS exports from clients using nfs4 and sec=3Dkrb5. Using sec=3Dsys works=
,
using 3.8.5 also works good with both modes.

Kind regards
Malte Schr=F6der


------enig2KMLOTBWEQBFAFLRLUUAS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlF25xgACgkQ4q3E2oMjYtV4/ACeJiKFsx9Hh7wqii3ORlYUjQyB
xtkAoMq+wFxftNfV5ulPYAsCikCNPcCb
=rcTr
-----END PGP SIGNATURE-----

------enig2KMLOTBWEQBFAFLRLUUAS--
