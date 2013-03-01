Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab3CAIMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:12:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54285 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758Ab3CAIMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:12:24 -0500
Date: Fri, 1 Mar 2013 16:11:54 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Tero Kristo <t-kristo@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: twl: Convert fixed voltage to use
 regulator_list_voltage_linear
Message-ID: <20130301081151.GQ25302@opensource.wolfsonmicro.com>
References: <1360982253.6332.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="glwmnIOgU1tcuP7N"
Content-Disposition: inline
In-Reply-To: <1360982253.6332.3.camel@phoenix>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--glwmnIOgU1tcuP7N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 16, 2013 at 10:37:33AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

I didn't apply this as there was an earlier version sitting in my tree
which for some reason had never been pushed out and merged.  Sorry about
that.

--glwmnIOgU1tcuP7N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMGK/AAoJELSic+t+oim9N60P/0ChaY1uC8tnV1K00JaZ2im6
bB1ZbP+a0j94eIueqisVwI6RF+qyf4580ZoxWt2kVMBx/Ckdqs+ybS3cykQMqN/g
ztFHG18RK94oljaVjLoVhqDM76CFJOyNL0xk+JAaXvxZEcn2R4c8e4sUNRViFrMf
thtMNOmiUiqbHGzmQMAcxFfF+APL5p5NF9FYh66XxYzKbirpn+ozDFP4nc05R8HX
LxHYRn9JzUdd7aygSj/EAPZimQz+0WNMRDvWkTZYrR0FRMJ7ggKoqFiB9idW8OJU
DT837mx2LbMOlAgqYji2L8PxWNSIsuQrrj0x5UPjVj+o9hzWgCp+x7HyftCgAI3z
XTKWdXrJVpCJ4VX5bMw2fVQA4jE3R5FS2ZWb8YO5rhRypePgPavgHNf3ADkALkZ4
FljUrgEvzG21ijgZv9CNm1ZPPFwGfxSMKYH+H8AoLsDKGxjac0lOSnBBHK/VEvJF
oqxsXo9vd8KgfyiFH7hrVvTwnEd2Y6MVdbDoNhHC73oxabo77vh+PiLuHMtOrM3c
05RFYk78EN1HQLswLwl4nZxgu47LWE5r7KxZ3+VzjxqECBqX4wcFnKe8zkCxoCfC
WA22uPlg1f+Cc2+wPBM3ZhS3QZqabacgoEL8SJ9PgQeDT7agSiaQ8GeiR0dvedPz
cLFOTMH58wbowTc7gDcI
=d+9j
-----END PGP SIGNATURE-----

--glwmnIOgU1tcuP7N--
