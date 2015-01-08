Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbbAHLox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 06:44:53 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:36694 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbbAHLov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 06:44:51 -0500
Date: Thu, 8 Jan 2015 12:44:46 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Vince Hsu <vinceh@nvidia.com>, Lucas Stach <dev@lynxeye.de>,
        swarren@wwwdotorg.org, gnurou@gmail.com, bskeggs@redhat.com,
        martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com, nouveau@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
Message-ID: <20150108114444.GM1987@ulmo.nvidia.com>
References: <1419331204-26679-2-git-send-email-vinceh@nvidia.com>
 <1419426990.2179.7.camel@lynxeye.de>
 <549B7638.2010405@nvidia.com>
 <20150105150932.GG12010@ulmo.nvidia.com>
 <20150107101900.GP10073@tbergstrom-lnx.Nvidia.com>
 <54AD0F37.5080609@nvidia.com>
 <20150107141254.GS10073@tbergstrom-lnx.Nvidia.com>
 <20150107141938.GA7392@nvidia.com>
 <20150107151206.GG1621@ulmo>
 <20150108093957.GW10073@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nrXiCraHbXeog9mY"
Content-Disposition: inline
In-Reply-To: <20150108093957.GW10073@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nrXiCraHbXeog9mY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 08, 2015 at 11:39:57AM +0200, Peter De Schrijver wrote:
> > > And specify the dependencies between domains in DT?
> >=20
> > I think the dependencies could be in the driver. Of course the power
> > domains are per-SoC data, so really shouldn't be in the DTS either (the
> > data is all implied by the compatible value) but there's no good way to
>=20
> The clock references could also be retrieved via clk_get_sys(). We could =
add
> some more clkdev entries. If we use the domain name as the dev_id and the
> module names as the con_id's, the domain code could then retrieve the
> clocks by iterating over the module names and performing a
> clk_get_sys(domain_name, module_name) for each module. Unfortunately no s=
uch
> mechanism exists for resets.

I don't think having both clock and reset references in the device tree
is all that bad. We could possibly add a lookup mechanism for reset
controls that doesn't rely on DT, but I'm not sure it's really worth it.

Thierry

--nrXiCraHbXeog9mY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUrm2sAAoJEN0jrNd/PrOha84P/1wY2w9+orYwoBE8WixTHfrC
I/j4RixXnDqtaUnoO9/yP5kBFEe87yfUv9eXdDABVIGSR2/iymClgC3zTNGQ/RZN
6EVH4ga99wNiIPUE/+xkmhezeccNv+FEk6B4DhTRbKu6weKDX2IA+IHvAJlkrLvO
08Y8vEzrEkL8FuoiUC+pQnsNOtUW8Yn4/c8hr2M0Ac0N631Krwy3d8SDYCylYp1s
8IUd0I/6stAjWOHuXPHGYJ1fzeM2j40Vn7HvvdUX/XvJWrwhf8HJhreX6UpPRsZV
MbwHPwR0Sbd4cbSnbkVdfjGEHLb3GcyaPZrpOTrqq0WF694y2g19/ff/LtetQLEq
9WVrRH4YNv5VS+kJK1mk9ObHs4DK5kmDpOlVOcaY4yea540x+yv8CCR+GliQ/pXc
zR7SIpyEsTCAm76EiS/YRohPW78Q698yL8+cOkOX9YUHktFFCWDfJQg2au8AHX5t
fiBwIR2tw6wbaedHsmhFfXp9z2wArSyO/sXdDs9GIZ7tzOJ67yC1xVZbGQtJgtrF
7Yra0YZv8H/In6aXg35XilgcyjMdaKbZe3vnsTuzWm9Br9jrptpAcL5Yj/0O3nhg
lB3nqT1pf9Y/Fi/M1TLzl7PXI9JpaaRahwOzl9BVU2NJNpTI3ui6+JvD604kmdMT
CSPEtLWkeZiLJ0MYlv+H
=mAG6
-----END PGP SIGNATURE-----

--nrXiCraHbXeog9mY--
