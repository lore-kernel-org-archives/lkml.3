Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab3HPPc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:32:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33010 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab3HPPcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:32:51 -0400
Date: Fri, 16 Aug 2013 10:32:26 -0500
From: Felipe Balbi <balbi@ti.com>
To: Matt Porter <matt.porter@linaro.org>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH 2/2] usb: gadget: ffs: add ACM + FunctionFS configuration
Message-ID: <20130816153226.GO15861@radagast>
Reply-To: <balbi@ti.com>
References: <1376666868-32581-1-git-send-email-matt.porter@linaro.org>
 <1376666868-32581-3-git-send-email-matt.porter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uw+RRa3pmtkgiNaD"
Content-Disposition: inline
In-Reply-To: <1376666868-32581-3-git-send-email-matt.porter@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Uw+RRa3pmtkgiNaD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2013 at 11:27:48AM -0400, Matt Porter wrote:
> Adds an additional configuration to g_ffs to allow for
> CDC ACM support in conjuction with FunctionFS. A module
> parameter is added to allow for multiple ACM ports to
> be instantiated.
>=20
> Signed-off-by: Matt Porter <matt.porter@linaro.org>

the whole idea of the configfs interface was that we wouldn't add this
sort of patch to the kernel anymore. What's wrong with building your
device through configfs in userland ?

--=20
balbi

--Uw+RRa3pmtkgiNaD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSDkYJAAoJEIaOsuA1yqREn2IP/2M8ENBU4LcPnIWT5NJvjhrT
GuKLyRE9UZDvmSrJ/oOGd/GIJT/pq+1pj1ft6979Np6JtIrFzbjRpl8Jr50gHRzp
cTttKVnT3gQx+NTRzs1qtOQQn0P7Jki7mGzNAlWqoYhd4cP6OqhTo9m/0vMfycV8
u6fEJ6A41UnM6wrE11ktm9IW1TJjTseglIjjXjZajtOfFZ6TOGfz9785ZbD3v+qe
WCEPR3fIlTOOIx8B71/WRIAllTlOS8yGesK2wzcI78ri66MwFf+FekOo7B0qzpoD
sRpmSQTsEZsvn4MwyOcQ/VBNHVWY5bwmZFicjZg+/OKANjaYTAHEOcq1ugHv5uX3
1YisQ08CTInwCS6Z589JYgV+42TD1o9rAWI+I+ouYo528iqHY6cqDb8wR25TeOl3
gjcUHyKNjIX4NEDuJzT12ds6Q4uOkj9HI+VotlVLpLn3edW4Ld4jXhIJmSFgDrkn
HrHOjyDacYXKQMj5JdGX82RwNTFTLIeop7+hhb6TXVUGKQ153deGFPlJr16WDb0Y
E4LXUcq1ELpazn8doRTtvqnut3XhEpKl61uc+mG4SCsnSosIUBUUydIawoJKQW+J
Lhpho/h36qaXGQA0CzXX0qTtT2V3+Ll3PrBLeL65xIDHD1exBuwqtVamZVfgj0ZZ
fW7G9aYgK0ShfBLPPIa+
=qaP3
-----END PGP SIGNATURE-----

--Uw+RRa3pmtkgiNaD--
