Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab3EMWAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 18:00:21 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:46197 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab3EMWAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 18:00:20 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 May 2013 18:00:20 EDT
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Helge Deller <deller@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [GIT PULL] parisc updates for v3.10
Date: Mon, 13 May 2013 23:53:29 +0200
Message-ID: <2654532.supg57YsM8@donald.sf-tec.de>
User-Agent: KMail/4.10.3 (Linux/3.9.1-1.gb6484b6-desktop; KDE/4.10.3; i686; ; )
In-Reply-To: <20130513204843.GA1858@p100.box>
References: <20130513204843.GA1858@p100.box>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3093006.pdgbnbJYAQ"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3093006.pdgbnbJYAQ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

> Helge Deller (2):
>       parisc: make default cross compiler search more robust (v3)

Needs CC:stable as without this building 3.9.x is not possible in some 
configurations.

> John David Anglin (1):
>       parisc: fix SMP races when updating PTE and TLB entries in entry.S

Possibly also this as it's a bugfix, but Dave is the one who may be judge how 
"clear" it is.

The same is probably true for these from the first round of updates:

John David Anglin (2):
      parisc: use long branch in fork_like macro
Mike Frysinger (1):
      parisc: fix NATIVE set up in build

While I _really_ appreciate the speedup that recently happened to the parisc 
development recently I would also appreciate if we can can finally get the 
bugfix parts of that into stable kernels so we have the non-development tree 
buildable and working without the need to backport all those stuff by hand.

Eike
--nextPart3093006.pdgbnbJYAQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEABECAAYFAlGRYOAACgkQXKSJPmm5/E7fQQCePH17LwMNl2xP7CpUp8WOgjnh
63YAn1ESO0NhtvLZYKfKT8O7H/b+zxgl
=x2AD
-----END PGP SIGNATURE-----

--nextPart3093006.pdgbnbJYAQ--

