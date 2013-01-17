Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439Ab3AQJuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:50:04 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:52432 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978Ab3AQJuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:50:00 -0500
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2013 04:50:00 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoQCAJtkv1BbdWObgWdsb2JhbABEvisWDgEBFiYngh4BAQV5EAsOCgkTEg8FSYgnwimQF2EDlgKTOw
Date: Thu, 17 Jan 2013 10:40:36 +0100
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: linux-next: manual merge of the char-misc tree with the tty tree
Message-ID: <20130117093958.GA10117@fourier.local.igalia.com>
References: <20130117135420.8575233a25bdeb64c4b38d9d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="JYK4vJDZwFMowpUq"
Content-Disposition: inline
In-Reply-To: <20130117135420.8575233a25bdeb64c4b38d9d@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JYK4vJDZwFMowpUq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 01:54:20PM +1100, Stephen Rothwell wrote:
> Hi all,
>=20
> Today's linux-next merge of the char-misc tree got a conflict in
> drivers/ipack/devices/ipoctal.c between commit 2e124b4a390c ("TTY: switch
> tty_flip_buffer_push") from the tty tree and commits 7e5730d7c222
> ("ipack/devices/ipoctal: fix kernel bug when using pppd"),
> e7e664fd688a ("ipack/devices/ipoctal: protect the channel data processing
> with a spinlock") and b06073f963b7 ("ipack/devices/ipoctal: remove
> redundant tty_flip_buffer_push()") from the char-misc tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me.

Thanks!

Sam

--JYK4vJDZwFMowpUq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ98cUAAoJEH/0ujLxfcNDd+wP/iBb7EWtVoMojbjO6JoScdMb
DW7Q3jVwnrQK2JJbKwDOIVowLIRuMAYbn9pOYm/QX+1ThcA2ro/w4hip+l8uDYxg
irCuopzvu79xraoRFPlA4YHbOD5wZv23FINW8DJx/B7HZPzFkcvfHRhyRyZgpXJq
9jOAjB66nlWGcCJ2vLexomY+D+RHMcS+Zu9rw5j78uZUVxFDt1f7ma5JDsMhLSDV
yhbXj3HAbCmCu6cyKrdmnSF9uRzcG7jT9O6ZAVBdPuycKi2fd8dZW/lBcXYr6tZq
WFuUjPG6rGj/9g+Y1VBiTavMtk6XNeIkXgMMbrPectGo7L8JR69I7HLJdPwD9IUq
gJ7wk6+T9lXveBuItAIef6JsGI94q8TgpjlxjDILAhpU30aI75DZ2ebVMbYSZCYs
broEHZ/Og8XVnM/pAE4+PteJHwNBFFGVQSP6Uo5s+rksEfP4NGJgBhrxqGM9zBHi
3WDNXh0jgWZhzGV8t+STYm98k9aEjrtK6nSDG/HPaOIuym0nP/g7D/nQe4Y5Y+RL
avMoXObIhXl4QscwgA6E5S1xYRL/ZmIhiRRkdWWzsTX+Tau1qpIPskPAF7f6fKen
x+EvrouQFsQ66kHYVxvhMfQTxCIS6fbuglZ3YfUSPH84bxz0siibxMA76/6a3EDt
GQgS1Cf0vYxa4/23HOeL
=incG
-----END PGP SIGNATURE-----

--JYK4vJDZwFMowpUq--
