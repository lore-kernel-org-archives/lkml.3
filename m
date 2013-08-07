Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab3HGQpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:45:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55530 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217Ab3HGQpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:45:33 -0400
Date: Wed, 7 Aug 2013 17:45:09 +0100
From: Mark Brown <broonie@kernel.org>
To: "Felipe F. Tonello" <eu@felipetonello.com>
Cc: alsa-devel@alsa-project.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Message-ID: <20130807164509.GO6427@sirena.org.uk>
References: <1375430365-13232-1-git-send-email-eu@felipetonello.com>
 <1375430365-13232-2-git-send-email-eu@felipetonello.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y8OL7jWO5wDKNv+B"
Content-Disposition: inline
In-Reply-To: <1375430365-13232-2-git-send-email-eu@felipetonello.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/2] ALSA: Added jack detection KControl support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y8OL7jWO5wDKNv+B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 02, 2013 at 12:59:24AM -0700, Felipe F. Tonello wrote:

> +int jack_ctl_integer_info(struct snd_kcontrol *kcontrol,
> +                          struct snd_ctl_elem_info *uinfo)
> +{
> +	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
> +	uinfo->count = 0x10000U;
> +	uinfo->value.integer.min = 0;
> +	uinfo->value.integer.max = 0xffff;
> +	return 0;
> +}

I'd expected to see us creating multiple boolean controls here.  I don't
have a great problem with doing things this way but it's surprising and
I worry about confusing existing userspace, Takashi?

--y8OL7jWO5wDKNv+B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSAnmSAAoJELSic+t+oim9xlAP/jcfusQyOPfpS8ZiyFFu4MI+
oJmwHwCy4YQTrcexZwyELF5SGy1RLUEShzuBkdPKJO3Wtq2PoWvzdWX0L2r0rus6
YkFo/tW/DHDeGjUOvojTw7sDTCyNxrjDMzB6eGo7RJEB45eL5cyZTZcxSAoGsOfi
CPpsk0gR+QVo8znl3yqGe64shlVIzRkwiuzUK85XRrWnbOtNe0FelHYLFvjjgEA0
CTqaq1dvO21t5Rcyt7U2JWpfQBieVRbUqTMtLPCYu1+SqRrvUqDKjSPKVZYy0h5n
ZvTTnQsYUBl81Sb1i32u5ZKZOUm1xHEhRonEqRlaxflaeUGQnUe129KhhIYjKGxa
sxEI8/Dt6ib/vQE6eAv05zgLFdsch5el62SnT9xCt/zQ6iUsiByNM+CfGAU0a9+G
Bc8Paj4gskpayco6Iii6XWVxcRnvVROXxVpj1NE9VwFs8BJ0QDu0DA85setL08Xk
55/FT7fFw6NwNZp+HSXkm3nFRr7FQJFnmU+Qk2UdWbC/Fhlk7G5butAn24liUKyL
ylAMbpWw628RcBCw8Xjc9zT8jtH+JxxiD04uJGpZpVf5dks/r5Ml7qUqDc605SGM
/12n/kSHpAD35QivLtjTTe/NtaBLttzcLRr/zTTrtEOz1zquUCnxakETrE+taQrt
sUH1X+nkjp8iPj6o1ES1
=GkSd
-----END PGP SIGNATURE-----

--y8OL7jWO5wDKNv+B--
