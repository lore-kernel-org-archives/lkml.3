Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaKJP01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:26:27 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52207 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbaKJP0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:26:25 -0500
Date: Mon, 10 Nov 2014 09:26:45 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Todd Poynor <toddpoynor@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>,
        Benoit Goby <benoit@android.com>
Subject: Re: [RFC v5] usb: phy: Hold wakeupsource when USB is enumerated in
 peripheral mode
Message-ID: <20141110152645.GF20766@saruman>
Reply-To: <balbi@ti.com>
References: <1415095254-24683-1-git-send-email-kiran.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rMWmSaSbD7nr+du9"
Content-Disposition: inline
In-Reply-To: <1415095254-24683-1-git-send-email-kiran.kumar@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rMWmSaSbD7nr+du9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 04, 2014 at 03:30:54PM +0530, Kiran Kumar Raparthy wrote:
> @@ -1469,6 +1484,7 @@ static int ab8500_usb_probe(struct platform_device =
*pdev)
> =20
>  	abx500_usb_link_status_update(ab);
> =20
> +	usb_phy_wsource_init(&ab->phy);

instead of adding this to all drivers, you can just it to
usb_add_phy_dev() and conversely, to usb_remove_phy().

--=20
balbi

--rMWmSaSbD7nr+du9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUYNk1AAoJEIaOsuA1yqREPC4P/ig8HerTLB9qXu8B45rGSmiU
Cg0Rx3qXU4nGro4qIXekxK+b5vJxZfZZ2D8PmCu3S3Zi2YWmwCJCtGvoV4roarYe
MLgQqtQKrXunH2eW0dlU2NYGHcY88MuaYs5vXpayrrqRMVb6YmXfsOzx2F9ysvzk
L0TC+HlcjLbHOxmttLvF6OZCf9I7/4iM/bxaCDpdndfk4qem6cILEHXsUE/TQCoQ
wo5tnRnSdSiZ8AQLPvLsEG8bHEX2xDDewcao7pdyIbPeHqhmdUMQTSVCRaA9Nt8Z
VfwNmLn+gC5ZFkce6wzRp+8DI5qRVleNoOo5jhgj0HoqX5WIwp3MPHKXT20Daaq6
kNVV8FZfQVkLm+365dEhRi9gRfLQXyZE4KqxM0ZgELHZGAwZlVJ60kkmBBkBbMrp
BmrKn3KPwfnslfQmn4I4BiBb59yR+nbOmu4TXodqEz//Ew3s9O5vzfN+exOyugmV
jtSxTWt2lVGHuxqMfAn7J03AOyc7nD75SeDLbeaXTmjd7rQrYUfVePfiUjrqLIVD
mFRAJZFZDU+ol+g/PnEAv1uaE4te/k+Y1KQUuOHsLCHLmp4UnfkmbLp1DyI2s6cS
6ik78lLTFt5z9MqNwRGv/YPBH/DRqMbKi1FAZLilpC21w6mRdwRHSacs0c5/zEJg
rHMuBufCcvFSZPUTP7vb
=+mvK
-----END PGP SIGNATURE-----

--rMWmSaSbD7nr+du9--
