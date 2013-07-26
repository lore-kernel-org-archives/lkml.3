Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab3GZS4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 14:56:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49417 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab3GZS4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 14:56:32 -0400
Date: Fri, 26 Jul 2013 19:56:09 +0100
From: Mark Brown <broonie@kernel.org>
To: "Felipe F. Tonello" <eu@felipetonello.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>,
        Wang Xingchao <xingchao.wang@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>
Message-ID: <20130726185609.GY9858@sirena.org.uk>
References: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
 <1374863133-6745-5-git-send-email-eu@felipetonello.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yeHj6vyFcpxC+65j"
Content-Disposition: inline
In-Reply-To: <1374863133-6745-5-git-send-email-eu@felipetonello.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] ALSA: oxygen: Updating jack implementation according
 new ALSA Jacks
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yeHj6vyFcpxC+65j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2013 at 11:25:33AM -0700, Felipe F. Tonello wrote:
> From: "Felipe F. Tonello" <eu@felipetonello.com>
>=20
> ALSA standard jacks already are implemented using ALSA KControl.
> So there is no need implement that itself or to use snd_jack
> for input events only.

Similar changlog comment as on the ASoC patch and...

>  	snd_jack_new(chip->card, "Headphone",
> -		     SND_JACK_HEADPHONE, &data->hp_jack);
> +	             SND_JACK_HEADPHONE, 0, &data->hp_jack);
>  	xonar_ds_handle_hp_jack(chip);

=2E..this really ought to be done as part of the commit that adds the
parameter since it breaks the build until this patch is applied.

--yeHj6vyFcpxC+65j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8sZGAAoJELSic+t+oim9vh4P/jlvew18ahVcBJTWRcPFq2Za
EtvX0IiAe9IDKAobeV+q4Vf68KJDZ9wTfkaq8QQJHu1gCAmoPK5WtVXOsIuuwGWx
NBIc4gF+0+i7AzsWWpu93qN47/1HC15PQoMQxsebR2jSAthaQ89E2yZovYVpPCqe
fbuJxsnuDzSjNiWfRGozz23/mNgkTsx5HmsVIkXluW5S4LNV1EqgKrv8m/Zh0NDv
lHnzWfYggfDh06XEeDXRmDmaoT0q99S/izpJ2I02lNjkCfkLt/gpzsIQsidzIXBK
S4AMWDIlflHHOiL7eBDFquUU2gGnONmrVY+8ViL5bNSQdm5kX8ESYQdUDlPfR6W4
F1dtIbeDtIayFkt1jsa571tTGyt2ztv1npgDOlxeA9nIdeiYvWz3TxBLjkMXj8V7
oBEDDmNQYsgWND8gmn7NK5TMFKEW4oUTU0Pj3fG28rqvTRGZf5yHLIh81lcjxiR3
hUAO/ka2hk8SG7jxFoiAx7aZoONlJWMOVNsSsWtP4CktAhNiFCM9QVLJqN7Mr31n
iXGUwAT76R7hYEXYpKJw6l/JGLjH4u5uHDPTRvURo+KBNdvxPFUXQ4oKaWidbGcQ
x2b/Xm2i9WPNPRLy14cr5Imc1gdAi3WnqAKksB4xVH4ux9Mw8p99LeBIEwrD5+3/
Fw5yQ55rAMyjqXKqNhug
=0QtY
-----END PGP SIGNATURE-----

--yeHj6vyFcpxC+65j--
