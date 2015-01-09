Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbbAINoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:44:25 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:35203 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbbAINoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:44:24 -0500
Date: Fri, 9 Jan 2015 14:44:19 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Paul Walmsley <paul@pwsan.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-tegra@vger.kernel.org,
        Allen Martin <amartin@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>, pwalmsley@nvidia.com
Subject: Re: [PATCH] clocksource: tegra: wrap arch/arm-specific sections in
 CONFIG_ARM
Message-ID: <20150109134417.GA5429@ulmo.nvidia.com>
References: <alpine.DEB.2.02.1412092201200.31750@utopia.booyaka.com>
 <54AEB719.5060103@linaro.org>
 <alpine.DEB.2.02.1501090135280.28771@utopia.booyaka.com>
 <54AF91CC.2090007@linaro.org>
 <20150109122120.GJ16465@ulmo>
 <54AFD688.5000304@linaro.org>
 <20150109133349.GA27876@ulmo>
 <54AFD9DF.9090205@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <54AFD9DF.9090205@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 09, 2015 at 02:38:39PM +0100, Daniel Lezcano wrote:
> On 01/09/2015 02:33 PM, Thierry Reding wrote:
> >On Fri, Jan 09, 2015 at 02:24:24PM +0100, Daniel Lezcano wrote:
> >>On 01/09/2015 01:21 PM, Thierry Reding wrote:
[...]
> >>>How about we do something like the attached patch instead for now. That
> >>>avoids any #ifdef'ery and still we don't attempt (and fail) to build t=
he
> >>>driver on 64-bit ARM.
> >>>
> >>>With that applied we can incrementally make the changes to untangle the
> >>>ARM-specific parts and when the driver can build on 64-bit ARM we simp=
ly
> >>>select TEGRA_TIMER via Kconfig.
> >>
> >>Yes, that is exactly what I was thinking about after sending the previo=
us
> >>email. And by this way, you also fixed the Kconfig option selection log=
ic.
> >
> >Great. Will you give your Acked-by so that I can take that patch through
> >the Tegra tree to resolve the build dependency?
>=20
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Thanks,
Thierry

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUr9sxAAoJEN0jrNd/PrOhPZ4P/RSrBkLBsWSduN+rh+SOohlk
plSDjOuWMrDPKPXkVgTZvSntpx/zRDQV4fw74toYS/BW+ftp1wmhFLVCNPv2uBGm
bj323LhglHa1raRrNfJmUBFLIiXVu6MXuvikT5EE7iLDGmw1CwFhWgFhjLncmRFT
ERpf8nhm5bVhPgmaVM59z+fDY89WjlNrox7tGbMQptbp2jejCmuFop2UqRy30OyD
317OHXYmK1QuiWg6J4IP/x6psIyNYawkCo1dwJo1wjxvzd/Iyxrso5PYnWPmgnzp
Os5CWm4amtBKLsdJMMrMCAxNXM1Nlvcq8Vx5aQTIYWo0QzJgTECP5w8aHaSl5B+8
Qzk1Rzx+CqOgnfhYKWs4jExG0sEeuITdxzZ0SL8ZOFJ2H5DgKZMesZApP+xS4Mqn
dA35fnP4gfvZ47cugV0CUmd1zT+5DjdYlomt1+VNnyy8lmSvfeggYve/kC5Xy1LG
K5xj/BAvXzDdxuqG/+xiyjmwYsaQpgBUI3VD25HPa4P9vAHCip7WMlW++n75izf2
MUg/lArP2cXuo6McUFUQF9LT/Rc2thRCqNRZDdcheZGZ/5iTUtudPlopaFdoFMga
z5pVeRRjOb48oxs11OWkAwuMpx/HxIn2PThpyPNSBF/2+TG5oYRKdeeYCaFKRZHH
ODZazRYGBnYe9ZkRUNqq
=RIXo
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
