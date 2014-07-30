Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbaG3Kn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 06:43:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34451 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaG3KnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 06:43:24 -0400
Date: Wed, 30 Jul 2014 11:42:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140730104253.GP17528@sirena.org.uk>
References: <1406651339-28901-1-git-send-email-javier.martinez@collabora.co.uk>
 <1406651339-28901-4-git-send-email-javier.martinez@collabora.co.uk>
 <20140729171857.GV17528@sirena.org.uk>
 <53D8B195.4050003@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+ia+h3A4XZzeh4n"
Content-Disposition: inline
In-Reply-To: <53D8B195.4050003@collabora.co.uk>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 3/5] regulator: core: Only apply constraints if available
 on list voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+ia+h3A4XZzeh4n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 30, 2014 at 10:49:25AM +0200, Javier Martinez Canillas wrote:
> On 07/29/2014 07:18 PM, Mark Brown wrote:

> > I would also expect any regulator where the supplied devices are able to
> > vary the voltage to explicitly provide a constraint even if the
> > implementation is done in a parent regulator.  There may be constraints
> > on the child supply which aren't directly present on the parent supply
> > and can be ignored if the child supply is turned off.

> Agreed, if I explicitly set the voltage constraints on the child supply then
> this patch is indeed not needed.

We will, however, need some code to pass the child supply constraints on
to the parent.

--x+ia+h3A4XZzeh4n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT2MwqAAoJELSic+t+oim9aSMP/1mskx3pbsqkgw34u4P/2oU1
mEi0MeW02i1FYQnwqNFq8JZFzgik444f6vY73w6AOSnTP1Z5Z8x2YdYAbCd8ipmH
SX/PUgrLUIU0y6bnbicfOkni74C+BfYHpoJxHQDQKAWq4qxUeW9WpNnVplboNZNt
LJZktdAhs06OGgk/mevhppZ/xIauaJYJoaUbs+EniX5z6dYwTuFYPTQObjBhEt1w
JHiAlZPuvGi6pFDYXqxL6vBtqskq6/qofqX3ojskIdSFsmag36GQcO5yclK5/kVe
uiCFdG6ygzFlnytMENMRT6HapBvK9CQkY4qIFQGrt8edmVW2tGpvXm64MiMQ2VmM
uUawHp4WOQB28oVSByDKK/UyXaACueOYu4EJfPnod4PCTJCDXS/OVpiucCwZCv8m
JU5DI0fkj76eJqXP2Q0VIElDURwA8Hnq8hGfaMfMt8oPZPmC5QA4AOEoB+3oq0A3
SpB9jMiUefZ+nOAwI0cPdCHRSpiXm7w2qSYca0E+XxLvVvYffpTz0a9mxlBskgUy
Yh3CSBiGycX+cQ4sjyje7Y6lpEEwq4Qg4P6wr4zk0ACIoXw0pdIcNNCHdpAJVUcx
zE0PMpSm7cHEEVOc6ZEmzm5lCMnCWTNAw0G/b7gXDMduVROug5ow3wo5CcFmmOMC
4tpsCYLxwN5Zx5nzGEl0
=TkDr
-----END PGP SIGNATURE-----

--x+ia+h3A4XZzeh4n--
