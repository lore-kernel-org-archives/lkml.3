Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaG0Xfg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 19:35:36 -0400
Received: from ozlabs.org ([103.22.144.67]:55259 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbaG0Xfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 19:35:34 -0400
Date: Mon, 28 Jul 2014 09:35:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: of: Make OF_DYNAMIC user selectable
Message-ID: <20140728093526.38d8e732@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/VaepzBHQZva+sQmpb/+w6G_"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VaepzBHQZva+sQmpb/+w6G_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Grant,

I noticed the subject commit in the devicetree tree in linux-next today.
The commit message gives us no idea why we would want to make this
change.  We already have lots of user selectable CONFIG_ options ... do
we really need this one as well?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/VaepzBHQZva+sQmpb/+w6G_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT1YzDAAoJEMDTa8Ir7ZwVEEkP/j1EImUJF3WsO3EILCQJuoKd
RBpk/juZpmRQkKSt13CXy2zvC+wL2Ul0hQLJ79Tih9mOURNFWQ5Oy6IxlXOw7CKj
7d7B4N/GvFmMzLrTrIAXN9r3N+iv7Vce221QfpPCj9JUVZi11qzjBLrQKGnwZbGy
3OsUDkHCBuCb+C9/NlyTlUKNc+UQ58tR1/lm4W7p2ChLJ76XXjxkjs5QoXiAnN8F
ZtvAbIb6/VJTtkCJDfZvMBVe82i2Re7nk2p1Hovqj/n3+BuzEaxwdr1vwzho+NST
txfPUJmO7hdFXam2wjti8Cr6Rpzsj5jRx76vQclri0ltAtKbbVnpsyek5PWyY9JM
XU7j+plqOPdGIasnj9h68XjF6TYPpNlD7EUaXHC7N3W7xI+bVNpDWM1hEK2QOpiW
nKhd+tuMS71sgM4i8kGwUMzgETAnU3OOte+EvxX6PUV+XUgGaa57+C6X4F6lRJY9
UMNP/GS3J9uY2e24YEyTeYo0wANr8Ajo9hl34EhukoBnvxrDV2+Em/O1LDOAWgZf
nyjBw3RBrE84F5MTxQUjnx05I5rCsuj7iyvCjwms2lwf9AurMM346D9sxr3909cM
W4Cc8mhNEvhPNNascAYN0sB/WsNNY+f34W+tlk0n6a+5pE76RuhIDl/soPwxyGax
zcKLPMXEqEiJf/raDsU1
=1Z4d
-----END PGP SIGNATURE-----

--Sig_/VaepzBHQZva+sQmpb/+w6G_--
