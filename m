Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab3K1IuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:50:25 -0500
Received: from sauhun.de ([89.238.76.85]:47759 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab3K1IuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:50:22 -0500
Date: Thu, 28 Nov 2013 09:50:17 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Florian Meier <florian.meier@koalo.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] I2C: BCM2835: Linking platform nodes to adapter nodes
Message-ID: <20131128085017.GC2626@katana>
References: <529303EE.4080606@koalo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2JFBq9zoW8cOFH7v"
Content-Disposition: inline
In-Reply-To: <529303EE.4080606@koalo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2JFBq9zoW8cOFH7v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2013 at 09:01:50AM +0100, Florian Meier wrote:
> In order to find I2C devices in the device tree, the platform nodes
> have to be known by the I2C core. This requires setting the
> dev.of_node parameter of the adapter.
>=20
> Signed-off-by: Florian Meier <florian.meier@koalo.de>

Fixed up for you and applied to for-current. But PLEASE fix your mailer!


--2JFBq9zoW8cOFH7v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlwPJAAoJEBQN5MwUoCm2J8QQAKCyUzykyZEV58gQoFIClmjH
dKB/IUlSwijhEwyC2uMi/a+M0/HgeM1/vgmkfzYBLtHQXz11MBx/PVBBHbHekH/U
IUYbvRZzKRqEJBqHmC6Dsh8cTtEn3ZhyAIWaiLuK0sDCJnZqUm+JeHWQ+622yi9E
uu8/AM6wLtge9xhH3Ri5ZNW8QrjF4UoWt14uyUdRFG2FoQZ1j7vI82gSobJJIXDy
EjVhq/iTNhQKRTN5MXkL9sjCxa1BjeRCbGQXGYZm8PqfRXCjzO/pKNnkX3+fFlzi
hW3lSZbs4ptoQ/nOH3PFIRU72mvaR/Lbz45bA0OvXLX8/l4f/FJQIwLSL60E720h
sEi2a8eisjL8XwyzzKtX3OlKHQ9nGMhHLQsk5ggJswSGGcPutzPQrgDzapx2bjIz
bbU65jTn+oJQlDl6eU9M3fpCbZatpY3i1JUJb9T9TRsNQ1/L8yKjwi/OwyNRBv7d
oxepaAZYqAMUSTX9OmnTYS2F43DL2dvViGeXgXw2ZAPHYret21tJFYtNdzyrcoNN
HbbWa0fw8hNwi85QjBAfcxFvimaDEhq75TQj9GJ0UKMZ+9oI+HeCpus1TUbiQLzI
EP4j3BU2VzBRk9IL9M2ZZZKOJz1+gKb9HIxy2HRcRj6M0ndnrki7eURIdRIiiEyk
OufzY8PvkfETw2bOLJZg
=yD/A
-----END PGP SIGNATURE-----

--2JFBq9zoW8cOFH7v--
