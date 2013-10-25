Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab3JYPpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:45:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54758 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab3JYPpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:45:50 -0400
Date: Fri, 25 Oct 2013 16:45:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Olof Johansson <olof@lixom.net>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20131025154546.GE26122@sirena.org.uk>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
 <5269FB5E.6010901@roeck-us.net>
 <20131025083525.GF19622@ulmo.nvidia.com>
 <CAOesGMg+Xi3+MZrPbRiMGFe2cQFjN9qaif9u5gW_tDzK62EB7w@mail.gmail.com>
 <20131025132422.GC12932@sirena.org.uk>
 <CAOesGMjuT0ntb6awo0PVtccqvFfo_Lzj1zyGNX=C4BrVLBow7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h56sxpGKRmy85csR"
Content-Disposition: inline
In-Reply-To: <CAOesGMjuT0ntb6awo0PVtccqvFfo_Lzj1zyGNX=C4BrVLBow7w@mail.gmail.com>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 31.101.168.31
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: Tree for Oct 24
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h56sxpGKRmy85csR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 25, 2013 at 06:33:43AM -0700, Olof Johansson wrote:
> On Fri, Oct 25, 2013 at 6:24 AM, Mark Brown <broonie@kernel.org> wrote:

> > The rule I was applying (which I think is the same as Stephen applies)
> > is that I'd fix anything that was definitely the result of a merge issue
> > (like the build failure in misc due to a sysfs API change in the sysfs
> > tree) but not anything that was just plain broken in the tree in
> > isolation.

> Some of those might still make sense, but as many as possible of them
> should be pushed down into the trees where they belong, even if
> they're strictly not needed there (as long as they don't break the
> standalone tree, of course).

Right, this is strictly for issues generated as a result of a change in
one tree that cause an issue when merged with another tree like adding a
user of an API in one tree that has had an incompatible change in
another.

--h56sxpGKRmy85csR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSapImAAoJELSic+t+oim9iNYP/A/PZkN51WNfyDoaDR6hk846
cei8Ez3QqxFzL4rja7Pm2WVs6AD2uP0ojJ/K6y9x8s9VV9K3DQuUVdyOxSy8nab2
d3MyG8h4hFyIvOK/ciLDf63QWnUfCQ3ve2e2Zn5bA+aimQ+Zl1kg3D4mJ/WR411h
n8+QbAOLUFxDo0OdG1t7JNnRHXb31uRXERscHxqCKFKPNaw02W7UmkgBGogULcjR
fkPz3dQubXpes1DY0Bg2PeWXexcRtfsRI0qsmV7uEk8pCyK2IrkjlJq+gS50Zlc4
LYQlYy+h1/awLkTI/FyHvm7Jh7bfq7mntOw+y9ofP+rjIhyNYpiG7wK7DJuKtsKX
g+EPJjpF7lW48tUnVZ1L5KhpVb56nS69EmdOa8+xMx0zDd2wiVcO42NOdAh01Bew
U3ZAZEsFu8SAXDkUTrF+nXG1eNcJ1VQ/F8B64HTbucZQ2plesU6mDbtl6P4C1SUa
BjUc9aclaNFS0ujpP7eZkkybs5znTx1Kz3XIzJ8XNTr6Wa3fTG0xZ7mVOuc9UF1K
k6iA8s/2h7JKjjk2Px2tRxFxwgR4AN40X21YRWb/Q9ti5tcIf1b//+nrO4M6xIHw
aJ2/IJyLLR+pF1tlUwn6esruvThHwj+YlsHK5W93Hj0502fjzDMS5mfkTSRGUTxu
pQEF9tLjlGRMLO6NSZmG
=+kX7
-----END PGP SIGNATURE-----

--h56sxpGKRmy85csR--
