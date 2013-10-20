Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab3JTSBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 14:01:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37562 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442Ab3JTSBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 14:01:14 -0400
Message-ID: <1382282751.2794.105.camel@deadeye.wl.decadent.org.uk>
Subject: Re: fanotify: don't merge permission events
From: Ben Hutchings <ben@decadent.org.uk>
To: Mihai =?UTF-8?Q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
In-Reply-To: <20130924204113.4621d61a@mdontu-l>
References: <20130924204113.4621d61a@mdontu-l>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-TEQCDL5+Qk9PnUNhCFUN"
Date: Sun, 20 Oct 2013 16:25:56 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.8.5-2 
X-SA-Exim-Connect-IP: 82.132.212.222
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TEQCDL5+Qk9PnUNhCFUN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-09-24 at 20:41 +0300, Mihai Don=C8=9Bu wrote:
> Ben, Greg,
>=20
> Can you pull this[1] patch into your stable kernels (3.2, 3.4)? It
> fixes an unfortunate bug in fanotify where a multithreaded application
> can end up in an interruptible state, a situation which only a reboot
> can fix. Ultimately, I'm hoping that the fix ends up in Ubuntu's
> kernels (for which I have also created a request[2]).
>=20
> Thank you,
>=20
> [1] https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/=
commit/fs/notify/fanotify?id=3D03a1cec1f17ac1a6041996b3e40f96b5a2f90e1b
> [2] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1148084

Queued up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Tomorrow will be cancelled due to lack of interest.

--=-TEQCDL5+Qk9PnUNhCFUN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUmP1/+e/yOyVhhEJAQo2IxAAvmwGvVNTi/Uyk1rDfhIutGF6KU6ekJOO
evRaPK2U7bPJTfeOYOXWm8OPwLQd/4GcPE+zgFHgKjfV/tQWszV3ln/4GGmCoMH0
6ZzUTt5Ks6Wsy9k9JbUtcoviT5bxhWyHzeU/1eJiOisWNJZ+rCaSuFhgZqyq9vGV
baGetXvJQVuF4Yp5lqOD5SKOZseKGNN6dovrd0rQ24BuPzB+CwJF741stF9X/o8c
fZ4PDww0S9NIVEfeSiW/W8UNRico4Ngd9/MeYyGWuiaeNVjxaakT77Yji/Yqdngb
H0KQVQgz/a++XwmZv+g67QybUPHHmhK/bC8VZanQObcqwKQrjZiL2nA435cv9NHI
GsIJytEn94/hwcvMZJHsbJilOTSNM/gThltUMMIqTCEUg5PfGgiVpC1eOkLeF972
gqjJ50DQ50WqnLp+O9Mq+Zw1dtIC6XM7rjVRnlzDrWHgjTUFAYDIQ1OY6BZ6cobq
eNZvwuVVx6v6DF5ASqjICrmBRZgVyqmL3MthX6x9QUPArU5zOzijHqrqL9+kVFfN
qoODRfnMYluDNCJisASfyy+tm5b12zuGRcFIe1JiJWO5vwdEh6VTlvMLKJ9uE2q+
teGg5PDRufk78DIrzp0KVwZbFnusgURMZQWtoigacGhLKajnlMs6sTjLQ3X9CbCi
XwsXIqYZJT0=
=fskT
-----END PGP SIGNATURE-----

--=-TEQCDL5+Qk9PnUNhCFUN--
