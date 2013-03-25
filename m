Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109Ab3CYUCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:02:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64056 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932989Ab3CYUCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:02:44 -0400
Date: Mon, 25 Mar 2013 21:02:37 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] PCI: tegra: Use new MSI chip infrastructure
Message-ID: <20130325200237.GA4177@avionic-0098.mockup.avionic-design.de>
References: <1363942307-9327-1-git-send-email-thierry.reding@avionic-design.de>
 <1363942307-9327-3-git-send-email-thierry.reding@avionic-design.de>
 <515082DB.1090801@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <515082DB.1090801@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:XmA0qxy9fAhb67n6A/3dxf1d0WFXxlLduIlH3zfA+eG
 90TE2SZqmXAWStdO37/YdxqjriQ98lENPeDU54q7FXY+7n3MQ+
 bcDB3LiRwhIyiSK/niqnti0Ur+VtvwoDtMSDtuEWWInAI5UU1Y
 8Kb5nyCvESp7ZP5T0VUevDiV/LiM9IpvTo0usfB4XJ9sHhqLDK
 JH2vWZYlS5uKVemr0MKD8CCXb1SdJsfREsVLS/rdCRFaHUQq06
 AIucL6nAVkKRseixI4BTkhmBmtY6PK+c9sk/VATeI7Tipxb/15
 qcd0Yf5Jz6eY5iaoJ3/Mff0DKMzdqxV2BO4ZSLKhEcf5WxYFZw
 el7ympBXInKlN8A+mX45gp65RCrBajjHRwxw9TZylhIfObbeS2
 xrNV+FhF0cDTRWenuMMBvzm2D3M7LQn5Dg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 25, 2013 at 11:01:15AM -0600, Stephen Warren wrote:
> On 03/22/2013 02:51 AM, Thierry Reding wrote:
> > Implement an MSI chip that uses the Tegra PCIe controller's built-in
> > support to provide MSI services to the root bus and its children.
>=20
> Acked-by: Stephen Warren <swarren@nvidia.com>
>=20
> Thierry, what Tegra-related PCIe patches will you posted for 3.10? If
> it's just this, I'm happy for this to go through the PCI tree along with
> patch 1/2. If you're still planning on doing the whole Tegra PCIe driver
> conversion and move for 3.10, perhaps there are some additional
> dependencies that require thinking about?

This one patch depends on the whole series. At this point it doesn't
make any sense to merge anything but all of them. Andrew Murray was
working on getting the OF specific bits ready for merge, so I think
there are only a couple of Tegra-specific patches that would need to be
taken care of, such as minor PMC things. I'll look into posting a
complete series soon.

My plan was to squash this patch into the large rewrite/move patch from
the series because that introduces MSI support in the first place. But I
thought for this particular mini-series it'd be easier to see what needs
to be done to support it if I post only the relevant bits.

Thierry

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRUK1dAAoJEN0jrNd/PrOhzg4P/3+/rWE7XTvCccMPRHkg2BvW
01kseMq/FBZbvUtlPEaUTKUEvPu0yB+skQpakgdYnmzyG5E4uurHMknah1F45g6I
FbgX0oaMkazyosjlzhJMg4xASqUlARpJs/wvF3YRnquWDEpUHnSv6Lf3OdSd1oNE
eGq8TVY+FgviQy6sJb7bAnWpk+1oe4EXU0sQqB+SGv2rgzL+hyTz0UnSZjINnB0n
eXmgoBedQYpubp4KX0Uh/danCk4oYPaKEedHFHrf/Et7+BbWumMOuugv+N9Pacic
JN8YHCUZiDzlb4PkySPWikb+jgygxAeMe62wpQGvHWcc4N1OkG0GvSGia7cZXIie
9FJ2ovlfmaMCp8T0J0y3gJ/TujV2g3Kur+t7mt3T6NYvJewxEpyvAgtALDc96YDm
OeeNIpZbpJQCG+iWiCZByPgWNjbqfasHBypXmB4P+5VTjfFde4VYSYNtB+issUt1
IxxWadIb12Sj+ies+t0aJHqTDxxUFKpaoCbi/gZ7A4KfjcUcqu+gclpKzDKbpjD5
Ctr97mrqGdi5ykZZBtXUiSygcUwhwB3sHyif7L1qhtaedOh4tZZC6X9tgUe2VIvH
fpQYjCVd8wFyCZuQ7SZHfSaSngod6NY/L7f3XkQtxEc3vcEBKjsevnM3BVobEFOc
ppbdVMAlpNnY7DUPCu5W
=Ieob
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
