Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaCCSIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:08:01 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42579 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbaCCSH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:07:57 -0500
Date: Mon, 3 Mar 2014 12:06:14 -0600
From: Felipe Balbi <balbi@ti.com>
To: Jaehoon Chung <jh80.chung@samsung.com>
CC: Felipe Balbi <balbi@ti.com>, <chris@printf.net>, <tgih.jun@samsung.com>,
        <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: host: dw: fix possible build error
Message-ID: <20140303180614.GA31301@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393340264-22687-1-git-send-email-balbi@ti.com>
 <530D134F.5090403@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <530D134F.5090403@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Feb 26, 2014 at 07:03:59AM +0900, Jaehoon Chung wrote:
> Hi, Felipe.
>=20
> When you send the patch related with dw_mmc controller, could you use
> the prefix "mmc: dw_mmc:"?  "mmc: dw_mmc: fix possible build error"

sure, no problem. Do I *really* need to resend though ? It's already
-rc5 and I still don't see this patch merged.

cheers

--=20
balbi

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTFMSWAAoJEIaOsuA1yqREw7cQAIO112vGsJd320iYCgRw1JGg
B5v4sqH2qxWhh8o401xPKsycLbKV8HjXcL4nDImGD8doyV6IA+GFh+RRe6NyQLtn
67oT2sSQV1r4XcyPV9V5pp3cmlH3s4wHTRI8uCTHWqJ5KJlfUu1b8GUotK2jM0b7
lgvXWcW6+bncI0n/gBRwrh/3v6SDoWGIud0hO/oKpshCKIhU17W1gA0zltXsKN2a
f7tvTrzjFF72d5zhTsTrpls5wUYlY94gk3xlRycbKw0X3/famK85eta5okqUnO64
QtJipfxxlBCkZHDzj4wFD0Qui4HD46J5jghrin2eoyZkDq7AjUcFWKrq1u1qh0eh
6EGFwOcBQPo8YNmFb1Zqx1E1PyH4Rmjs3pSYDnWUoi7Qf7fOxgLMSTFHuQGgenqg
4mQiMC53pxlvTJAefvnVONzqwRpw7Ta1QPE5aQpKO90Z12gcSHqH9K15dyFBJZAg
VJQNEIKB5/OiLKbEdN1mNTvBEXvL2me1bkVduw5Ykj+W5JC25zDFcimZplyXC755
m/7m3+z945jkhyHEdqv2RqLCNME7KIw8ba6VX06hukv5Na915IaURJLQkNi4rs84
WDPnbB4cNTk34q0rVlXowW1wUYjY3AmeJ9m0ULalC/unSICdhZTdF5xKpcNSQQsd
q5f8D9BjTX6QPpLBclE5
=pPzK
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
