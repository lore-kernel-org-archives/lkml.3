Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaIPHLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:11:12 -0400
Received: from ozlabs.org ([103.22.144.67]:51600 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbaIPHLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:11:11 -0400
Date: Tue, 16 Sep 2014 17:11:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Foley <pefoley2@pefoley.com>
Subject: linux-next: build failure after merge of the rd-docs tree
Message-ID: <20140916171102.61509be5@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/yYOWvEpnuIeQ1se6.wNeKQp"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/yYOWvEpnuIeQ1se6.wNeKQp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Randy,

After merging the rd-docs tree, today's linux-next build (powerpc
allyesconfig) failed like this:

Documentation/vDSO/vdso_test.c:15:22: fatal error: sys/auxv.h: No such file=
 or directory

Caused by commit e9cb990eff15 ("Documentation: update vDSO makefile to
build portable examples").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/yYOWvEpnuIeQ1se6.wNeKQp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUF+KMAAoJEMDTa8Ir7ZwV90IP/3T01HPTvz3VKzaKp6nn4wyL
iuzrNRG6ibyGFQAt9XhN/dhcftRHB59uCAXxlxPs3NKE5hkykS6mQbgI3RDzdjFZ
X1csCAvxoye7XCGo074pKdionHXrvucE+mqzJkRrkMdAzmL/1N8khIf0E9/7hdx3
h8qFG71pTLpOXfjM1lw9UY1PNixCU4GOK+T5MrjBBNDCEkSlmYOw4nVEwgF2N7FT
+OR5bAW4Zg7ODIxw+N13bWllH4792Tfr9mBLAv6gW6WTB1f1yNVhR4BLxeaE7Quw
b/SxV0cApNk5frHE3TRyvuxlCjImwDIY5AZOoOF4hvivLASmlCI2ePVdPt/+ajk7
mxKDECfDPH71tSUj2jLyv3bsPGSHJfIdaOmxfKixwV9/Yg1l82oTJ4CI215BEmze
Bp30NJSW9P77c4RYTPSvW4Ch/3T8DYOTfJC814pD6cHxMQXojTsH+rcVzN4O5/GT
R3dPqIvqP2p7KV5KZfBEbNzMwu+3HUk1CdgPb8B3+Faxe9dGzBHGO6IBVL5Xel9m
+6zwvoejT+yOhu5UDNSgH/Ig0z/AUPgmAbuVrgeOymhyLI9ANABFwlqPfF7IXNgs
MkeABl3Ucn1+xVbYE14CEcSqIVxjzanqEl0Ezffrvz9ZvaHZzFuSjXLgW73vOhVw
YoJPIg4Pjb1AXUbarvKK
=52LX
-----END PGP SIGNATURE-----

--Sig_/yYOWvEpnuIeQ1se6.wNeKQp--
