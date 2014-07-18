Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761731AbaGRPGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:06:13 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:64047 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbaGRPGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:06:10 -0400
Date: Fri, 18 Jul 2014 17:06:04 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tejun Heo <tj@kernel.org>, Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v5 1/8] of: Add NVIDIA Tegra SATA controller binding
Message-ID: <20140718150603.GA7196@ulmo>
References: <1405500863-19696-2-git-send-email-mperttunen@nvidia.com>
 <1405667500-7402-1-git-send-email-mperttunen@nvidia.com>
 <53C8C9BD.3070709@nvidia.com>
 <53C8F6E6.6020901@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <53C8F6E6.6020901@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 12:28:54PM +0200, Hans de Goede wrote:
> Hi,
>=20
> On 07/18/2014 09:16 AM, Mikko Perttunen wrote:
> > So here's v5: this time, as suggested, I handle the sata clock myself a=
nd let ahci_platform handle it too, leading it to be prepared+enabled twice=
=2E This works fine, and allows us to remove the DT ordering requirement.
> >=20
> > I also have in the works a patchset that adds the name-based ahci_platf=
orm_get_resources function, but that is not quite ready yet, even if it is =
quite far along. Also, I am going on vacation and returning on 28.7., so if=
 this v5 is acceptable maybe it could be merged for 3.17 and I could work o=
n the new get_resources scheme after I get back from vacation?
>=20
> Yes that works for me v3 of all the patches with no newer version +
> v5 of patch 1 and 7 are pretty clean and can go into 3.17 from my pov,
> Tejun can you pick these up for 3.17 please?

Tejun,

I think the following patches can go through your tree without causing
breakage through unresolved dependencies:

	[PATCH v5 1/8] of: Add NVIDIA Tegra SATA controller binding
	[PATCH v3 6/8] ata: ahci_platform: Increase AHCI_MAX_CLKS to 4
	[PATCH v5 7/8] ata: Add support for the Tegra124 SATA controller

Peter, you should probably pick up

	[PATCH v3 4/8] clk: tegra: Enable hardware control of SATA PLL
	[PATCH v3 5/8] clk: tegra: Add SATA clocks to Tegra124 initialization table

and send them off to Mike for 3.17 if there's still time.

Stephen, the rest of the patches would probably best go through the
Tegra tree so that we can handle the dependencies there. I've already
sent out pull requests for 3.17 today, but maybe Arnd and Olof can be
convinced to take one more.

Thierry

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTyTfbAAoJEN0jrNd/PrOhqksP/RUaZd/72w+68XWcMveQTbOW
q8bW66jCALkUTJ4MOC807toKPD60VXyPKOEVpCvAdkr6tUFU8EbGgUAVlde3KMhG
AVlY7A9UCMwSNxHKAlCIzk3wLiStFKuU70B5JWVBcS6Is9yLkIFviyfcENN0flU6
9MMuobbNvRI0wJXE1dXtILqd5alqZl+L4/x3sSeoaAnmpaVYxJfdtnDJU2k+AK4R
Cad3g6OyOB0TXOjeRUnN++tT4CkaWnVE1gGl+aTG3ECFJLiI1YNXgll1YEY3Y9bx
dkQUv7MiwmZvjrxTMtmxQmCruyhrzGDg58mAPTJ+zpGEyaDehYyjBbUKzn+0s7mO
yofIXEDaq5coU35om4pjgl+WVQEne+v5UWZ7PE48BI0C7D5y0B32/PdYlMAyaH5V
ENEZXIOuTwRVJ3asgEvUo8rjDOQMHKseV+CJPIw0PQhuyxKQJQdaq8ee2VqLbuDt
Ip06o/fDbKgA7con6sWvw4VsmjIDfXiiveGVNFQrRfgJkJSw7OUOyG/F48erkyDd
Q+du1olR+j38ZgLjv/6e9wSU8EYo8AEkAJBwna98CvdsZoNEAz4Kh2SlDBdL9c0K
WvyGesxE/Pm0w5HUYjXfCQc4PmAaiMp9DUElAVnpPhPaDuR6Txc0wXdOGOdjGcDS
361mlgub+rMHt84K05Mi
=Ihqj
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
