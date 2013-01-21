Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab3AUQGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 11:06:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55556 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3AUQGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 11:06:06 -0500
Date: Mon, 21 Jan 2013 17:05:47 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/33] ARM: Convert to devm_ioremap_resource()
Message-ID: <20130121160547.GA10790@avionic-0098.adnet.avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-3-git-send-email-thierry.reding@avionic-design.de>
 <20130121155846.GN23505@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <20130121155846.GN23505@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:tYpGyPuOxsk7SYJIY5CEslz1lTUYurVwfNFqx/sHyav
 /oCgaZx98rvIMFGu88YbU0X/6igEx7jgS4w2deYhbMGoF7KyWO
 devvI7t4ZUsXbND8KCMvdbgDFBvNlHyH38VJcCCDfyKgmYYEup
 Gsn6QYrib1tBdoGYd6XNngHU8w4V11xOcX42ft3lJ3FycWAFij
 dH69s8BFVHz/BA/R4mMdIWRJRYCQ7dqAHcBThkC7Ul2KeB0j3E
 NDjqkUqYnLeLtK6glG1C7B50Y1srai1xC+MZwYwbTs4lBS43v5
 wooruYHZVvMDr76mHHjoeD8xmkUtCujhwipFAwmRwUpzwhaP+W
 YRJbM5T6+J8p8W7O4Wm6u0+1hoGkB9VySN826Wgw5luvV7jOhr
 oFl9z2HiWW7PiY2jX8u7+X5UEkt0YgX93Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 21, 2013 at 03:58:46PM +0000, Russell King - ARM Linux wrote:
> On Mon, Jan 21, 2013 at 11:08:55AM +0100, Thierry Reding wrote:
> > Convert all uses of devm_request_and_ioremap() to the newly introduced
> > devm_ioremap_resource() which provides more consistent error handling.
>=20
> Does this include the resource part of the handling too?

I'm not sure I understand your question. devm_ioremap_resource() does a
devm_request_mem_region() internally if that's what you were asking.

Thierry

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ/WdbAAoJEN0jrNd/PrOhL8EQAJBQNGDu2f4ZmqnUVj1/xVYC
d+2d+Mq6DZTe74qeLIWpylkMnBQAdXYItU3Krlp+t0zot+LsysEbnarD5GSpijNU
ARVAzUowaSiQ+jfMKC2SFTYtZykz5xp1u1PKmxrcf98IJT6XbwYWEWXOsHE17Ny2
dSh/cnIJKv1Oh4pC7RrpiBYvfWJFgxgxCjYFxYhGviN0ozH+sgKyNeO0B92iEdna
f1xrNR9rHywUlORWWUgqVSKjZ4W8Zb9aE4smlpLzPUTf6NIYqneMGOMHmXlrUH6H
LHFpLDpaN0epstWYzgXYkJdNm/j3xlVCztNuwX13qqSRS7XZpOjZ0U/hvb+lK4Br
ifZXkAyL4FK/U60XEzKkReWIzbVICFdoDgRj/DQa1gUgS340Eu/2+Xm+/FqP0HNQ
DrYuffcCdsV+R73NdbCMD3fufj1urOeG1gydjfDS4kg4pasbO4SOZm6SLSUqipRu
DRt/g7uzCErWTfmZSM3AffrjtglhuY9irhrAdkfa9r0VeCodkAsBWKn7fAbm7u5N
2UivC4fxZma0ccH+AvMtbfDpE2SidEH1Pv7HUub0cZ/CJE4oUEL8fxUf+Ur3SI9H
XJaz1uLloS8TVgrv7ArQazZeCcUcqdXiPLY3kfpsbSYf52OknQW9B3m4Kcqo9VKk
2w4GDspT/5R3+LG3d+Cl
=a2NW
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
