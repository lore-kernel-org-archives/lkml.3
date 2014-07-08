Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbaGHNIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:08:34 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:42662 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaGHNIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:08:32 -0400
Date: Tue, 8 Jul 2014 15:08:28 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mikko.perttunen@kapsi.fi>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        "tj@kernel.org" <tj@kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 0/9] Serial ATA support for NVIDIA Tegra124
Message-ID: <20140708130827.GD9516@ulmo>
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
 <5390A8F9.2090408@wwwdotorg.org>
 <53915F3B.6050806@nvidia.com>
 <5395FE0E.80105@wwwdotorg.org>
 <539601B4.1010707@kapsi.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qFgkTsE6LiHkLPZw"
Content-Disposition: inline
In-Reply-To: <539601B4.1010707@kapsi.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qFgkTsE6LiHkLPZw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 09, 2014 at 09:49:24PM +0300, Mikko Perttunen wrote:
> On 06/09/2014 09:33 PM, Stephen Warren wrote:
> >On 06/06/2014 12:27 AM, Mikko Perttunen wrote:
> >>The only compile-time dependencies here should be that:
> >>- patch 8 of 9 which contains the actual driver depends on patch 6 of 9
> >>(though only when building as a module) and the efuse series
> >
> >>- patch 2 of 9 refers to the DT node called "padctl", so it requires the
> >>xusb series. (in the submitted xusb series, the node isn't actually
> >>named, though. I will fix this in v2)
> >
> >Isn't that dependency a run-time dependency?
>=20
> Well, the kernel will compile but the DTC step will fail if building for
> Tegra.

Since this is all changes to the DTS files, we can resolve that
dependency in the Tegra tree by applying the XUSB padctl series
immediately before this patch, right?

Thierry

--qFgkTsE6LiHkLPZw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTu+1LAAoJEN0jrNd/PrOhj7QQAIOU3dS9fHLxO3APHgY4UoB2
X2pqiQ9q+LP6A12iyV1u23CX3N75UuHDoJ0U19x/iBWYUt2e6hO8Qa2nBuIU6ymS
lOpqZ2aCI21oDMy/miO/og9RagzjJ1WqBOkrSpztr78BKcN1VSqzVEr1pD7ollbP
/4D0OrgNFpa5cCQILtCSMmBHiIV+i9K2YER4lrAi1ssadTX8OYogYh/Cauxl34Z5
ue7+1+HXDnkHQYyQ9MGwuk1vVxhD4J6GBYd7KXZus6ZzATwEWVUp8EcAJQ2HtWxy
QKG/QpY1iCOZZTnjy6IeGrDxvK5NKsMVbrV/ygNBs6Cw2aZ03ycWGZT47eKRfCpQ
6NNJadOo9Y6M+aHBH/7z0iVs/hz55/frLfFYG1MsrQBe3UaGzviG9WH06eVujw7i
wniLNevXJjJGW+FfSOYVcU+d9E8CQdI/YFq98yBQY88orLkDFCZYXEDoStF8CbC6
3gl6Y5LEPD+tsG5F1g7lmMQD6o6VpUJK0WcWHsdp4mF542kc3FxkaQ+EEonMfOiA
PM2OFM47ihV3yxKtUzqgSoE+RaY4/xAsEvPdh+EXBgQtp7H/QlQyL1pt8gL3ZPLZ
5TEM31fEpJr09agKPf8wJt9aAo40aqvaFtk5Y5SzIJpniSFWba2HS9FRWmxC172D
wFS5/1i2rBT3uWeFlhsv
=y0c1
-----END PGP SIGNATURE-----

--qFgkTsE6LiHkLPZw--
