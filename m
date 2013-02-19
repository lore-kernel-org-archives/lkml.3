Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab3BSMEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:04:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46881 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932473Ab3BSMEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:04:08 -0500
Date: Tue, 19 Feb 2013 12:04:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Emeric Vigier <emeric.vigier@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFT][PATCH 1/2] regulator: ab8500: Fix build error
Message-ID: <20130219120404.GA23508@opensource.wolfsonmicro.com>
References: <1361156277.24231.1.camel@phoenix>
 <20130218102421.GA3538@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <20130218102421.GA3538@gmail.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 18, 2013 at 10:24:21AM +0000, Lee Jones wrote:

> The patches which caused the issues addressed by this patch-set have
> since been rewritten. I have subsequently requested that Mark deletes
> the AB8500 for-next branch. We're going to start again after this
> merge window.

So, as discussed you really shouldn't have done that - unless there's a
very serious problem you should be assuming that patches that have been
applied are going to stay applied and working from the latest upstream
tree.  Once something is in -next the expectation is that it's going to
be sent during the next merge window.  As well as the issues with
maintainers getting fed up having to look at the same code over and over
again it causes people like Axel to waste their time.

However I am probably going to just throw away the current ab8500 work
this time.  Please resend your patches after the merge window (which
just opened).

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRI2oRAAoJELSic+t+oim99mAP/iRok3H4vRQ0UDmuy/J0w/iB
cX4DP00mPhVWVbHxXvT4MT4LI6/tg24vesz/BzAZYqAnLk436VIWuhOIBZcmHAa1
VPvINL4BA4vnEBloBRAxBJPDWSFclXeCAmS8a6TdUp+X3DMtgGdVCPqvTgrXzVgk
8fCL/iw907LN5W52IKfjQMU2IiyPD9usoF665SjJSN4zA+xBr/cSyNk2z9a1044O
fpRpuPvnFwC4dxiuOWrAmrPGSp+hG2I0VU49CsSJhsXbLMGHdruceTH/6/E80eOX
9xmlyuuF9/0iQZoLVngHrLZa9y3YvOIfipXICDLZjWqawOi2EJ9XYdZea+C8YB0c
V5PizPzDEazBF9XWHRg2Ff+z/a8AIRyGzC8j2lOWGdAqFWN7ykOQbBiZ7EMJxsty
x4co1GZH3AHO0kwQ9EyBxIrS3/NM/NsjGSAIxiZwKs7Q+oXoQ5GNG4hRgTOsjkQr
Fizw5JxSaMxNvo2ubEtFPbDBKJz82IJD2Aa+FCRkC0HOhroCEzXK69lMFfVfKvzq
fd332SBuB3tQKTJz2CGoz8vXAFCQHnZf7+illdQYkoBvCiHFwkONi2EQ/rNuSWEs
ghYyB9DbaBcqVdnghx3imp7l9mwxZmM1CRpk/POpgaCf7OXe3Iv5vfL+Jkz0nQVO
svUhvBuYNa4k/8+hddoZ
=Pudq
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
