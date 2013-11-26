Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3KZM5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 07:57:49 -0500
Received: from sauhun.de ([89.238.76.85]:41377 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab3KZM5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 07:57:46 -0500
Date: Tue, 26 Nov 2013 13:57:40 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Florian Meier <florian.meier@koalo.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] I2C: BCM2835: Linking platform nodes to adapter nodes
Message-ID: <20131126125739.GG7427@katana>
References: <529303EE.4080606@koalo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MrRUTeZlqqNo1jQ9"
Content-Disposition: inline
In-Reply-To: <529303EE.4080606@koalo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MrRUTeZlqqNo1jQ9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2013 at 09:01:50AM +0100, Florian Meier wrote:
> In order to find I2C devices in the device tree, the platform nodes
> have to be known by the I2C core. This requires setting the
> dev.of_node parameter of the adapter.
>=20
> Signed-off-by: Florian Meier <florian.meier@koalo.de>

Malformed patch, please resend.


--MrRUTeZlqqNo1jQ9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlJrDAAoJEBQN5MwUoCm27HgP/3H47gv1ZS4LdqjwRyT2APY1
fpTQB0bvyJzexjMKFpWUoX7s+yNwnbTHe+Lo/gl9fpzytAD456DTPiYIfRAXYvck
dgFW8+M6B8rEGRVGebqt6heDeY/ca3j70wFOggggxl6sSpSA3ourCloXQizeGjOl
3ootYQ+g4nTa47xsqIjB6VjQnLJQxYmVtmgg7wzY0CaUlH7pal8hJNSOxgjd3nTN
OVveem54ZlPY7oovV7by77zo0qMicxWEOwBO7jzPUrzPbDEb+/J9+YivW0d90MLa
XnStoAPKv/uvH/HIu4oxVSy3M10VVjoVPD2u4zlJB7Csv1iA/MZB1NKZin1sWNs8
/iWqwtFbZiiY3J2TSD1N0bpWWPY3eUQ2kGxb1C8pYjueqwHKZSVdrvRLhjpZDyLo
Da0HHf/MYrjeN8ud+R3RnobUbuz40Z4T8ipFLxsG5liOXW2qCkqURPE0GqAmMVq0
ot3wVRaMp7DlLMCvAZv7sYL29y8Js+ckV6FzhMU+on2MuVTds8HhXN8zvVIhbi1M
Eq/I70eqoAo1xT3yJPcgFUi6mYmNYIiO7DuSCrMH9YeOXWWzKyw4UqqrAZIZGoqY
o1f0WjHP4NMLw8t69QHZXY3u7lDaV4lurCwznqb2Co+3e08IotJronDnzKcHkP5U
YHi2IS3V+hQLkiMlIB1a
=krvV
-----END PGP SIGNATURE-----

--MrRUTeZlqqNo1jQ9--
