Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313Ab3JOJhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 05:37:01 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56222 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757868Ab3JOJg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 05:36:58 -0400
Date: Tue, 15 Oct 2013 10:36:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        linux-bcache@vger.kernel.org
Message-ID: <20131015093609.GT2443@sirena.org.uk>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
 <525C3EC2.20404@infradead.org>
 <20131014202723.GQ2443@sirena.org.uk>
 <20131015084631.GK7856@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bIK/Xm5bvUaTMa1a"
Content-Disposition: inline
In-Reply-To: <20131015084631.GK7856@ulmo.nvidia.com>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: Tree for Oct 14 (bcache)
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bIK/Xm5bvUaTMa1a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 15, 2013 at 10:46:32AM +0200, Thierry Reding wrote:

> Oh wait, they were applied right after the merges that broke. I hadn't
> checked for that.

Yeah, it's because I've been doing incremental build checks - the builds
fail at the point the tree gets merged in.

--bIK/Xm5bvUaTMa1a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSXQyFAAoJELSic+t+oim9EYwP/A2MPJ+vNq610cxv+vxPa/DQ
4M8teRS8iNcdCgqxdd/vkspZz6F0retJqXKOUBa+gN/IF2DTWzLbAJBsas0lZCUk
JXoMJU7H/VgqeJmoZmQRsf1rM0ZmM08dUWnV6QKmAGldwSOtRW4+LA9vm3zZDZWe
IF7tJaAtHOfQEUar0EYIZlmzl3AKtQW6HEky2uYFx97nAFjeEQm6r9ajn+D4lpll
Pio9uBq9+Bkl/CEvwjp2F/Kpc/wPbOqdYI7YpZuOEDK6+4EOyXc/n9Zq8BsTcQo0
YhfgwpmcNtc0cwAy3pRU7oE9VnC50Lcs7Pfa1wdDJXi5SWr6KAKShbLWRukRqjKo
1lRIM6XvNt8KYxZja7lckfglE7SAYfwbuNEiUrOcTV2zzS6mtsvXVtWynrKXV8Bp
YJN0qXJfDmlJ0jyNC4slzoeOp84RaOWij1+JyuO2H2KHz8Rdfol4vRVOquPOEk6z
bbtYurL1tKJJBHftSC14WDUxGGsHxIRYMHeIohfWZ+xyTd9LFWsnDsCLgysGgRCi
9StG2Y1OZCWfbcQ1ihnXyxDThaLKMqxvXbpo9EoA4NBGqsDBteLp86svYBExmWuj
Fb1cJbu960k7lYHb+55gV0IRj0qNhEXkiPTdkBSGaP9QvcvOpHNZ+ofaHw8DIxGE
uqcXLhCAIctLIVu80cUU
=NiVj
-----END PGP SIGNATURE-----

--bIK/Xm5bvUaTMa1a--
