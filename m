Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaETABh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 20:01:37 -0400
Received: from ozlabs.org ([103.22.144.67]:49058 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbaETABg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 20:01:36 -0400
Date: Tue, 20 May 2014 10:01:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: failed to fetch the mips tree
Message-ID: <20140520100125.74f561ba@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/k7Pf/5E+QUuesfm6/WTLfaF"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/k7Pf/5E+QUuesfm6/WTLfaF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

Yesterday and today, trying to fetch the mips tree
(git://git.linux-mips.org/pub/scm/ralf/upstream-sfr.git#mips-for-linux-next)
hangs for a long time (I got impatient and just killed the fetch).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/k7Pf/5E+QUuesfm6/WTLfaF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTeptaAAoJEMDTa8Ir7ZwVGVIP/A2PGrJC0bVdTJkKuG+w7y/Q
hmUR8Yp2Kg7eI/A6+dJYBVe2Hna+8PZS1QEVA/1Rt9eFRs7+qTJK/nCIfbgL/mu3
kPaUS6NMMidp7k/SO9esiwlOzpcP4FEP+j114a+xhOJO5VRz0pocpBtka9fhn4rA
r9AWwmfrrft/O3wcnNU4wf+7s+4oZplDl6dXgI/AIlPdjBpcA4sWho2T4bRYGcC0
ofDTbLhpoWpkY4thsZFKrLPWYXtwIn7Z3t6FOTJrJwpgi++w2l/imm99Mu1AIOfa
xZmzIajRozJlq9eAlfNVdeCbpFohfbgQ3DRJS0I6NA8Ptm40naG5CVI18P+O+IWG
t5kfRr2u5rMsuY0vbNxCow0Q1PnbClnk8hdGgtWfDBAQudtfFzpVqH5uDemPGJr8
y9sWyXRmCg+auvUqObAFbk2A4UW/IJzlQDf6Lhn9+eYpjl36E4D/flZp3pa8guWo
OOTuljiDIP4SG3+1EAFU2HdaLQMFdpBjAHoLzrKTPddTbi1jZdaIXRo2pYr6gE66
n9ytox3ffpC77o19Ako7WVX0tIwwVRqhgEsuL1SydnxvGCB2DlS/TVPX+yPPrnMW
NNOtjfqL07iJdGs42tsAWXq/MKmhbEaSPqCR+baNdOr01BrqkqUeFHKsdu//5MOI
sRbtJeNb7NjASe4Tg4dq
=OqDj
-----END PGP SIGNATURE-----

--Sig_/k7Pf/5E+QUuesfm6/WTLfaF--
