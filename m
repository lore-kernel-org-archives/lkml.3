Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab3ATJZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 04:25:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40007 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3ATJZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 04:25:44 -0500
Date: Sun, 20 Jan 2013 11:25:37 +0200
From: Felipe Balbi <balbi@ti.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: nokia: Add mass storage driver to g_nokia
Message-ID: <20130120092537.GB16066@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358650693-29971-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
In-Reply-To: <1358650693-29971-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 20, 2013 at 03:58:13AM +0100, Pali Roh=E1r wrote:
> Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>

NAK for two reasons:

a) the original Nokia kernel used a separate g_file_storage gadget to
	use Mass Storage mode, use that

b) there is no commit log

--=20
balbi

--R3G7APHDIzY6R/pk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+7gRAAoJEIaOsuA1yqRECR0QAKb5ZJm4lvsL3sWq8HjYS4mG
+KWDzJXnM26TO88iAi0kKEcOthiKjnlshdkBLLYduOsZN6DnNWnR10oxWZqktRPk
mFrQFjut6DSm0DeTGFkaCN//FfRSwZgjGYTDkNGCwJEMXSSugHZVcjME+tb6cgkQ
RuF/0uRmEvs6NuLy8vwullTFd9edDQ+NVD2VGA7ICUxwPxHV37yVIu92qq93CXgl
Hcra3EPjoHBn7d25yrF2jYhtANHW0Y0lkf+pIAyaUytqqjtguUTaqCgki6ZYa7xE
ev7QK6A6y/BWzRp1IAL8nE0DjmDbjy8h+YfgLv4DP25xHM0O+rP0FZzUmwPh81nl
tpjXQRdcS6kedqt/VQ+jSjTAFUoiyYtU9Ar8PN3BrXkDeB0AbPFZ5pS7MGDQza5x
f85NVmeSrn0UV1JoSSUAD+Y1wMdKqc62NFULYOHC+4efvU8XBvqb9ApsmKLj5GXD
pGcKiKM7wicoTwX9RQha8xTCMrmxvrMgTC8Pe7r0ziRoLvT6zUr5o46OyoyqN2IN
nWo8ak8mMB+JeA0peDUny4SOpCkt6jyXbJI2adVP5pDad1xvGDv1htoTcToA9YJm
07HGspQ2+fVcL7zI+H/ZmLPlDrhH962IeYSGjmrrfNAjxBGdLCvH5Sb+6kzcYhI/
Lkjirhtz0X23weh1Fp3A
=Tv62
-----END PGP SIGNATURE-----

--R3G7APHDIzY6R/pk--
