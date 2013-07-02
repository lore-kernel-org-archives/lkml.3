Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3GBPdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:33:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45922 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab3GBPdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:33:00 -0400
Date: Tue, 2 Jul 2013 18:32:29 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 5/9] wlcore: always use one-shot IRQ
Message-ID: <20130702153229.GG7013@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
 <1372776948-24840-6-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KIzF6Cje4W/osXrF"
Content-Disposition: inline
In-Reply-To: <1372776948-24840-6-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KIzF6Cje4W/osXrF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 02, 2013 at 05:55:44PM +0300, Luciano Coelho wrote:
> Since we are now using threaded IRQs without the primary handler, we
> need to set IRQF_ONESHOT, otherwise our request will fail.
>=20
> Signed-off-by: Luciano Coelho <coelho@ti.com>

good to see this happening, I remember we talked about this a while back
:-)

Acked-by: Felipe Balbi <balbi@ti.com>

Still, if you call irq_set_irq_type() on board-file (since DT will do
something similar for you anyway) then you can completely drop
irq_flags.

--=20
balbi

--KIzF6Cje4W/osXrF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR0vKNAAoJEIaOsuA1yqREmRsP/jO/ZAuUxhzbh2M71eQy9fQJ
Lt82NfhFv+D+lZYtWPoDlbU4mOGWMPiK1YRNLiN1GLo4MKfLbRbRGIzOaJnedsMw
Wt02ejUWZhGe5REI5ocK8jOlyQUDbqv2s3dTAmRR1CryYQWerk3n9CFcJC9gxn+w
RZ5PQBmdCKanyEX7CH2oUFZyALofTLm2N9UWwlWPbllY7zZQvn1eQqVEdsW1zzBP
/tFzCTSclYWK1UmA5K0f3UWfKXo8EHppA9PocCvQduQnzgWy803E8OTrimRG9y3C
6HT/9iW5eJXs+J5lOIPkk72o0/3Wb+k3rdrPCnhbvz0nptsMsHkN2MIN/9TbEYx/
DjjW/pVTQ2ebCf8q0J5N7XueDGyTK6zb6OmQzPwAll3bsQwQMAmVAtObK5b4yujw
DJfxqcqyY22P28qpddnvQqo95UAZlmYe69sRhL+H/FtA3UxhHBz5Be+H0fF7xsQd
GZpxKN6tDhvEJ8EBSyQhC8UxrFpTWXK+INGXTxKwmGNMtMoWxdeUnXJT4kIPKEXQ
uxgRK2T2OpTxP4PzvKdbCUhyFOioCLkXHNWuCRrUmPiB8v1I+5o5TI0FFA1ALBqc
RpGiAwmESavLYYRz2qFqTs4iNQbLQEiXByGu5CGt5SU+WcFaZXo9Al0umWLT758B
5sMG+JR26qBIqjRSTpJg
=H+Sx
-----END PGP SIGNATURE-----

--KIzF6Cje4W/osXrF--
