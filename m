Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab3G2MZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:25:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56039 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab3G2MZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:25:34 -0400
Date: Mon, 29 Jul 2013 15:25:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] usb: phy: msm: Migrate to Managed Device Resource
 allocation
Message-ID: <20130729122522.GI24801@radagast>
Reply-To: <balbi@ti.com>
References: <1375081464-14206-1-git-send-email-iivanov@mm-sol.com>
 <1375081464-14206-4-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vs0rQTeTompTJjtd"
Content-Disposition: inline
In-Reply-To: <1375081464-14206-4-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vs0rQTeTompTJjtd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 29, 2013 at 10:04:21AM +0300, Ivan T. Ivanov wrote:
>  	motg->irq =3D platform_get_irq(pdev, 0);
> -	if (!motg->irq) {
> +	if (motg->irq < 0) {

looks like this particular hunk isn't part of $subject.

--=20
balbi

--vs0rQTeTompTJjtd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR9l8yAAoJEIaOsuA1yqRExbwP/3oPHRbZqZqQDty/Z/HNkIk2
4ym1XzRuFXEiSMBHKkucwh9l7nLf3VwTcy33fdrOA1HFZmg13JadUYjpTgCKaSVL
cHXnYDmiF1Jmc5Ykc2BXFqJg1AjKhu6uLodRPMBEO4xaic4T7L8qUv50mIohdcxC
82/HNCSM1mZlDdP6R74UdXFMZ+JQZoozy/8f/mbOum0Lhb1E3o91jsL3V4h39/hC
mUaFewWjjmS8YCLq4fVdEl3o+NU13FU9JyLk+L7qGebUYy96HcX4c/9V+6pvEmjO
v9BPF0LzYb1PhNRZn2BhFhZym17SAG1ZSlC1EbeAdvrKH996BzGvWiqpDlwrMv0O
ra+cTjHcZqCFWsI5VAlmH/JTqJ/0XjSRvfh1Z4kbLdQWn4DcntbE8NmO/moqyiIg
OuqGqHonwGaHfI2GAZ+zy6uagQ/YS5LXimzJ90c7lFOsupgIwHi4fj6ISBF3ktAq
e9+0vIhpFku99KTRqWOlFEQXyOog85VGqmexnHyBUA/lUSI0wXVoi36/7mEvuE+k
w1GcDhPWyfBnWJUCbTSLs2XgMkHWGxjflfnXe2FZfxQSufNW0JPWuu0EGlkvUnW7
RYXJRPD9++T8oGdrwbyjQjmquwn3NTpo4EY0XBwJWcTaZR5P5+w2UirQqk1pxMrB
T10QoPav/7ftkLVApHVh
=oJhB
-----END PGP SIGNATURE-----

--vs0rQTeTompTJjtd--
