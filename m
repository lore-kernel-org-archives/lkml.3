Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaKLPtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:49:50 -0500
Received: from sauhun.de ([89.238.76.85]:45352 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbaKLPts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:49:48 -0500
Date: Wed, 12 Nov 2014 16:51:01 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: ludovic.desroches@atmel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        khilman@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] i2c/at91: adopt pinctrl support
Message-ID: <20141112155101.GC4031@katana>
References: <1415584552-11390-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qbvjkv9qwOGw/5Fx"
Content-Disposition: inline
In-Reply-To: <1415584552-11390-1-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qbvjkv9qwOGw/5Fx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2014 at 09:55:52AM +0800, Wenyou Yang wrote:
> Amend the at91 i2c pin controller to optionally take a pin control
> handle and set the state of the pins to:
> - "default" on boot and resume.
> - "sleep" on suspend().
>=20
> This should make it possible to optimize energy usage for the pins
> both for the suspend/resume cycle
>=20
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

Applied to for-next, thanks!


--Qbvjkv9qwOGw/5Fx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUY4HkAAoJEBQN5MwUoCm2M4gP/0FC4eBZdi+9vyu+iDasENOe
Nt/sGnxFpuBHRA2JRvWruk29KmjBYmugT535ySzyzAavWzXoHLNT6hIWhs1vtFnV
1C4UVLgKFVOW2VviGJowj2Jiq+da5NO4WCA1J7vDHri0A/zHd1I+2nfUKSknUaye
XJcPb50811UXyn3w9pmwCGWmPgofcTfF9lfh2aMYBwkznhF6Mf8mRAzMsjxNx+uy
fBNzCzIIyd2zzppwmUD8VgUsTj7mS3SV3IgMRe6A1nRJtITmHgFyOt5rLAHASNZI
e03E8d46pAwCukNUGhplxNsiz32gLlskQDG4fgkQfQ37o09nVFGor3fbq+8fSWDw
hx4QN37PvdvtDe9oXK5y+SnHJq1lFVHjy8RBx2/ovI3xrs3YqdPxfrybjCSeH5z2
A7EwjLEovf56CmU6ywOwYdRm2LczsZ/oHBmaDCNC0/qnJw/qhBBYintFTGkMimMz
YebJJiP4N9/RnIVEnl6/CDnUaMJ1WpMzQbC+pBCH07ST3T2nhubDCaoyNXrl4pND
xcow7vuflDoALjhC5I+9M5aLc5HgbtWnorC7qsSeQEx2Swu11PzV7cVsBwX6WvN3
55SW92XFlVZ23a3jEyW0RmtUAnc3unVxWqVwPc8pHhYuGfCVjZXgJKcxrwfN+Wez
zFLUyoc4g0jPlPwDfRmL
=1clq
-----END PGP SIGNATURE-----

--Qbvjkv9qwOGw/5Fx--
