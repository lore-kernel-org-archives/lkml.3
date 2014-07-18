Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935023AbaGRQg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:36:58 -0400
Received: from mail.sf-mail.de ([78.47.74.12]:45984 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384AbaGRQg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:36:57 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Fri, 18 Jul 2014 18:36:45 +0200
Message-ID: <1883713.E4uoxDXDyt@caliban.sf-tec.de>
User-Agent: KMail/4.13.2 (Linux/3.15.4-1.g2b59ae6-desktop; KDE/4.13.2; x86_64; ; )
In-Reply-To: <1405588695-12014-1-git-send-email-tytso@mit.edu>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart22677037.uztPAu2aTS"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart22677037.uztPAu2aTS
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Theodore Ts'o wrote:

> DESCRIPTION
> 
> 	The system call getrandom() fills the buffer pointed to by buf
> 	with up to buflen random bytes which can be used to seed user
> 	space random number generators (i.e., DRBG's) or for other
> 	cryptographic processes.  It should not be used Monte Carlo
> 	simulations or for other probabilistic sampling applications.

The "for" looks misplaced, shouldn't this be "for Monte Carlo simulations or 
other ..."?

Greetings,

Eike
--nextPart22677037.uztPAu2aTS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlPJTSMACgkQXKSJPmm5/E6o7gCggoszbVeh52J3cF1yROIdHqc9
yOAAnA8gcIcFthALvU++/WoUU0HNhDVX
=YeqZ
-----END PGP SIGNATURE-----

--nextPart22677037.uztPAu2aTS--

