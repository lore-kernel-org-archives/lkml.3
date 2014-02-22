Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaBVXgX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 18:36:23 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49503 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaBVXgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 18:36:20 -0500
Date: Sat, 22 Feb 2014 12:14:30 +0900
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        linux-spi <linux-spi@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Message-ID: <20140222031430.GV25940@sirena.org.uk>
References: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
 <1392907389-21798-8-git-send-email-geert@linux-m68k.org>
 <CANqRtoQVJzEgo_AdVxrPSRUY6ocyPaQ=RKQJyxoExDrfYxiJ3w@mail.gmail.com>
 <CAMuHMdUByWPcYM8M_m5NVM4QP5cQE_tOLGQg=2fTNF7gqkUhig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1J4USyVh4Jt5OGCL"
Content-Disposition: inline
In-Reply-To: <CAMuHMdUByWPcYM8M_m5NVM4QP5cQE_tOLGQg=2fTNF7gqkUhig@mail.gmail.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.4.12
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 07/10] spi: sh-msiof: Add support for R-Car H2 and M2
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1J4USyVh4Jt5OGCL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 05:13:16PM +0100, Geert Uytterhoeven wrote:

> "renesas,tx-fifo-size" and "renesas,rx-fifo-size" are part of the existing
> bindings, so I'm a bit reluctant to change these.
> Hmm, since the original bindings didn't specify the default values,
> I could make them chip-specific, though.

That sounds like a good idea, you could also change the properties to be
deprecatedn and recommend that people just don't bother setting them at
all.

--1J4USyVh4Jt5OGCL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCBYTAAoJELSic+t+oim9lvoP/RoR4Z6LiWUY98jRsxcfSFdB
aiYH+RmELi+0iGI8+VSibqRZK0QVLhqSfsH4LfnhAiEdrnfYuwqfTcdZ/+U/7SG1
x26D7AxO6GwNndlXCQze3ZUo3P/8EUP9X0pXuvi95qdwsjx4u5a4EJulEVs6LCYN
+66bWijGcwKcBMrxiaBxOy+uIXd2QxwocmooiTYq85ZSTXThG4o1cPbmVYxq7let
qYwciQCJXosOWlhHtXN0Ctk3eFSbR/buNssiXCgNnEpKsBKBRG1pvBy0bbkjd2sR
PMOnai1/fTE1uMdY22SkmAdlKWL7MKV67tv2DgN3FhKV7+NVxwdR+BaaL7/w0Z7G
rxPmvATqLp7EHZe9021nYJHV8RjCErpSR6Vk2RRhUpvzTNGvL5A5/N0/wd4cOGpo
VqrUDASlvJpSyhMOhBBZO9xYBs2i16tmqEU6ToA917YE4N2s69/6f7KV7hvIjmti
ucqo/x9a+tw6K401vRwo4xaiLZ+pbGa2htAIkHJjQoOMXrMCFELZEnKTU43UkZdh
nc1dX1geAwLqa6JFRgX96wyFugUHjiRUMBd9HpeUHXXONwbAJM3Fea5ZTIKD1rWC
nktH6mViSCVHyiEotW8JsWDVqgP1OBkOljBoaze+UxPXG/y6Qle0qp9U/pE5oZ2w
tH+yFWQqYNHl+/ukIdyp
=oyed
-----END PGP SIGNATURE-----

--1J4USyVh4Jt5OGCL--
