Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab3IES4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 14:56:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60699 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650Ab3IES4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 14:56:51 -0400
Date: Thu, 5 Sep 2013 13:55:57 -0500
From: Felipe Balbi <balbi@ti.com>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>
Subject: Re: Restrict AM335x PHY driver to only be built on !ARM when
 COMPILE_TEST is set.
Message-ID: <20130905185557.GD9325@radagast>
Reply-To: <balbi@ti.com>
References: <20130903185917.BC7BD660DE3@gitolite.kernel.org>
 <20130903213552.GD2247@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4loEm8vkm2dPEmEM"
Content-Disposition: inline
In-Reply-To: <20130903213552.GD2247@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4loEm8vkm2dPEmEM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 03, 2013 at 05:35:52PM -0400, Dave Jones wrote:
> Signed-off-by: Dave Jones <davej@fedoraproject.org>

you *really* need a commit log here. Also, Cc linux-usb for anyhing
under drivers/usb/

--=20
balbi

--4loEm8vkm2dPEmEM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSKNO9AAoJEIaOsuA1yqREbFYP/A3idQVLNNoFcnkJjFkqtxII
tRim/nDlbI1X7ceoJqj4Qv0MN9nimJfAlHg8SVtw4lbEGPENVCu5GVL09Ux4lrBK
Fft+rS7E2ZksQEGSN+MKDNh59GxDwyIKj5Pgf+rfUYU6GKs2EHtxZLMaAapiY+0J
m14bWBvJo+oUdrM/V5oUrjCxpGbTCE0CkjryuUthRaj0JJRMmwg+SomLLp1IDFaq
uuHPkHCjyMXMFewOijZDtp35WGpZJq6zxw+ToMI89v5qrCioQUrvRYaQtB+bPRXo
gmdXVMBOyXNq50plKvaB4qFbRzxoLrZFGsg6a557QEQmwdk177zwiVHwJ/5q7ysI
dFEnfT8yMek1FaNULFHOZhuIoWnAY7ZrwiU7LpD+aPaI2lXM8evvYhmwuvKe4H7x
QaRxA8jxOEDpEYFu8d6AN6VY1nagkzaBHX3zKVLi0u0xgugBR6ogSjFSozBs+6eR
OkctlXtlFOSb8HIb/pywKazuziBlAs2CDDn5oSsq4KXCP8/eePnmhB8vd57MLVb1
qvZgNj6fduf+q5r1a0BhNXXNg6a/M9fOpUxDkEvE0OvS/ymCQ+D5Qs6ZnoD+3nbC
9FCNSmtVecHRJieVNeQsQu6JSlzdJNSoOuM/f/uPDxCqktK1uHDpbwi5x0svh7ik
SLYgUrl2JWdsGFaYZebA
=GenR
-----END PGP SIGNATURE-----

--4loEm8vkm2dPEmEM--
