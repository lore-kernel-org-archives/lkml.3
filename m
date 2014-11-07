Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaKGSDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:03:53 -0500
Received: from sauhun.de ([89.238.76.85]:55883 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbaKGSDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:03:52 -0500
Date: Fri, 7 Nov 2014 19:05:03 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH 1/3] of/irq: Export of_irq_get()
Message-ID: <20141107180502.GH3656@katana>
References: <1414677578-27412-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1414677578-27412-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/zg8ciPNcraoWb6"
Content-Disposition: inline
In-Reply-To: <1414677578-27412-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/zg8ciPNcraoWb6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 03:59:36PM +0200, Laurent Pinchart wrote:
> The function will be used by the I2C core which can be compiled as a
> module.
>=20
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.co=
m>

Applied to for-next, thanks!


--J/zg8ciPNcraoWb6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUXQnOAAoJEBQN5MwUoCm23Y0P/RzqzJmoK3btoWBHH4CO8sY3
DOiBU2hhNWg1Y2HG8Tq96ECDAC95rgjhvermcAPXXk3UnSDTswrFsbPedrYb5aOE
pcogELBhTChZOypcIFLHRAk4mbJP5JkH/uUdvNZBuwcMP+sigKIzoxvbFVlWUsMJ
rzIcxaYhLXxo1WOGXTVANjnf46ndQuCzIsNhrBytGXDFaSkziGtUtkIy273MbZmq
7z1or5LpqyKzqlh3GSHjOPihdrxMsklX7KCKXuAq8u28AvpcH2UJ/DuKbfhoW+u7
kdaiXlVZ1yLVNyVg7nDur4QcSd25ZliWtQGj1VHAW0WOODA+7Wmx6xNrV3v86qf2
Fz5kmR9YUPUm4r37HFIy/s4CMWlYF9oj/fOgmE//7VjYfyQuGeiKEhjahDmkiYyq
8U2+3CbeSMVxUJW+nM1dWqWjWWFMFbg/2H1TcCb3ktDQix4tCZvaEVDD9XljPZvb
YJnI6DaX0gm/GbP4WinCMnQa5n4y23+3uTY81rSkAr+ane0jEnOh0Tmk3fZkZwEu
HXCNYGLHYrhIsRcWEWYIlckT/H5oiYNm9jYKUtwqEZrG+WBegLtEINsIf1eulh1C
pgo9+aze3rbEf8EfWR+ZuzXs4bqW5xVdWn56KgSG7ZNTwIBoVYP1UHWVP+LxbNq5
vwu/jd9eHsFHT2XgXDzx
=1UQc
-----END PGP SIGNATURE-----

--J/zg8ciPNcraoWb6--
