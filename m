Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab3EQLDC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:03:02 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42321 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab3EQLDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:03:00 -0400
Date: Fri, 17 May 2013 12:02:41 +0100
From: Mark Brown <broonie@kernel.org>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Philip Balister <philip@balister.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Message-ID: <20130517110241.GI1627@sirena.org.uk>
References: <7c5e7537-6ed5-4622-a7a9-bf46820ef695@VA3EHSMHS033.ehs.local>
 <519124D3.2040403@gmail.com>
 <af51c63e-7ff1-4e73-9305-08309217ab38@TX2EHSMHS037.ehs.local>
 <20130514164611.10068.46384@quantum>
 <51927DEB.7090001@balister.org>
 <20130515044604.GA24524@sirena.org.uk>
 <51946082.1000606@codeaurora.org>
 <5194F0C0.9020609@balister.org>
 <20130516172605.GB1627@sirena.org.uk>
 <1b69c011-cab5-4fde-a61d-7e2536208920@CH1EHSMHS003.ehs.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZOudaV4lSIjFTlHv"
Content-Disposition: inline
In-Reply-To: <1b69c011-cab5-4fde-a61d-7e2536208920@CH1EHSMHS003.ehs.local>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZOudaV4lSIjFTlHv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2013 at 11:55:45AM -0700, S=F6ren Brinkmann wrote:
> On Thu, May 16, 2013 at 06:26:05PM +0100, Mark Brown wrote:

> > The binding should obviously be defined as a set of clocks rather than a
> > single clock - something like how we specify regulators on PMICs
> > probably makes sense.  Each clock can have its own properties.

> For a device driver as clock consumer, the bindings etc. are well
> defined. Just add the 'clocks' and 'clock-names' props and use the CCF.

That's not really intended to be used for enumeration by the child,
though - you'd at least need to define that the child looks through
the same binding to figure out what clocks to request.

--ZOudaV4lSIjFTlHv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRlg5JAAoJELSic+t+oim9sGMQAI6fZ9tF1kH8rNmPLw6SCsr9
GPJEeNspAA87Of5KYMN4zNGFDbggRyN3RYzIlX6VIxQqqzTNTZFy/gQaZDTxU6+U
dHBJtdWnJtIoCHyZ7PIcvwTop/hoP0QrSPoj4R6ecQlSYi6GNbVonC7vxgBn5cwU
wUGf1OShGAok+jGxWjtMxNwy9B2SJgEKIOs3BavXq8PpuPYpnSQlSgj1LJm4lE1k
jlYidvwcdYq//DBAo1XX9zE9vXOXjHWlR7K/ogXuWd+sM3zeCQ2aJ8zi5//q6KOa
Pj+ujvV1t5FT3tRh5iwoznwmjMNc+3TKudD2Vr1ri+FNGskM2f4ASzJJyHOtAnPF
ghGx9OQhbebAZwpJGtMolTcn4uRr6uJrlkeVVpBqJRVmkotcpos6m0vNKnFWyoCc
SywctRyqeW5GO8W+gRVTHUZ/Flg4TEMpTJGQd18F1r4EEsgZIXLnEBYz2nHKgQw2
kWb/XEfCGwdAxhXrMKTPLDfNu9MzMYjRqYaANe0qlNAhe7lAS3q+aYWvmgDy0cfL
JegaEpsPqguEsjpSj96cWhFynYZ9qrfK2ucF+oBamyRkoiHZKF/k2XEgHQEIbIr3
ihXafkfmU4xsIPi7Ud2GJRQ9davXHRlUguFZvvosedUDfmcPQ3uGAU1m8SFXYYG5
idDXhnonIpKbFPmEIToS
=mSci
-----END PGP SIGNATURE-----

--ZOudaV4lSIjFTlHv--
