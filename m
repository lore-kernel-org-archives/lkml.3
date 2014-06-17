Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbaFQMQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:16:30 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:51348 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbaFQMQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:16:27 -0400
Date: Tue, 17 Jun 2014 14:13:15 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, tj@kernel.org,
        pdeschrijver@nvidia.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 6/9] ARM: tegra: Export tegra_powergate_power_on
Message-ID: <20140617121313.GE18816@ulmo>
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
 <1401881559-18469-7-git-send-email-mperttunen@nvidia.com>
 <539F691E.5030204@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N1GIdlSm9i+YlY4t"
Content-Disposition: inline
In-Reply-To: <539F691E.5030204@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--N1GIdlSm9i+YlY4t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2014 at 04:01:02PM -0600, Stephen Warren wrote:
> On 06/04/2014 05:32 AM, Mikko Perttunen wrote:
> > This symbol needs to be exported to power on rails without using
> > tegra_powergate_sequence_power_up. tegra_powergate_sequence_power_up
> > cannot be used in situations where the driver wants to handle clocking
> > by itself.
>=20
> Thierry, are you OK with this change?

I would've preferred tegra_powergate_sequence_power_up() to be used
consistently in all drivers. I'm still not convinced that using the
platform AHCI driver this way is really the best option, since we're
bending over backwards to fit into what this driver dictates. There
shouldn't be a need for that.

Thierry

--N1GIdlSm9i+YlY4t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJToDDZAAoJEN0jrNd/PrOhXZgP/1DceJVj+uh4kKD+QqfGQx1F
LTrke4gSvl4ARr4oaQeJW6pnrGi3aUO20mQicHZtU44cGJSWl3MDtQMeskeBYqxJ
b6zUyz+jnSWPiHbKDB4sb+hSmXRsUbIaZQvHfFCusLHhVGiOVLuyk8smWPnKl7CT
Ju+DvRg+aQao/VMKI8ki43LolpwCAUqTXcqV0JvaaFut0vv50Tyxs33FMvo/5egj
DRhOLI3YNz6cNcKBL0lVpW54RECpt/j5ES/H+BLO1yw0Au4xUrYv4hF8XfLWyfGh
qPlNdP+3JeV9sD/wCYQGxEpiljEvwzbB0b9+bV8AZf8yMeq9Hj6R/9A7ojOfSFwf
Jk0A+3RFvkoxfoIsGyU4kRiAf0luV0wK558Z2V+qyyw7kZkyZR8T99O79iTJ2HPY
PfI10/rYikenWNg7u4V2xI0sq3fxkBOaUYmqC6VDgHE3jZuTPyUVbKXBIvJgKNgj
9wrnskRF2DAKsHeeV/Yi2DdnUz5M4JopTzJop/1h0uco8+Qwu73PW+1iJAR3HvHN
TfnIOsupD2l5hmXu04pQLEAcp+KZaAa9Otb61MJiqcFvTvzJZ9/BWdyUdrwEQAg7
yvWwjSeaB62bGMl0bBLMWdsINbm5bBIW+3Fg2Mwf6Oxumkayau9SjGHXWd0El3jG
sCR4RRxAqQWWgF4sHMxr
=N5eq
-----END PGP SIGNATURE-----

--N1GIdlSm9i+YlY4t--
