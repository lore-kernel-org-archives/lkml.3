Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3KNLdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:33:41 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38530 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3KNLdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:33:39 -0500
Date: Thu, 14 Nov 2013 11:22:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kmpark@infradead.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <20131114112209.GF26614@sirena.org.uk>
References: <1384328457-5147-1-git-send-email-k.kozlowski@samsung.com>
 <1384328457-5147-2-git-send-email-k.kozlowski@samsung.com>
 <20131113131328.GF878@sirena.org.uk>
 <CAH9JG2U9VDnRW9JZ7j7OyRmVhSXWJ5Yp_gNqUPK=xCST7SY=xg@mail.gmail.com>
 <20131114102419.GE26614@sirena.org.uk>
 <5284ABBF.3080802@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H4SyuGOnfnj3aJqJ"
Content-Disposition: inline
In-Reply-To: <5284ABBF.3080802@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.58.211
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] mfd: max14577: Add max14577 MFD driver core
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H4SyuGOnfnj3aJqJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 14, 2013 at 11:53:51AM +0100, Marek Szyprowski wrote:
> On 2013-11-14 11:24, Mark Brown wrote:

> >Modern systems should be able to use deferred probing to resolve these
> >dependencies, subsys_initcall() is mostly there for legacy reasons and
> >new systems ought to be able to move away from it.

> The main problem here is usb gadget subsystem, which simply doesn't support
> deferred probe yet. UDC driver (which uses those regulators) need to be
> initialized before usb gadget driver (i.e. mass storage or cdc ethernet)
> has been registered.

OK, that makes sense - OK for the time being.

--H4SyuGOnfnj3aJqJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJShLJCAAoJELSic+t+oim9O7wP/i/S6MlRbrkVagYbN+1szozk
sp+X+7zylFLmh38lkvA2yiYq+274BfrUzoTwt8RF3uuczU6QzRfkkQCYlVijMAcJ
AcYZIqgG0pitDUJ16W0OsAqpRufXgwd0SuQXSiQ4i4PCRIt//1IPk3yVQ8o8Rrnd
w1S0BspPGMODx5ACUMlhXy7H13mU28smIHyOHxvA3s/NLMdft+CwFV/9//S5qc3L
loTTsN0gpT1k0ctfTd6157k1HgE+01gFIgDdK/3P/olbEPuA2P/0/wB9pq6zri5F
6nhdaLXQFcjIdCrKiCtfw0sSZSPqK6PXOeq6ip1BrUq80wYOitEha8Akp2h7btX2
JW8ENaY32q/g6odwPnxvVrBPC2V3DHy9yWtcmD82IS7qge0o3aQqfrSZk0q4fq+T
VrqcmM5y27IrYeJzl4ZDw8sRa4ZR6FCuwdCzTth+ZIuRpUhtfrGg1k6qr2kFgzG0
QWujbtXd1oAeSQsy5e8AW7G9a6qCkKHU0Iob3VGHjVdds0Qe4qp7FyVowNXJWtQ2
Fn9A6HR6CV3N//UYb9k1/9rPGVL5ZVlDM7yC3NEQNb3QsupPDMksHX/GWMWKHa7i
WS/fjf3XsdGyJd38+plMS6kXR5CD1foteFYl3eQEoHV2UuWUxUeaipbVLZkFGdxp
QMDzRCApsm4pTY+Nk/J1
=yx3B
-----END PGP SIGNATURE-----

--H4SyuGOnfnj3aJqJ--
