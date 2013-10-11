Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3JKF6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 01:58:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50997 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab3JKF6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 01:58:18 -0400
Message-ID: <52579371.8070408@ti.com>
Date: Fri, 11 Oct 2013 08:58:09 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>
CC: <linux-kernel@vger.kernel.org>, <monstr@monstr.eu>, <joe@perches.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, <linux-fbdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] video: xilinxfb: Use standard variable name convention
References: <631df9a44b366af4129d00f1d4e1d3baad7d4903.1381386616.git.michal.simek@xilinx.com>
In-Reply-To: <631df9a44b366af4129d00f1d4e1d3baad7d4903.1381386616.git.michal.simek@xilinx.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="catTPNVVv4gFOm9LsvdwmNclLLtE5x089"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--catTPNVVv4gFOm9LsvdwmNclLLtE5x089
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/10/13 09:30, Michal Simek wrote:
> s/op/pdev/ in xilinxfb_of_probe().
> No functional chagnes.
>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> Changes in v3: None
> Changes in v2: None
>=20
>  drivers/video/xilinxfb.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

Thanks, queued this series for 3.13.

 Tomi



--catTPNVVv4gFOm9LsvdwmNclLLtE5x089
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSV5NxAAoJEPo9qoy8lh71cn0P/0aoh15bnSNQAdKZ8HufYbZb
jmd8AANUVCgRmiiSKNvXgU6vjj0sA/gT1FxcOww3F17NSrNxaJxaZYkG+o7JNcp4
1JjDBfK/HJt7+TM+AfDEwdGCy3grkfgalm6EF55paFYiEgd8xPSc7U+mlD3EAU6o
tRtrRtgdl6nN5FLHD8xJTC5XDzuKiXIZV6I9qy0gzjF2WCJIuF63PrwrOTMstW9f
adXg4O/X0ZAUk3pqOHcbZRan7LqhHhihQgAL3mQyIpGy8aTiSuTL1mPV05gUEl3v
7RVzzpqYSNnWhH9eQIgNbDYon8Xn/ueqeZAAguo75WXwO4JCGcihDhDr/p5t+PeH
V+HdOCqbpKEu3hljCvRt46gkbbeqvNOxKLQiwFly36tf/+NwAmREKSt3CEvQZdoo
YDfjsQCPbs8hD9e0XElJGtkhsSs91dzzwlCr2QbT+p+b9n683r6Fj427RdKFKpP4
Weokl1YPza8GGGFbuaRg8KdTogygJNWrCybGHyuru6k074e1YAkKxgPsvMsmHEN2
VjgOekCNG4zX2R02f4vw7rpMQs9dxOqDtCn+F4Fd7SPrpOUN6U/FBDo22FhKeCs+
t2/LyFA6rhUyjkIAJI8lOuxt0hX3u98AY+LFJq819GW097GKNWW1pzRZ6Xd215Yb
jsAK1HzcX+tWjtEmrii2
=LVr9
-----END PGP SIGNATURE-----

--catTPNVVv4gFOm9LsvdwmNclLLtE5x089--
