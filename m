Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab3FFNV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:21:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38212 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab3FFNVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:21:55 -0400
Date: Thu, 6 Jun 2013 14:21:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Message-ID: <20130606132119.GY31367@sirena.org.uk>
References: <51AF8730.4010507@itdev.co.uk>
 <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com>
 <51AFA02B.3000604@itdev.co.uk>
 <20130605210715.GA16013@core.coreip.homeip.net>
 <20130606094822.GB1883@sirena.org.uk>
 <51B06732.2050701@itdev.co.uk>
 <20130606104651.GS31367@sirena.org.uk>
 <51B06BE6.80909@itdev.co.uk>
 <20130606111437.GV31367@sirena.org.uk>
 <51B073E1.30108@itdev.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d3DVaulSu5qtnQB/"
Content-Disposition: inline
In-Reply-To: <51B073E1.30108@itdev.co.uk>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d3DVaulSu5qtnQB/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 06, 2013 at 12:34:57PM +0100, Nick Dyer wrote:
> Mark Brown wrote:

> > This is yet another reason for implementing the protocol properly
> > instead of trying to bodge around the kernel.  It really seems like
> > the biggest problem here is the decision to try to bodge the entire
> > thing into userspace with no kernel support.

> With the interface I am proposing it is handled properly, in the kernel driver.

You're proposing doing this using direct register I/O...

> From an Atmel perspective, Linux is just another platform and we want to
> use our existing investment in tools and documentation to manage & debug
> chips embedded in Linux based devices. So providing a bridge using a

Broadly speaking the kernel upstream just don't care about this.

> > That sounded like what you were talking about, it's pretty common and is
> > sane enough for reads.

> The address pointer is shared between reads and writes on maXTouch, but I
> guess that's not a huge problem.

That's totally normal.

--d3DVaulSu5qtnQB/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRsIzMAAoJELSic+t+oim9QbgP/1VgmSXmU9iKQ6Ohx5oMM++p
lgKwRI3BqKsZO6UzLcNezBuy7FxOvingh8TqKYrgaEZjaO8g9JIVGRSbQw/HUsvK
kWQYUKhR4iGpHvgQmDdEtdraeDehvalDGVvetQd/j7yT0VXUEtF9uaJdjn/oqWcQ
U8v+X1f3q5ZxKSAXWUX790KcQDzJDqDV9z4+2LX8XXl4poiMAsP6t2/u5jS8jAMn
lSCkzxy7S7PlRQeG4rNmmhOaEt9edydOCIsifcAolkfvpAx+v8zSlIK+II8iBV4/
U8MwfhjdGTl1bBpq6YnEJ9q1PcgSwyt/ZTwGltFDKZZ6CqHnM/6CLfz0a3LIwkbz
V8Kcebj7RqatvNf1zgMDwvXtafYvU3D3Yvgk3BZlxYlBgmz0l/d5vYrtVZiQi8t0
dCVGMAi2OtQPsfkwR7TWnt7sM/x6t18g4P60kGX3ci0PZMgqLC79tnYmT+O50WWk
N88ZuZf/kx1mHwp7GqnJ7KegtIn53Sy5VLh1EHGoSqjszq5dRqzArLIe6ENkhf7d
LigYMZOb4hL2j0jIGuCqsV6AuVPA2t6pTjCwrphhx71zTQVILlfTajUSU/vlzJjC
JZfCDJs+wjLpbpsNQz2x/KhwUGCatnAJkJGq5/6Uj5ZLEx7sHg3AZh/fQnQQYebr
SccbZzQflNj1fvIr7GMR
=zL44
-----END PGP SIGNATURE-----

--d3DVaulSu5qtnQB/--
