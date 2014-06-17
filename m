Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965828AbaFQWMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:12:46 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:50730 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966802AbaFQVvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:24 -0400
Date: Tue, 17 Jun 2014 23:51:20 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 6/9] ARM: tegra: Export tegra_powergate_power_on
Message-ID: <20140617215119.GC24743@mithrandir>
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
 <1401881559-18469-7-git-send-email-mperttunen@nvidia.com>
 <539F691E.5030204@wwwdotorg.org>
 <20140617121313.GE18816@ulmo>
 <20140617140146.GH3407@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1ccMZA6j1vT5UqiK"
Content-Disposition: inline
In-Reply-To: <20140617140146.GH3407@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1ccMZA6j1vT5UqiK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2014 at 05:01:46PM +0300, Peter De Schrijver wrote:
> On Tue, Jun 17, 2014 at 02:13:15PM +0200, Thierry Reding wrote:
> > * PGP Signed by an unknown key
> >=20
> > On Mon, Jun 16, 2014 at 04:01:02PM -0600, Stephen Warren wrote:
> > > On 06/04/2014 05:32 AM, Mikko Perttunen wrote:
> > > > This symbol needs to be exported to power on rails without using
> > > > tegra_powergate_sequence_power_up. tegra_powergate_sequence_power_up
> > > > cannot be used in situations where the driver wants to handle clock=
ing
> > > > by itself.
> > >=20
> > > Thierry, are you OK with this change?
> >=20
> > I would've preferred tegra_powergate_sequence_power_up() to be used
>=20
> I don't think the current tegra_powergate_sequence_power_up() API is very=
 well
> defined though. I don't think the clocks and resets required by the seque=
nce
> should be provided by the driver. For one, there can be several clocks and
> resets that need to be controlled for a single domain.

Do you have any suggestions for what the API should look like? Even if
we plan to move to some different API, I think there's some advantage in
using it consistently if for no other reason than to make it easier to
replace occurrences later on.

Thierry

--1ccMZA6j1vT5UqiK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJToLhXAAoJEN0jrNd/PrOhTy0P/0+ybLkigRrxGtyi5IRqMQrO
DQI9VEE9HuNjiO+IIxSKwVndS7JGLiNW1QwA475v934Y2ifx0ygDanOkbTp9KwtV
kpSH1WMuaBUIrvaY11pRZjLzajD3Wddfl6WRcvG164FWV3EA05Fxpg4yxZt/lMR+
mNzvGZ6CXkYwiOyzXDBAbE2hZGnf+64L9vhAQtfo4jrjQyLj5Pq5nDEMr7FHSZTt
6Dc3yMf6o3uklgEojFOqzK0/MgbEiTZxV48nn5sD+0kaetQMxnx+iOnMM+qE1b6d
oME1faH1p9sQNjCorjWdQfCx846bEIO5gPPmrIIAwM7XXB1UEbstytE4JzhhTTP9
s3gD+MM04JZNqCweCD/sA+tsjKbIqIw3ACknWwbJXl+dvUS5wBn3/34i3YAR6Rrl
ryetVKFMO4CUVGqV1/hiFzfx0qLA10uUC5F4BwwXu6s9VKawXumGFy5bC2v4nuC1
IOgH9rZ3lgQ7o1j6naCT3InP24YoSk74EszPiALGu8pKGVoLUlB6blPNTRdLhmRj
eX0LCaiKPuZnXWYxd0/FACXO+Xv3x3Yg0pxtz3boqv+YV+aQ2Egcq6KbVmlJR/Ec
7RUJKnc+CQjccGEEzycqFNfAb5OjujVEkjl33/M8YcurjpTWGdJwSEO7EoZ/eHiG
Uk8X0ZLc40pxwngSueEy
=PfVZ
-----END PGP SIGNATURE-----

--1ccMZA6j1vT5UqiK--
