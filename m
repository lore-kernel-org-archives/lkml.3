Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaBBISe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 03:18:34 -0500
Received: from csamuel.org ([74.50.50.137]:48883 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbaBBISd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 03:18:33 -0500
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Feb 2014 03:18:33 EST
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org, fdmanana@gmail.com
Cc: David Rientjes <rientjes@google.com>, Chris Mason <clm@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs
Date: Sun, 02 Feb 2014 19:09:27 +1100
Message-ID: <3940033.UmTJfTXWpa@quad>
User-Agent: KMail/4.12.1 (Linux/3.11.0-15-generic; KDE/4.12.1; x86_64; ; )
In-Reply-To: <CAL3q7H5OW8GXUYB3rDMVf0Z7b-xPEbePWCg34wK8Y6HYXkn0zg@mail.gmail.com>
References: <52EAC9B6.7090603@fb.com> <alpine.DEB.2.02.1402011611400.5908@chino.kir.corp.google.com> <CAL3q7H5OW8GXUYB3rDMVf0Z7b-xPEbePWCg34wK8Y6HYXkn0zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2664934.ayRkUYC5Ha"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2664934.ayRkUYC5Ha
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Sun, 2 Feb 2014 01:28:07 AM Filipe David Manana wrote:

> One of the kbuild test robots reported this a few days ago too.
> The following patch, sent shortly after the robot's warning, fixes it=
:
>=20
> https://patchwork.kernel.org/patch/3554671/

I can confirm that fixes the bug for me (with a different config than m=
y usual to=20
trigger the bug) at v3.13-11307-g5cb480f. Much obliged!

Tested-by: Chris Samuel <chris@csamuel.org>

All the best,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
For more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart2664934.ayRkUYC5Ha
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEVAwUAUu39N41yjaOTJg85AQKSCgf8CTComMxBlDJkOJ+erM4b4ARyROT1STvD
WgnknqXr+z4bT3Uw+oAKw8VM/JZZCE5WNVCUL51tQxa+u68F2ddQ8P2fi/ULTlnU
eN83OD+uFHyFfaiqgYXNQLOzSj6Xst56kb5aUqdsK/HHwrSp5pL24NWwk9sENdIn
pvFywkzolPOdpfwRCX2Ipc+G6xDIrBy0VshXD+lgakEeN7Mcx+rocxSD5Y0mwmOA
EvIQzFqp7FXOXR0VZNkk278o+9t1KAlmA8MA6fTlwTFowvg5k5dDn/M3tAkgZFMr
SN3iOQTq7vwgLagQixW+npRC0dvu9QdPs+2/yQGPkGbz5iu40l7s3w==
=e6/p
-----END PGP SIGNATURE-----

--nextPart2664934.ayRkUYC5Ha--

