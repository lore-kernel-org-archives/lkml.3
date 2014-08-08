Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbaHHJpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:45:34 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36216 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbaHHJpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:45:32 -0400
Date: Fri, 8 Aug 2014 11:45:28 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 3/3] cpuidle: big.LITTLE: Use of_match_machine
Message-ID: <20140808094525.GB15852@ulmo>
References: <1407452515-2390-1-git-send-email-ttynkkynen@nvidia.com>
 <1407452515-2390-4-git-send-email-ttynkkynen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Content-Disposition: inline
In-Reply-To: <1407452515-2390-4-git-send-email-ttynkkynen@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 02:01:55AM +0300, Tuomas Tynkkynen wrote:
> Use the new helper function, also fixing a device_node refcount leak.
>=20
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> ---
> Compile tested only.
>=20
>  drivers/cpuidle/cpuidle-big_little.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)

Reviewed-by: Thierry Reding <treding@nvidia.com>

--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT5Jw1AAoJEN0jrNd/PrOhv58QAJQ+7QEy+lCmrZl/FZxclODm
/SeF3BfFa9bn295JeerkH2mQAHRSpQhkvBvHjl2LNVLXE239mSbJBalB3giBb5N8
yFGiUJgd+h7ykYz1JkpbqC71Ko1IW3rTllM1WcjZM6TdASWIPtb32MIrvE0dMlyU
QB51RWYwnuu0b2CiVORAHiohUi0ay+rFCkcfZGf7mObgDVGuKwDtpVpnY2Y5Bpjy
L++wMbEwimJxoPoWNMeGYcV+v/L+EbjC9kacQORi2/49WpPKijZmBHVWIrwhqdEP
69SVDtUUbNxN0db/zvGZ/KqMwMvnaXmlvvj2qu9HWh98a554lrryhWtaBsKpJ3h2
Wv/nZe1hDBy+Fn+KVgTxN2iCRpjQsUkXlHmTBi7uLoGEemov7WXXWzN0olN0wjOF
MC9cXXZiisFhWBrY+92171LfmphT31XQJSbqseB9Bpia7rF2EMZVrHumz8GoKsMF
fmbY7GZKy7xW6nIozM0+fNoOjYeyOYN6FJFl8WwTb1qUvPuD6/4P328FEwcpYUPA
KpAO9ndYMACfDXr0QKUqZqGRSORKscw4Lr/SVeVOxgBUR0OOjucweBj2Tsmd3VQ6
y0sufdWRKTK4Z8Ah2rKuJDsQtWWIZkwAfYcHScD2w6RO4q3CsX2GS0XzswasV0bl
A8mG1laO1d8PsXbP4/mi
=To51
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
