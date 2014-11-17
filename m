Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaKQLHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:07:23 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33704 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaKQLHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:07:21 -0500
Date: Mon, 17 Nov 2014 12:07:16 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: swarren@wwwdotorg.org, josephl@nvidia.com, balbi@ti.com,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3] ARM: tegra: Re-add removed SoC id macro to
 tegra_resume()
Message-ID: <20141117110715.GB25699@ulmo>
References: <1412947487-24287-1-git-send-email-digetx@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Content-Disposition: inline
In-Reply-To: <1412947487-24287-1-git-send-email-digetx@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 10, 2014 at 05:24:47PM +0400, Dmitry Osipenko wrote:
> Commit d127e9c ("ARM: tegra: make tegra_resume can work with current and =
later
> chips") removed tegra_get_soc_id macro leaving used cpu register corrupte=
d after
> branching to v7_invalidate_l1() and as result causing execution of uninte=
nded
> code on tegra20. Possibly it was expected that r6 would be SoC id func ar=
gument
> since common cpu reset handler is setting r6 before branching to tegra_re=
sume(),
> but neither tegra20_lp1_reset() nor tegra30_lp1_reset() aren't setting r6
> register before jumping to resume function. Fix it by re-adding macro.
>=20
> Fixes: d127e9c (ARM: tegra: make tegra_resume can work with current and l=
ater chips)
> Cc: <stable@vger.kernel.org> # v3.13+
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---
> V2: added Cc's for lakml and stable, added "Reviewed-by:" Felipe Balbi
> V3: changed commit description, tested on real hw
>=20
> PS: It wasn't a bug in my emulator :)
>=20
>  arch/arm/mach-tegra/reset-handler.S | 1 +
>  1 file changed, 1 insertion(+)

Applied, thanks.

Thierry

--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUadbjAAoJEN0jrNd/PrOhgvYP/0gMw+NlLHzSQa8IZ71mIFM3
i+vvvprPeQuYUogtVduFyaL2zbcJndzxOGu2kc4JMm1fqnffRMj6b9Bn0o5fj4vO
WZ3jvhtDG2ZPVS9WpKcCIzctgQ/zg6eBZdY3PA/aL8GiZY8H3EqdF5+/xym2fk+N
IPi24x3TWo2oyD2w14568nDYrO5N53Q1e8AXkLh7zqQLWmO/VPz7PmgUJepbMyIt
2/iesaOhLrUIYxBmcA7JWdaOJsgusvHu5JIEpPDij7aevJUUby0Pe2HNwQeY2BCb
rSBLphMH04LLZVBcUUleLXUSgq8xzug5JF/j/UJsQ9fAuYWvHmIjygP3ggxLvANj
gTQdGFbBadDfZBLbWCuGSH9J/7ZQ8zD9tjabwu164UhS6W5rZWmCDXx+JdIf9KeX
Jt+zxJH6HL0Wcp7IeQBggkWabM/xXeEJ0ziDJYjjTgYRMg3Y1HSqWhONQk0HPluY
7gsb+XCw8mfLJv18/a8yhr0sVs0ujY2soLEXVKOlpbEo9xZ97xBFPTTBnVSTr0gg
OLuekBxQeVDOpgcmp/XFzSyFYgy65eZLmNYdnK02HfleiMqP78p0BBB1GytESVJ8
X43uD4Df++zY+xYjTnVJtNWtPpANO4H4TGDvBao5E7GJF0yt+iMvzr9pQUB7lgiI
VWC1RE1VWEFAhHeyhCOt
=GAtz
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
