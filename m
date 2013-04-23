Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3DWLVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 07:21:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37982 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab3DWLVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 07:21:15 -0400
Date: Tue, 23 Apr 2013 14:20:41 +0300
From: Felipe Balbi <balbi@ti.com>
To: Florian Fainelli <florian@openwrt.org>
CC: <stern@rowland.harvard.edu>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <balbi@ti.com>
Subject: Re: [PATCH 1/5 v4] USB: regroup all depends on USB within an if USB
 block
Message-ID: <20130423112041.GA15177@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1365091048-16229-1-git-send-email-florian@openwrt.org>
 <1365510569-8110-1-git-send-email-florian@openwrt.org>
 <1365510569-8110-2-git-send-email-florian@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TMTfqzsZeEKgETVO"
Content-Disposition: inline
In-Reply-To: <1365510569-8110-2-git-send-email-florian@openwrt.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TMTfqzsZeEKgETVO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 09, 2013 at 02:29:25PM +0200, Florian Fainelli wrote:
> This patch removes the depends on USB from all config symbols in
> drivers/usb/host/Kconfig and replace that with an if USB / endif block
> as suggested by Alan Stern. Some source ... Kconfig lines have been
> shuffled around to permit a better regroupment of the Kconfig files
> depending on "config USB" item. No functionnal change is introduced.
>=20
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Florian Fainelli <florian@openwrt.org>

for drivers/usb/musb/:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--TMTfqzsZeEKgETVO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdm6JAAoJEIaOsuA1yqRELV4QAJcuiWFB+VuJMAU4ml3OBJWF
usYcq4DijbppPFEC4Yd9qM1goLhxZmTnDoIztEF4TOsIvcRX6VnJCpZrSMtL3lJM
W+dVUY8I2bVzxyY1uK8RPqGlWj/CTG0fB4sbaCaD9WxwbJ1eGcVuWdzVQIusHoJY
7DA8CZXrcU/2UE+krzXk/KvcKfqY0ZChMGYN1USYBprc42GiE4umdi763Jt+ud11
TereTbyfZcwxOTSCxjumDPrYdxFeJvSRLYml/t+turU8VPU5bcmqtQk8wxhoVZTK
NJ3MU881GFCNpKlV6uNdKdSzLZa5IPbfJ2/IRQ1Ce8OUanwH4w4Z3BEqVKEoidjZ
HBsIa9x4d8Slm6wCUQBE/+iRQVUJltmNePuJ3xxEIlfdeEZbQIJpGX/uuRFX3Uuv
h7ZRGuEgEq0jHwWY5B84FGyL3/tg2qD0tkMId28DNFTqc0PQTkAEC2QzlgpM5IIL
Ek8dc7DaF8WBBPotrxPXi2b77QmPLHKIR6NYiclKlTbTCpVnqQ7+wRU5nQ8ihTCc
hvtmkHOCG9LRGY6AOea6YKYIhWDqNabFM8L31XxmyaPi9eHcZ+bVnYg+mJEjIMXW
3sXwh1sZGZCZIvKqGUe1rPRkxpVXg6XY4MOZLgO4geDer1FsCgAAyAIsjvsCtCnC
0gVVMzzmhuxNjeDPBgIM
=mZXZ
-----END PGP SIGNATURE-----

--TMTfqzsZeEKgETVO--
