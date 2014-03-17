Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbaCQQTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 12:19:36 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54758 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844AbaCQQTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 12:19:34 -0400
Date: Mon, 17 Mar 2014 16:19:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Jyri Sarha <jsarha@ti.com>
Cc: Jean-Francois Moine <moinejf@free.fr>, Xiubo Li <Li.Xiubo@freescale.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Message-ID: <20140317161916.GL11706@sirena.org.uk>
References: <cover.1394533640.git.moinejf@free.fr>
 <d71a2b62b331302772d35b3cd35c6dc5da1e9e5d.1394533640.git.moinejf@free.fr>
 <5322E4FC.7060605@ti.com>
 <20140314194037.7da888cd@armhf>
 <cbc30d6fcafead46267347269cbabfb7@kapsi.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qo7zVO9a9OQ5oQtr"
Content-Disposition: inline
In-Reply-To: <cbc30d6fcafead46267347269cbabfb7@kapsi.fi>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v2 3/4] ASoC: simple-card: accept many DAI
 links
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qo7zVO9a9OQ5oQtr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 15, 2014 at 11:14:13AM +0200, Jyri Sarha wrote:
> On 2014-03-14 20:40, Jean-Francois Moine wrote:

> >So, the actual solution I use is 3 DAI links (= 3 PCMs):
> >- HDMI via I2S
> >- HDMI via S/PDIF (no S/PDIF output)
> >- S/PDIF via S/PDIF (no HDMI output)

> Maybe a HW specific machine-driver would serve your case better. Of course
> it would be great to have a generic implementation that can handle this case
> too, but I am not sure if it should be called a simple-card anymore :).

I am a bit concerned about that I have to say.

> >>You need to update the DT-binding document too when you are changing the
> >>binding. That way it would also be easier to follow what you are trying
> >>to accomplish here.

> >Some people want to have 2 different patchs: one for the code and the
> >other one for the DT change. Some other people like you want only one
> >patch. Which is the right way?

> I did not mean it should be in the same patch. Part of the same series is
> fine with me. It is up to maintainer to decide these things anyway. I would
> just like to compare the document with the implementation.

If the binding is being changed in the code the documentation absolutely
must be updated as part of the same patch series if it's not already
been changed previously.  You can have documentation without code but
not code without documentation.

--qo7zVO9a9OQ5oQtr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTJyCBAAoJELSic+t+oim94SgP/3tG55DrJ+yCCxM06NeXkpCq
UmLoYKzwdLEeH26Pfb8Q4X/ddn9A30uWeKWThSKsXt5LKWRFAu+sea+VzMqKd8Ey
r4EOYXnrVStMhkJEhVpkb+xIfGuxwtJEMhbVraWpqus3kBXrZr8RocU4914GiE5j
fu9GZlmTbySlsxbqusywSgdOVqtnZNsuVO85xSeovXLyZsv1I6mrdv9e8XwlrD8u
2K7/hgbmxLAsw9hw+dVmbtMehusL/bx7ms2av971+nBSfadTgqu+suS7Km7r0UOd
b1d6EVWUOJYVhoLtjKk3UtqWpOTsZ7bWW6jXGM9ZLhBUhwTumh9sodQGNGUdalu2
eqpU9lBdwcK4GWvjf3f1S9xlwwGB8WrSNXHOSsHug4tg58CJMHgawO14GedUeOSm
UxsLtLarpFCzHFMCIsux/kLwKbafaLF1gURJO1F5C5EYGCA+nOjgITwr0Ih13TZ9
wcToJGs3xMJVH6wUVCym9+YZftYO8CEsWS3gDKGLpQ9utzESIYiKO+LRev2yTTnU
vYOHdd/4b/672iZSsNBIectxoFSo67JrYGtN8184jFCuEJTMYnuPbPrRzzFILP4P
rOuBOqP/ic/tACYKjG+QlX0b6rCeVkRn2oNjKtehHBipIFmvnQ9wzJFNkTseFGQl
sI/Gir9VO271fk7EarRK
=NakR
-----END PGP SIGNATURE-----

--qo7zVO9a9OQ5oQtr--
