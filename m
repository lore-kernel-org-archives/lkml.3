Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbaHLQ71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:59:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60169 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbaHLQ7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:59:25 -0400
Date: Tue, 12 Aug 2014 17:58:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140812165852.GT17528@sirena.org.uk>
References: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk>
 <1407861868-20097-2-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opPAX5Xc6j4THLmW"
Content-Disposition: inline
In-Reply-To: <1407861868-20097-2-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/6] ARM: dts: Create fragment for tps65090 PMU
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opPAX5Xc6j4THLmW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 12, 2014 at 06:44:23PM +0200, Javier Martinez Canillas wrote:
> The tps65090 is a Power Management Unit (PMU) used in several
> boards so the same information is described on different DTS.
> It is better to create a .dtsi fragment that can be included.

Why is it better to do this?

> +	regulators {
> +		tps65090_dcdc1: dcdc1 {
> +		};
> +

It appears to be largely content free, exactly the same effect should be
achieved by removing the entire regulators node.

--opPAX5Xc6j4THLmW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6kfJAAoJELSic+t+oim9VVYP/iUUHeUs610ceooZPqBP1L+s
f96QsZpIikhxYXW42eYY3IHxW2E82yF86quid6Gq+c9bdWQEWxuH1rS10BzYrBZX
Lvbk0fma844K8MNb06/gsfLTrr4eSK0/zZTeUWMNgPFSaSY/+9wN7cCKu8S9ilv4
43Ylehc2rvTBFYvQetf/Vdsth8gjthTmDhYrLCUpUiYifuaRth5PQnSR64Nhvl8z
bKoEwMKCFjOHMxrIVSn7xVVpeUv4+3GG2Ed+Sy//ZuRgBrNRT2npI1MHW+pRLq+j
MliFKetEwnKYSZ8mRDuN6acC2/QyIr/QatGZQx8HhO6DSGolhDQaMSv3qeIDitWl
yuNq52WHK+IgtpkjXRBvjkRrHYnIfOA/kVtcS+LM283Bq0uZaAc/vbXx0zPdYxve
Mr1e1wQx/7aaBFoURR7x55S4V1U6jFCwE3LmuJLBy+RvxPAhG8KVAeCUOhv4FMj5
nD0DZZImBXFdTz2hbXh2UD06lfhJ715eVILuuBKorMeFiqWjtcLwnUA+nZ0kU6pF
cogck/gGjlJqG5RfHIcLXasHkYJcWmuJVH+XdQnul3sQwyMGjF4BNGqmU6E1FjjG
S18vfl4/7uFryUZing9hiiraBd3f4oUDwzl6J2kzd6IR7uHw+W6wh4W4MsL6A/IK
Uijx9WTj3lEnRcQ2G9VX
=D5qG
-----END PGP SIGNATURE-----

--opPAX5Xc6j4THLmW--
