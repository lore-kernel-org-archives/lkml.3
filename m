Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050AbbAILfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:35:04 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:55718 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870AbbAILe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:34:59 -0500
Date: Fri, 9 Jan 2015 12:34:56 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-pm <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] treewide: Convert clockevents_notify to use int cpu
Message-ID: <20150109113452.GF16465@ulmo>
References: <1418254133.18092.22.camel@perches.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DEueqSqTbz/jWVG1"
Content-Disposition: inline
In-Reply-To: <1418254133.18092.22.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DEueqSqTbz/jWVG1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 10, 2014 at 03:28:53PM -0800, Joe Perches wrote:
[...]
>  arch/arm/mach-tegra/cpuidle-tegra114.c |  4 ++--
>  arch/arm/mach-tegra/cpuidle-tegra20.c  |  8 ++++----
>  arch/arm/mach-tegra/cpuidle-tegra30.c  |  8 ++++----
[...]

Acked-by: Thierry Reding <treding@nvidia.com>

--DEueqSqTbz/jWVG1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUr7zcAAoJEN0jrNd/PrOhrsAP/iWqYSubPYR6Plip5QDe/QoP
9bcbtfr5b+PsC/H1evIRrWKNo5E68ZZNJpA4FfPSGs1NAqqfl0/7fG1s6j2E38dG
UWwLGFQ/tzRJht0SzbehEIef8ZZ0w2Y9dmVoriQoQq0FjHJqbG3zf2tsPFkztIvI
+zaOSc/FHTH6lN2fjqbySFT6+NF32Hx4IoO4pKrp2upqMh7LiWaAt6h6RE8Xb84o
3eu0Ooyqc8g1vHmZu4vGB7eQsHHF3l3DBEdKLrnXaJXd92RlzQFy/rhoN2A+rClr
kadKPbfH8HV4ENG1l5j2fPhzx/rsZMI1KLgKssm1xbGF8tPUromdroL3VuayI+y8
WEO2LoXUb3RH5zh6QarQvZyCPzDba5s33sk8Z03NoazTtp1ldAE29UAORrzfdEFq
YCDExJsxFZwYT1bkTvlMKjeL22SAh3LKiJuTCerqGvRZkAwVZnmdsTmnxjcotWRC
SZvIJjoAbkanqyUZN7Jrz6Txl37ZPET6dZxFcqLXDoiPfAJ3H3rYVp8d6fSejcH5
N2x8wGwwkWLQScxRVRv0aQsERpT6UHfYyADVBMPIKz2OhRXoy0nCSdFtB7KsY43r
FxeOEM9JQvuuIiH/NsoNR19613E7pboA00siPF8QPyIE93JB9rSIQgqkK4SbbnL0
Iumq7l9GgNhbA6mm931L
=XFHi
-----END PGP SIGNATURE-----

--DEueqSqTbz/jWVG1--
