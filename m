Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab3ATKRh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 05:17:37 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48966 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3ATKRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 05:17:35 -0500
X-Greylist: delayed 25972 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jan 2013 05:17:35 EST
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: balbi@ti.com
Subject: Re: [PATCH] usb: gadget: nokia: Add mass storage driver to g_nokia
Date: Sun, 20 Jan 2013 11:17:31 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-22-generic; KDE/4.9.4; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358650693-29971-1-git-send-email-pali.rohar@gmail.com> <20130120092537.GB16066@arwen.pp.htv.fi>
In-Reply-To: <20130120092537.GB16066@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2505631.jIWxR8gPyF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201301201117.32096@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2505631.jIWxR8gPyF
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 20 January 2013 10:25:37 Felipe Balbi wrote:
> On Sun, Jan 20, 2013 at 03:58:13AM +0100, Pali Roh=C3=A1r wrote:
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
>=20
> NAK for two reasons:
>=20
> a) the original Nokia kernel used a separate g_file_storage
> gadget to use Mass Storage mode, use that
>=20
> b) there is no commit log

Reason why add mass storage mode to g_nokia is to avoid switching=20
between g_{file,mass}_storage and g_nokia and to have one gadget=20
driver for Nokia N900. It is better to have usb network and mass=20
storage mode in one driver (and not to unload & load another).

I tested this patch with 3.8-rc3 kernel on Nokia N900 and usb=20
network with mass storage mode working without problems.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2505631.jIWxR8gPyF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlD7xDsACgkQi/DJPQPkQ1I0JACgnjIRGDSPG+6Hk9YxKHj02CI/
SYwAoLzRiAlUvwzSM5UZ7q+pg9zra4NX
=KHcF
-----END PGP SIGNATURE-----

--nextPart2505631.jIWxR8gPyF--
