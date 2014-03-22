Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaCVSz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 14:55:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54687 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaCVSzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 14:55:52 -0400
Date: Sat, 22 Mar 2014 18:55:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Patrick Lai <plai@codeaurora.org>
Message-ID: <20140322185547.GB30031@sirena.org.uk>
References: <20140321000558.606667505@linuxfoundation.org>
 <20140321000606.724570655@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s/l3CgOIzMHHjg/5"
Content-Disposition: inline
In-Reply-To: <20140321000606.724570655@linuxfoundation.org>
X-Cookie: I've Been Moved!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3.10 56/85] ASoC: pcm: free path list before exiting from
 error conditions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s/l3CgOIzMHHjg/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2014 at 05:09:59PM -0700, Greg Kroah-Hartman wrote:
> 3.10-stable review patch.  If anyone has any objections, please let me kn=
ow.

Ben noticed an issue with this when checking for v3.13, I've dropped
=66rom upstream.

--s/l3CgOIzMHHjg/5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTLdywAAoJELSic+t+oim98fwP/2Uzr5vpP4ndJaL06rw22VqI
XEHkj4ZwiCcevLaYh9O/qyeHqVJLlYwFVHM7dl8GRwaOlOc2gA3xO03Lwm63L7QV
9YvGilprY5MzQVvPlid4Su/U65QpFQOU/PNSCBuTY2K67iYGUvIfgd6mjYjeGKT5
qxFEKd5vCXV7B41BLvifKXmFgwOHiGC8R+efE9qv+M6IcMNCs/R08c7d/FLA11oA
ImOlC2HWUTW5Pou902ffqwrwEFm2iOt0MPDrwVXEten1mwHgovkqyMP0u6lcZkRW
Dr7pSgnQZgFtCFI4SPAuvjQbFgsYpp9VaTkr88matsCSDKjDM0WUHIy2VM3Sse+9
VXKrlIfGIxlHi6mqJYlcDzytuRm5jOXo4zAcK4ZDHJVcJXZYbLi42OEzm/Bu+sLr
FVr5n72cMnG0m4WdW6/zzWQvNpDI0Hga2iocMJXWpQJ2nreZFeI7PHw2qfkoqZX6
/ktSmTHRKGsvGNbu/PuMkO/d46ytIXPbasLpT3j6YFf/NLBxfiiO9B/jqOy1qAl3
/GXofT8WLdcCZrv170ID3WYV8VblkKrngf3ewNPQpkRi7iZm7suJZoz507yb75E5
QOFYwoNS8oI7jxXO4kq1s3Ed3dy81mnpCsPaMvwj/FuMX2KOfxxCzoGVIn2nH/My
3/vzPGKUfM15u2P5/ZKB
=FW1K
-----END PGP SIGNATURE-----

--s/l3CgOIzMHHjg/5--
