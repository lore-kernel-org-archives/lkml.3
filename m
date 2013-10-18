Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab3JRNHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:07:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59427 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3JRNHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:07:07 -0400
Date: Fri, 18 Oct 2013 14:06:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>, lgirdwood@gmail.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20131018130643.GN2443@sirena.org.uk>
References: <1381864462-26167-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1381864462-26167-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20131017235940.GB2443@sirena.org.uk>
 <20131018065345.GR19112@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0RwGLsbLTbEJtbO7"
Content-Disposition: inline
In-Reply-To: <20131018065345.GR19112@lee--X1>
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


--0RwGLsbLTbEJtbO7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 18, 2013 at 07:53:45AM +0100, Lee Jones wrote:

> If you're happy with the other two patches, I am. Would you mind
> reviewing and providing your Ack? Once I have it, I'll setup a branch
> you can pull from in my MFD tree.

Acked-by: Mark Brown <broonie@linaro.org>

but those patches will fail to build without the preceeding regulator
patch (which is in my tree, there's a signed commit supply-alias but it
pulls along an awfully large diffstat sadly).

--0RwGLsbLTbEJtbO7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSYTJgAAoJELSic+t+oim98mMP/3oPuHjcAMHW/BCo1EU2NeQb
ty7MbeDvJzKsxI6u8++7k50V9DLRa/0uG+fuoDC7DqiXqpgOT2uxFw2iyxAByHsD
3gSUpf4BVmi0+BaaRSC7OGJxZUA437ltitq98aJoEMWxse4+VKMXX4hxl+rtwaYb
CQMMWCP9QrZHJVhD2ZFMC+CyYgft2Cw4o2Bvq/+w40AFsJRttPSGxWw5C0IXtFZi
GURoWqCz0bWK3xxZwxOnXdCVTMR5drepq4CgnJJsIbQFCGgygDuzl/uP/bRqlwzt
cjmEzi1W+PIkbUaJIAL2Orf+0mBKdoNRgKeQ9ejXzng6ixLyQxdcRhLO2NUn/kr5
cPFOPKygH2c8xxBEAwoNHPjQ1Uq7r3VexZKy6NmjteFBGd4EFWCNL+xHebS0p/tG
jtGFylaj1dpK5V1jusxiyRJ3RKmgmvim5TxL2p0pu8DubV9TW9lUw3P0lZy3CoBL
RWJJolCu5mdhs9Bc3AK4+dOeV4V/CoMO2rm+BFxf5HkYsYWbQkaiIiyPhLKGzjdH
nhBy6hWYNknhx40PWNEcanqHeJvldwpRJ3meDTu5pEcUMwMdSINTHQvTq2XEH+7Q
ILq+0aQekgSfrj6SWbiT3DYtKZTV1TzqwbF0hjXQaFu8bXOpd3dQ7n9oVkllPYRP
WzK9rYI9EmLnYY5su5Gm
=YXNv
-----END PGP SIGNATURE-----

--0RwGLsbLTbEJtbO7--
