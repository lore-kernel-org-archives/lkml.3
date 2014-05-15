Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbaEOJPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:15:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53687 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752537AbaEOJPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:15:04 -0400
Date: Thu, 15 May 2014 11:11:23 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Arnd Bergmann <arnd@arndb.de>, wim@iguana.be, dbaryshkov@gmail.com,
        dwmw2@infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog
 driver
Message-ID: <20140515091123.GQ29258@lukather>
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com>
 <1399430664-29091-2-git-send-email-maxime.ripard@free-electrons.com>
 <20140507213318.GA2105@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VdnGiXwuH6t1Tqzo"
Content-Disposition: inline
In-Reply-To: <20140507213318.GA2105@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VdnGiXwuH6t1Tqzo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2014 at 02:33:18PM -0700, Guenter Roeck wrote:
> On Tue, May 06, 2014 at 09:44:19PM -0500, Maxime Ripard wrote:
> > Most of the watchdog code is duplicated between the machine restart cod=
e and
> > the watchdog driver. Add the restart hook to the watchdog driver, to be=
 able to
> > remove it from the machine code eventually.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
>=20
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Wim, do you have any comment on this one?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--VdnGiXwuH6t1Tqzo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTdIS7AAoJEBx+YmzsjxAgWgwQAJHysjX3WsE2v0U3SshRop8m
U56t7pfLcYZutHMxSwUD4tZ45AX7X3pCOpOXhexLke/+uJ9wUalhL4EcaiOCfiGs
BsAIDcvmJVUlxTLnkbTnLxfXV+pjbNjcdUp7rzZBjQJHGjU5z5HKx6Mbr8cUjmnA
BVmaKNV2RUz23NnQ8HU8ew98heO+dHAMXlkMk/D1gTClNvecrhgrtyPFoCc3ITG3
rYIH92sZlzwyR76X3gEY7Cp3E/WmCufGDOwBdWVKXdfiSNtJrvkbrHDL4gS1aCRi
l9jzG5y6fjZbiD3eaT+N3otSpj1cxc31wLqjga9RG7sG5Hd4c/2SS4EUm/9UuYhL
HV05TraHpDb1kpsYshcS6Vj/D+z9lZPOOw1jeSlXjP6G95NbrL/Iou+sWjuxec2x
tjfcXlwDfuOMvFM4+eQc+lh1b/3ZOLGDm4UiQaimkN/4fYzKHUlBh/GYUUndAWcj
KtOGoY8RZQBQpc8eBFhSLEOLzI+3JRrL38/Noy8uOhK/+++0Sz80zQtmUt9eKS1A
E/DyAwdshbgYoxBG2lsAPiVJKjvZQzcGcbnzXhxSs1/L/UrPqh+uLJ7EUoJ1S2jR
usxIZuFLetX/2UDBGK6g/41Ed+L2mxksCRSnEIhMwbqeH6L1waPtoslSc41JRBEL
ScDRLVDBj6RZ6yHWrIZ4
=dknw
-----END PGP SIGNATURE-----

--VdnGiXwuH6t1Tqzo--
