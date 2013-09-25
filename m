Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab3IYUDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:03:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39870 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754509Ab3IYUDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:03:53 -0400
Date: Wed, 25 Sep 2013 23:03:51 +0300
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/26] clk: sunxi: declare OF clock provider
Message-ID: <20130925200351.GL2954@lukather>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1379526839-14798-7-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2VXyA7JGja7B50zs"
Content-Disposition: inline
In-Reply-To: <1379526839-14798-7-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2VXyA7JGja7B50zs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sebastian,

On Wed, Sep 18, 2013 at 07:53:39PM +0200, Sebastian Hesselbarth wrote:
> Common clock framework allows to register clock providers to get called
> on of_clk_init() by using CLK_OF_DECLARE. This converts sunxi clock
> providers to make use of it and get rid of the mach specific clk init
> call. As sunxi has a bunch of independent clk provider nodes, we hook
> current clock init to board compatible to make it called once.
>=20
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--2VXyA7JGja7B50zs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQ0GnAAoJEBx+YmzsjxAgXLwP/25Afay0RrwGR0pIT1Sh5cIs
a5g2o8rcdHNpcqA9te44OR7Ex9L+oObkiwR0wsTH7wYQUI61TDcqblE1lAVyKLur
KPqxZ6emLEXHM4HPhTh6RYuql/Mp4R5wefGsnEGQlI4q98AIT0SfM6dkHONf/8H9
C1FDSxriY9z0VrRLHPobz/hnKDscQwD4jEKP4TtpoczAXNW/cVkxaMzxXwpykNTs
ANeTCBUn/Rx0FfYtLYew3GicE5KZ+UTjIKABqVMr5a4s1+dv4rcl0iihmA71KiAX
xH/0CXUHt4BrTMiB4nCv9DmvQNnbtb7LA3wIMRCvpHwtSy50lf5N2fSZqi0S5cH2
QMThoVuAQeKeTbCRpvVfXCbgwbSjUoXwY7h1/4wngrUk35sRL0vppuEdLon7QMDM
x1mwE55kUhBR5Kro1TnQzFb0RnRQzXz9erDIEK2e9MJsbJ/ZSzUUJqVYXasygjrw
EyDclOJRVvLIa4BovlcbrJC8wqssvzp+xj2+lrzRQq0CZjEyeLlgwJYySuON2tUu
RQ91gTVaq+5znc4rwxR1AH2IgWZ80PqGt4MhZ6XvhqeTU3PZ8eqOwTywo+QUysik
uXlvNUj1UOxwwANbuWL4marOMQw3qNjLILMUvOS0l1BJ1L54F1YcmLbX1PD72LaE
EcZNXxUksMwLumTOctnW
=e2Ff
-----END PGP SIGNATURE-----

--2VXyA7JGja7B50zs--
