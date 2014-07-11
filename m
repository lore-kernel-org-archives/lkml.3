Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaGKPPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:15:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58963 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaGKPPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:15:10 -0400
Date: Fri, 11 Jul 2014 17:15:02 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 12/13] cpufreq: Add cpufreq driver for Tegra124
Message-ID: <20140711151501.GA25810@ulmo>
References: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>
 <1405028569-14253-13-git-send-email-ttynkkynen@nvidia.com>
 <CAKohpom9ORXFiUU4=V+CxgN0ZOFLMEhEjHiU8HsYUYDybNXgHQ@mail.gmail.com>
 <20140711091207.GY23218@tbergstrom-lnx.Nvidia.com>
 <20140711145735.GB6523@ulmo>
 <53BFFEAD.7000405@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <53BFFEAD.7000405@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2014 at 06:11:41PM +0300, Tuomas Tynkkynen wrote:
> On 11/07/14 17:57, Thierry Reding wrote:
>=20
> >>I don't think that's going to work? The voltage scaling is handled in h=
w.
> >
> >Do we have to handle it in hardware or can we opt to do it in software,
> >too?
> >
>=20
> With the PLLX, voltage scaling is done entirely in SW. With the DFLL,
> it's possible to stay in open-loop mode and do it in SW, but there's
> not much point in that.

It's kind of ugly how we need to pass the address of the PMU and the
offset of the voltage control register to the DFLL which will then
initiate I2C transactions itself. I'm wondering if that plays well with
the I2C traffic originating from within the kernel.

Thierry

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTv/91AAoJEN0jrNd/PrOhFNwQAIXLfSWwPMY5HAIXrK8Ka1kx
t8Sl5AcX14LkS0dL8rOOal9z7DPBL1FuuDioHSkdSYxH8Cx+Sw+FEehffe4/v9/i
vOyXeHzp4SPw4t/fRSdnt0iwMV5RsCTfpK435mxy8NjO1gg1uIONiTEqyR1iXFCV
BsFirbkGIKyY6WObSpkwcjvEEZZaNFfChk7QQJuSzEKezAn2eOg8lCYNtj767afM
zxGpIKOYiA2hS2jmt2maunIfiOF3J/KY3Y+3y4zjnAmImCnM0Dc0mS1R8XwRfl4P
+ziB5VK83Cppaf+Ao0NVvn1TXJbuHAHT2I3yA0Ly/PMXzBhVAj5GTc1Ers8zhhfG
A4A13Fz/m4GKNhxqzU/3ouimZfHINRU6EXJnuXiA7QG64qRHAIgrEVK+rubeLkPM
OEIqSByjSjvIkuTEBN1568d/WTATC5dZGOaNA7w6VlrGUMBSJcBNMtWv44rGAS48
i3XACCdGa9o9YwQGiJwi2LZeQ+PsCBrC0hRtNCVyjuRakM3t/p/eoaEl/wzYKv46
V9t5SJr7O5kzPCGPGZd508OlpKbr8UbnqKSfWQfXMQ1on5uBIO3YLX/0dN7iCE47
ZNjA/9V1/KZgN5Sl255K7c8vx10WN4BK2sIOBXBO45MerzXEWTN0X1JrLGVTvJME
3UsBBt3F5CwYLt0KwDKS
=wrKt
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
