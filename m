Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab3GPKPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 06:15:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51033 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab3GPKPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 06:15:06 -0400
Date: Tue, 16 Jul 2013 11:14:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Message-ID: <20130716101441.GG22506@sirena.org.uk>
References: <20130716084747.04625f29@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="reI/iBAAp9kzkmX4"
Content-Disposition: inline
In-Reply-To: <20130716084747.04625f29@armhf>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: kirkwood-i2s: fix a compilation warning
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--reI/iBAAp9kzkmX4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 16, 2013 at 08:47:47AM +0200, Jean-Francois Moine wrote:
> In the function kirkwood_set_rate, when the rate cannot be satisfied
> by the internal nor by an external clock, the clock source in undefined:

Applied, thanks.

--reI/iBAAp9kzkmX4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5R0NAAoJELSic+t+oim9MBsP/Rd04K3/it3V7BUV+wTNdmtV
/Heh6ZGsZ+zQ+zZNR6ag27yhQzTm4stEk5bbNwnrmR//L66bAClaYNWoLOh4AXPJ
dWvTDXongun27SHfE5hY8+P99/EMA99u2gNOmxil070HWUqhsVDyf562gx3G4Uar
FZg0pugQjzHNud1kQjpO77JSsrp25XoUHx6/mp2jGQg+VdLa90LuclR5N2YyVuVK
Rv8wd4ie/eWgooALj74DFpNKQqEqdBFMahNRcxbNP1BcQMrZovrwL4d1RKxZsaKA
BxYKiWxCcJkbrfoC6zXP184Nx+2fHYX/62OtrT3CbpVc0PVlGnhWumQHuV+XGgUz
hwOOnjl7KVh4+f4SVBHCoQM6hdkmHsjkXyBUF1MZtVYt67b9mv978fK/HCg1yH0h
tvIFJknFucQyLj07f53ImMoJzluKlMBDusz5+NqOTzVrFOrpWQ/0lMZA+F3luYqU
re8JgKf8mELZvokzS6EVVXCzk09ciz+XAEIbjv46r0/3NXpXqvZPhh1Lv4VZOrYM
ZBLXhbKV6it0XQWEJQ/zlX2Jz+ML6CwLzpG9+ww5QGIxaV/jDBdKjv3xqeuHVYVa
0fvb4/Qmlw8mgKVNwoCOv5LcXxGmyj/eMp/V8+YENL9pFX+s2mngUy/Db7ruNyLG
zBt6JTCac8AEPs524tdZ
=4iJ5
-----END PGP SIGNATURE-----

--reI/iBAAp9kzkmX4--
