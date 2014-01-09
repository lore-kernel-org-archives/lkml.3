Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaAIMGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:06:13 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43564 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbaAIMGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:06:05 -0500
Message-ID: <52CE90A2.1030705@ti.com>
Date: Thu, 9 Jan 2014 14:05:54 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH] video: Replace local macro with PCI standard macro
References: <1386242718-24372-1-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1386242718-24372-1-git-send-email-wangyijing@huawei.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="9buUbBoCl8M4oaE3IVr35akXABkuAaqDh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9buUbBoCl8M4oaE3IVr35akXABkuAaqDh
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-12-05 13:25, Yijing Wang wrote:
> Replace local macro TGA_BUS_PCI with PCI standard
> marco dev_is_pci().
>=20
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/video/tgafb.c |   16 +++++-----------
>  1 files changed, 5 insertions(+), 11 deletions(-)

Thanks, queued for 3.14.

 Tomi



--9buUbBoCl8M4oaE3IVr35akXABkuAaqDh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSzpCiAAoJEPo9qoy8lh71wQEQAJY4WqEr46216E8rKRCUDnsM
tIUPWPDbno6AjGfY4J2H1VeVc8BhcJ/i/dJkLgoG1LTzyB0b9+Db9+RXC13u4SWb
heXyfJd32BDIpbZGwezmvZckr6BnU3WFwTz+gXp9QQy+PvjijSqI8OrHThTqoPkH
IiEekIi+9WwlxHdeNmlHicxaIU1UUIVlpAdRx/q66bfCiomCY796NWJUM1i5wlzH
klR/rHGk/0cJ4l+prfLukMaX2B9wq3BzD+lEcD1uQs9CunOckA7kQpFTXfCbGG0A
/s+/ULiLQjX2payAIxJGCkv78MW8YBW6VHpUl7Yyy9HI1MsfzUWhhws1dF/o8gE9
u/E9VmcQwa5fRhz5b5gTlI+eDEvWJkRfRWFLzx7gJVpXQhrnmmiTveEv+oAdtmYn
od/CgxynpNZAc39LKjdd5f/Ly5lqqHIx+zMh7nKLe08vX/hlRzlSAU0ZTxq0RlyY
PVju8mXM9jOaiPvejAmM5t9VkiOdBu9p2zGPP4tg7CjKjGG5eZTzrT4vYSk0kQ4L
9LWjnUBbOxtv0/3ob79Bgtbg5eTrR7hv2FlhltDRLKbe7apCGkF19vWOPCg+Yb4t
p0F1pLFNUGL8Cu35E1YkX3R7lzgdhPyhsTuyF3t6O/pX+iZTKMbCvBCnslpTJiA/
/Y0/ln0zl28ARrtD9eby
=b5fc
-----END PGP SIGNATURE-----

--9buUbBoCl8M4oaE3IVr35akXABkuAaqDh--
