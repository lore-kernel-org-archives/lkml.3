Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab3JQX7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 19:59:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33741 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3JQX7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 19:59:44 -0400
Date: Fri, 18 Oct 2013 00:59:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, lee.jones@linaro.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Message-ID: <20131017235940.GB2443@sirena.org.uk>
References: <1381864462-26167-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1381864462-26167-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VI7iFJw/I65Bwf78"
Content-Disposition: inline
In-Reply-To: <1381864462-26167-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3 v2] regulator: core: Add ability to create a lookup
 alias for supply
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VI7iFJw/I65Bwf78
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 15, 2013 at 08:14:20PM +0100, Charles Keepax wrote:
> These patches add the ability to create an alternative device on which
> a lookup for a certain supply should be conducted.

Applied, thanks.  This can't really be applied without pulling in large
chunks of the regulator changes due to some refactoring in the core that
it depends on, I've created a tag supply-alias but it's got a nasty diff
so it's probably best if I apply the other two patches to the regulator
tree?

--VI7iFJw/I65Bwf78
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSYHnoAAoJELSic+t+oim93fMP/3WY98pdQOPTEZcM22PmzN6i
/L9SG5THdezIDvA+thWvh4K63YHm2urtUke8+td2g4HVka1lXLNL7QqluWMN2rK/
+QAHWYf0I1Xx9eGmTtH6Tm0mgBQUkNY7OiaHrpXyuGAEsOIeveLueor0SJpMMIk1
HyCLiymyXXizhPsQS72im5LgULaVFSidNpH8DJXw2lcB8tAW8SqhP1r3crWGi3vR
Vx2Dgfgo7aycyeT5ZNI4cpRV9gm3dcdGEprtyXHRW6a9hLFEux5Sm9hegVXC8KbI
GmhG2RZ4l+j8u1bfh2Frgeyp6eywp8d+vGsbg66ToJvuSY1mENYmE4pWdKb2kcuP
st9bo0sUiGLyZiJVnXL89CxJOp01vxvhBzMfV+PzbUuhAteYQ7pOSsXAGOUyq681
lIG/hutPa15CN0/aezBSSdd56WjYyDjcnls/kIMGx5jamwu+NuaN3S5NNv2vlhFT
qaPQ7PKihkGFBfS3mkdcT/3mTf6+oITPOTo2F4PYpnquWMm3wok524C4bx3zwA2m
2BgHrBBX9o98HMIN4tbCGCnbp0UlqKcadKTPIc5FhHUn8VG8b4ZtNen6q0SW72MW
qu079rHVkra2YCkEzLDeS0oWr0IT850PiSbvVkfocupN7d5yY20ubBYq2bICo71q
BFYy0HKeFK7EU8yDKTrw
=TZXy
-----END PGP SIGNATURE-----

--VI7iFJw/I65Bwf78--
