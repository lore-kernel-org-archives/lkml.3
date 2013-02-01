Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab3BARO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 12:14:59 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:63303 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673Ab3BARO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 12:14:57 -0500
Date: Fri, 1 Feb 2013 11:14:53 -0600
From: William Hubbs <w.d.hubbs@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, mpagano@gentoo.org
Subject: Re: [PATCH] init: fix name of root device in /proc/mounts
Message-ID: <20130201171453.GA1630@linux1>
References: <1359672699-23540-1-git-send-email-w.d.hubbs@gmail.com>
 <510AFCA1.5000700@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <510AFCA1.5000700@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2013 at 03:22:09PM -0800, H. Peter Anvin wrote:
> On 01/31/2013 02:51 PM, William Hubbs wrote:
> > On a system that does not use an initramfs, /dev/root was always
> > listed in /proc/mounts. This breaks software which scans /proc/mounts to
> > determine which file systems are mounted since /dev/root is not a valid
> > device name.
> >=20
> > This changes that processing so that "/dev/root" is only added to
> > /proc/mounts if a root device is not specified with the root=3D option =
on
> > the kernel command line.
> >=20
> > Signed-off-by: William Hubbs <w.d.hubbs@gmail.com>
>=20
> Let me also point out that most of the time, the kernel actually has a
> udev device name for an actual device...

I'm not sure what you mean. If you mean /dev/root is not an actual
device and should not be listed in /proc/mounts, that is correct and
that is why I am proposing this patch.

William


--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEL+A0ACgkQblQW9DDEZTjAjwCdEWcWd3+Zn71ZGbLl3IROzdKV
YJUAnjcSfZ84NlEzo+CAz7cTywXqGZQQ
=MTaN
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
