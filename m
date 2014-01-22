Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbaAVT02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:26:28 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58294 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbaAVT00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:26:26 -0500
Date: Wed, 22 Jan 2014 19:26:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com,
        Xiubo Li <Li.Xiubo@freescale.com>
Message-ID: <20140122192618.GX17314@sirena.org.uk>
References: <20140115113551.0eb13409@armhf>
 <20140115165145.2c2da894@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jGviIKn9uLGVFpXC"
Content-Disposition: inline
In-Reply-To: <20140115165145.2c2da894@armhf>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 4/8] ASoC: simple-card: simplify code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jGviIKn9uLGVFpXC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 15, 2014 at 04:51:45PM +0100, Jean-Francois Moine wrote:
> Have a cleaner code using a DAI link pointer.
=20
Applied, thanks.

--jGviIKn9uLGVFpXC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4BtWAAoJELSic+t+oim9Nm4P/RXhHLRBrA8VHwJwIyjfphVS
uqi35oXbwNlnGD0JSI0rqqyJWsFtlEx5ZcEShhrofNNuFTdfRzot8dpku8yGABc/
1gqyg77olfjYvdqfZpHsrcN46S7I6pOFaP3uKT7DVYDqHQXE9KrILcu4zp4bGLQC
pZE/MYGCM231lkHIp6o0hCqaiFv57gTfRFfxsO9mn/Ltj0LMoc6QKFW/XxT3dVEj
FQvMrKjMIdqaGs0abDXTa64S05aJQVW6cwoMkpAxpaxUSSYxVWVN7lCrKgGStjCR
skVUGrX4YfRO9OP2zorFrqZOb3wZt7XxDBdJm0oeWvF60mT06l5kfJMH+amXsAyV
yGSa/saQGaqlxDBMwMjhDZPaYcARdgM3hKWu+tgRl0Q/pl0RzXrJcaA9C6Xm0EiQ
zAXA/mX6aD41JHjF9vrvNbTG2HJ7CHezdEGryIRdFTfBqUfxatfHevdOKrWSeiGk
Yc/B0nbhk1a/gmJqpTJjM4e4Q9Wo14TcSEdoqY86t/VezNcdEkx/PGmm0XfKINHo
+NgJLtBYDgpj3OWF7NfC78CHUCSD9GFZ0o30EAHjsyufkpmSaeHaxCDYPDZq8Y2Y
bRVmVOv+ReUY3UfW2clgcZY94Nsg4IIs8OXo1oJdlawn+YR/kKETRL1P8g441YTn
Zrr1K9XIs1i1YwIdurYA
=EO6s
-----END PGP SIGNATURE-----

--jGviIKn9uLGVFpXC--
