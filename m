Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502AbaDJBSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 21:18:22 -0400
Received: from ozlabs.org ([103.22.144.67]:48860 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932996AbaDJBSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 21:18:20 -0400
Date: Thu, 10 Apr 2014 11:18:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: error fetching the drivers-x86 tree
Message-Id: <20140410111810.45b37fc0d3fa68e4513fa027@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__10_Apr_2014_11_18_10_+1000_67tCA64=zHlL=8Hy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Apr_2014_11_18_10_+1000_67tCA64=zHlL=8Hy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

Fetching the drivers-x86 tree
(git://cavan.codon.org.uk/platform-drivers-x86.git#linux-next) today (and
yesterday) produced this error:

fatal: read error: Connection reset by peer

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__10_Apr_2014_11_18_10_+1000_67tCA64=zHlL=8Hy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTRfFXAAoJEMDTa8Ir7ZwVIhYP/2kV0uftFyAed32poD1x3KGu
Pzeke/5F0pFYYHNCeQ7XLFKTAQfzSzFguQVsxhQxoOuzj7yDzR10LnhG2dR7V3PU
ER2GFV9GpmNOZ2ilTD370Aey5W0VYD8BT2eIlPQr6hMBKikMA+yAmnJzLZMZdwRB
7EZthgupnAl7ISj/u/QwBZaMAeHwqsENIDA5Ew8vXvS2Au3R9WyUmSv0XS53eYAP
C2Aa3S3BWHEHKDRujoObqks0OJ3G1BZzYq0M2JKsZARd2y6S6AwjPoqDxz4zGG+5
9qhhFghzTm8+iEbNC+4ODHFvytLAQhsqL3vRX7YjNDCnFSFzWAiqmODH7C+Jho3u
Hf7bfW9vVAaIBTS6QPdU2wCdCAcTsvmJKiCC9n7hiaelStBJHgF0OvrXPTRCnCjH
M/YfSEQ2BZjVDM2b2IVbqR2ROv8BLQUJnMBcCoxUQ+FH+1WvzFkZ2fAtHxIZdf9E
3UPoGplt37eylpLEeNYME+mDdrekAuhaDytjF7AOpV+4Zz5APDGGtEaPLmIhvTqZ
2LFYqAfsnKi8dJT/OhmrQ4WzU3Ddow65gOKpSa8gv3Nfc4JU7g0qe7v70wbpzcgy
/NsHcEPwtIcqTjYIBYdAdCauUTgMR9iYzTFLggdschyas58wVA+B7bu38Sp8AyV0
6ORRUlPrh2JE7AnN/sYD
=bb1w
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Apr_2014_11_18_10_+1000_67tCA64=zHlL=8Hy--
