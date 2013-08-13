Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab3HMKDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:03:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57867 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab3HMKDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:03:53 -0400
Date: Tue, 13 Aug 2013 12:03:49 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Bjorn Helgaas <bhelgaas@google.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 4/9] PCI: mvebu: add support for reset on GPIO
Message-ID: <20130813100348.GA28762@ulmo>
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376333215-12885-5-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130813080956.GE9316@ulmo>
 <20130813103030.1e4156a1@skate>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <20130813103030.1e4156a1@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2013 at 10:30:30AM +0200, Thomas Petazzoni wrote:
> Dear Thierry Reding,
>=20
> On Tue, 13 Aug 2013 10:09:56 +0200, Thierry Reding wrote:
>=20
> > > +- reset-gpios: optional gpio to PERST#
> > > +- reset-delay-ms: delay in ms to wait after reset de-assertion
> >=20
> > I remember some recent discussion about this, and we now have this reset
> > framework, so perhaps it makes more sense to use the reset binding for
> > this? Cc'ing Stephen (as part of the device tree bindings maintainers
> > team) who was involved in that recent reset bindings discussion.
>=20
> I also thought about this, but the reset framework seems to be designed
> for "reset controller" IPs, i.e special IPs that are controlling reset
> signals. Looking at Documentation/devicetree/bindings/reset/reset.txt,
> I'm not sure to see how this would apply to GPIO-controlled reset
> signals.

See:

	http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg36900.h=
tml

which seems to have carried over to this at some point:

	http://www.spinics.net/lists/devicetree/msg00521.html

Some of the messages in between I can't find in any archive, sorry.

Thierry

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCgSEAAoJEN0jrNd/PrOhXqQP/00k9qpbbGmfxex3TNrgv2Is
ocoESbsytg3Xz4eBN12343/Yc+goQeKF0W0yumiMceW8JsQ/u2J9x0YMIrHvPMFC
abbcGgLsTdgs3IBgA1hYeFMCjSTzTeFtNEYjDTzJQY0+hVCVWlj2SOZQqeX/DZ8w
GPxmeelIHUOxHEAsyCSiDu2g3DD8TJ0N3y3mSTuD2nFrgysgtfrhwlFeEeLfF4UU
rkmRVLMPyFGN0AlXckrIkDk/BG7cyppM7BwhqtsigHmrt2yCQjXpA+ML6I2AAqvR
LPW0obWNl+Mn4smudv49XiIc3+MHnOVtq+0NoW1YemXIJ49ggKXpoeLF1whg38VM
m4O0qNoMCul/xv+RPCh5QgVY+vWdlG/8YWU4DZTXT+IhYti7xzY1+iFb3bHds0uC
BNNouYq/pTrr6atjX4fTNZNxnN15eTJqiKvxBx355TUkMQbuJ/EKvaDXWpALbyVc
Mn420vIa/X2f7INmjZigKDKDLEAzZUOGzLQLKErJBjW2qWP/ADzfr5lS/xRC4IFg
9r40/MXSJDx1/V6hpLKRI+hP+cjkdcqNrNThJeVa1BMKniB7pPu08lGEtWhknGsv
Ab//4nOjKv07qWJUcCDzRKb8jLO2nTxfunQNTlTlAchjDfysTjZJKnW+cWOzya00
vrz6kNWJzKQGdNc4xmag
=+4Qp
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
