Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760462Ab3LIEE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 23:04:28 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60698 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760272Ab3LIEE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 23:04:26 -0500
Date: Sun, 8 Dec 2013 22:03:42 -0600
From: Felipe Balbi <balbi@ti.com>
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 31/39] USB: remove DEFINE_PCI_DEVICE_TABLE macro
Message-ID: <20131209040342.GA20608@saruman.home>
Reply-To: <balbi@ti.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
 <003401ceefb6$22c930e0$685b92a0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <003401ceefb6$22c930e0$685b92a0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 03, 2013 at 08:27:58AM +0900, Jingoo Han wrote:
> Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> is not preferred.
>=20
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

I wonder why I wasn't Cc:ed to this email considering it touches three
drivers I care about.

Greg, I have the original ones in my tree and I would really like to
avoid rebasing my 'next' branch. Do we keep it there or do you want to
avoid merging those commits ?

Jingoo, please keep maintainers in Cc next time, it's very tough to
filter emails you care about otherwise.

cheers

--=20
balbi

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSpUEeAAoJEIaOsuA1yqRETeoP/3k8gZ6Qe815ZQ0RJh1Wsy6+
ChzCgqrhW4AUcwxKdHmIT6a4A+LxTPyiJhwVODbjBx14JDT79goVbdQWijqSfoyC
qwsAlAnt6p5X83Vfx14RMGSlNHi3eVsquJod0oycdkhrHYTdvOP9t3yumHZIxDJL
KOdnkeGxH27iKfmW9enTe7xeWsHXhXginH0cJ0HdFuyypsByKudeDgWAiEitHFwm
T9uij0/ZfXVd9zyxlreAkmq0X9aNNsQH/+YDSsdyKFfcW5HRzlOuZ4ID/cXiwMIO
VXXkfdD/oTT4YwrLg0gHFNljtSXwVjiAtOYFnoyceNLJ7VEEBx/BmdRzjWma7AmN
zCBy5rVGNwkf6K19j8+BA2lkrJRCEzMJQi9N3qc2WiRnYo+bQFB8AunYmEn9wbFF
JRG1wPaTToW9Z0qLWkLPcxrugT4zjfhn+J29oCy/JxpLaP87dEasDCIaGMJWTa8k
rDGkdtYURHjOXl/4lbUW1mMtVbPpYaH/haj0bMI9Kev/FLfNo03vGRt5wjtwQaQ/
+HWdaEv+QnJ21vlhv9u9IJ04dYT2tImxM28q4Fqg7+gpuc4mFAjdKdO6gBVkQ3Es
tJvmIuk6s5+TWqrUPNToj/7qryjR/Oo3Kcf0k8V9uOD3iF8kyN+8Ha/d1AxTdJeQ
7MWRdkjOp6GfATKGpL0Q
=fxM+
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
