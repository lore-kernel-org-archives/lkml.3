Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbaGXJKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:10:14 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60329 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaGXJKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:10:09 -0400
Date: Thu, 24 Jul 2014 11:10:04 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 14/16] cpufreq: Add cpufreq driver for Tegra124
Message-ID: <20140724091002.GA3811@ulmo.nvidia.com>
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>
 <1405957142-19416-15-git-send-email-ttynkkynen@nvidia.com>
 <CAKohpomQthJ_XE-HhzW07Q4aVtxQVy97iaL0Vy6Q4Lhw22A=VA@mail.gmail.com>
 <53CFA33F.6030307@nvidia.com>
 <CAKohponLh66Ubr6=wY2OZCCrK11KZDj=DmXXqXsGGTHSG45wpA@mail.gmail.com>
 <53D00A47.7050203@nvidia.com>
 <CAKohponsS8WJy4qBa=3em9AcxfpfLZR_mx4Ln8N3Q_gBaf52NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <CAKohponsS8WJy4qBa=3em9AcxfpfLZR_mx4Ln8N3Q_gBaf52NA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2014 at 05:43:40AM +0530, Viresh Kumar wrote:
> On 24 July 2014 00:47, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:
> > It's this:
> >
> > +static int tegra124_cpufreq_probe(struct platform_device *pdev)
> > +{
> > [...]
> > +
> > +       dfll_clk =3D of_clk_get_by_name(cpu_dev->of_node, "dfll");
> > +       if (IS_ERR(dfll_clk)) {
> > +               ret =3D PTR_ERR(dfll_clk);
> > +               goto out_put_cpu_clk;
> > +       }
>=20
> This would search for clocks passed via DT, right? Why would we
> get EPROBE_DEFER for that? Sorry for the stupid question.

of_clk_get_by_name() can return -EPROBE_DEFER, which will happen if the
clock provider hasn't been registered yet.

Thierry

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT0M1qAAoJEN0jrNd/PrOh86YQAI3S6c9lir6DHUekyi7REuFx
7joUQ8un74bTj+c6jDOxHq14qConR0AXcvb3tOT8N696hBddSYeWfLv87iMEsQsA
xhZjd3dcgm/9jL1eHzjuCY9GrO7kMu6fGlKm854kTP2BPeWhp93X+aQzEtdw1qja
KdlXfZKvx6kObrDacZIqq88Ru0jZ+ZebJiKCvpkJac0lQ5AFV3voFKtQXjWdLcnJ
ebDZ4qhqixhernnpFzhWUxUoTZOFYevSlMI9T4XOubWEgcEn/lXjwI8N3KnGnpKe
zejX8qBWOmYAfsAxvHjIoC2PPjZdW9U81sOTQUl0H1vDhsV/pki7qSTFVrGcO7Bh
YoTg7YzUi81g5klG94dZ9nwEkLEzmJJWioHVvXx2cH52WPFqSRnL6NSc9huB2rZS
B8qNYtLLGBxFItSe5VR4XnbofzNQkUcbMRxDmRK7740K5OcdByoPb4NsGYRH9zCJ
yqI10am7VkO1+94sjBDUq0qcYeDCTjN5+3ujpyG6LnTFaEtpZa40dfB7tPwRCD3g
AB5zuGhL83U9wTkfm+lSfYMRtn+tDjO5H4vJ7AQpMXAsQoWT3pWDCzFfX/nYviQZ
GST6mlKYRcBVVBELwwYkgkmZTNEQXiW9uEvorIG3iENSMsZ4338RrTynztMdLg0h
Ei2gFch/Zy8Nj2NkhXBQ
=kWfZ
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
