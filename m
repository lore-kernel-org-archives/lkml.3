Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966450AbaFTJly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:41:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50337 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965376AbaFTJlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:41:52 -0400
Date: Fri, 20 Jun 2014 10:41:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Keerthy <j-keerthy@ti.com>,
        Nishanth Menon <nm@ti.com>, Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140620094119.GT5099@sirena.org.uk>
References: <1403164154-1362-1-git-send-email-acourbot@nvidia.com>
 <53A308C8.2070004@wwwdotorg.org>
 <20140619175643.GR5099@sirena.org.uk>
 <53A3C613.8030207@nvidia.com>
 <53A3D85E.7030704@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X+WXP0omYNJFGow2"
Content-Disposition: inline
In-Reply-To: <53A3D85E.7030704@nvidia.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ARM: tegra: TN7: relax some regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X+WXP0omYNJFGow2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 20, 2014 at 03:44:46PM +0900, Alexandre Courbot wrote:

> dbabd624d
> regulator: palmas: Reemove open coded functions with helper functions

> Keerthy, Nishanth, could it be that there is still something wrong with the
> REGULATOR_LINEAR_RANGE() definitions?

> This seems to be the cause for our trouble, but the other questions might
> still stand, in case there is interest in discussing them.

There was a bug fix to the Palmas driver which just went to Linus the
other day, are you sure this isn't fixed in mainline (or -next, it's
been in -next for a week or something)?

--X+WXP0omYNJFGow2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTpAG8AAoJELSic+t+oim9qI8P/A6FbVvulfg+tXMAxEoPfqBB
/BY3oOOjxQFRWGW5StUc8ZR31itnbsYmenzaJ5HTYrOpTUahPJ8wGXtjja+BAsyF
FHXQ7k/xcd3iAGq7JBQMTsnjUkiyo7h9CQeE5hJTvx2vpNccXsSFOkc9JhB3+vmR
ncD+aVgOR3l+c83pnhjnSPTH3xGkJjia/U/YOIlORFYmfWkqUjpzmja0JNzkwbD2
H8b9UdZidl8/2upnyxI0pDJjftLhK47u3nR0jY0YVMhhFZtAynUEZbeDR9L3NHf5
NrklCkJ4q+uQkk9wF0dWVVLuC/UbuM59keMzjUTffoKCDRw/ePmS5V0L6KKi24AV
fJauDN0k3OERbhCyk6N0+Lz2+CVPOgL9YRudQr+EFvPPs061zyRuLtIjdb48jfI+
+vObsTtpcAi1EqBSYtTKzsIRwsqEKv83IRIyCR6VuRM2OHmb9W9EioEpRs/fQ+3c
i2YcBWapnjKT12i6bh6sBEY7UfePQQHtnP8MuJc5Nd4741R8vfKZOk/WlGoBhOC7
9m8HTZ3ZKgcpKG8/p41JZndjQx7e5ftHiCEJOrWWwBLK/rIE64tiEJBS6cPavwfZ
RNco9SscDH+0rxdkp9RypKrxmLH6M6WiXUMTPaZ3XJ+TKfonE+bXsH/AT/WYZLip
RXWRJ4nG3hN5kPW8dwnK
=i2F6
-----END PGP SIGNATURE-----

--X+WXP0omYNJFGow2--
