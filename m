Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaG2CZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 22:25:43 -0400
Received: from mail.kernel.org ([198.145.19.201]:55505 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbaG2CZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 22:25:42 -0400
Date: Tue, 29 Jul 2014 04:25:37 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, devicetree@vger.kernel.org,
        linux@arm.linux.org.uk, jason@lakedaemon.net,
        khilman@deeprootsystems.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bcousson@baylibre.com, tglx@linutronix.de,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 00/35] arm: omap: move intc to drivers/irqchip/
Message-ID: <20140729022536.GC4421@earth.universe>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="t0UkRYy7tHLRMCai"
Content-Disposition: inline
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 28, 2014 at 04:15:48PM -0500, Felipe Balbi wrote:
> here's another rebase of the original series moving INTC
> to drivers.
>=20
> There aren't many changes, only some fixes here and there
> because of recent changes to irq_domain and irqchip.
>=20
> I have also added a patch to enable INTC address space
> protection so that only privileged modes can access
> INTC's address space.
>=20
> Patches tested on top of v3.17-rc7 with a beagle bone black,
> the only plataform I have which still uses INTC.
>=20
> Tony, if you can run your PM test cases on your side, I'd
> be really glad.

Reviewed-By: Sebastian Reichel <sre@kernel.org>

for the whole series except of "drop ti,intc-size support",
which breaks the DT API.

I will give this a try on my N900 in the next days.

-- Sebastian

--t0UkRYy7tHLRMCai
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT1wYgAAoJENju1/PIO/qauI0QAIHmRdHvPeuA50WFg3RcNinL
WV1xTheSeSb41Y6tUlbfFSvCQLwmzUmYVgjj+eUyPUv+MtZix27O6QLUsPHCqD9G
ykZZxv1M+4olV8g3bX6IGt48ofKH50RdedcGaqYnNJj635pVHXRUu4X3PO/Q7XPd
Wl17YxFTlduKEAoByFLGB4QAraPZFc+SCwj3yZdDOQnmqprDrF0Nlg/3xP6FP/bV
EtCUiYkcfF9GuFFbOeFCHleXliBg0huDPWffzuT4dRBKkwnGHmbJydsMLO9mEos3
oGVA6F/nqm+whfYrnX9asa7qU+66e2lnUgTdLVCnaWbDZ2QutVVRcQQ5U/vbteVV
rBrmoEjk0yLAeSXhtUCp9/GOQFixgnYAt21rfcih55J8lQJrq8n/TvzL0xarE0o/
D2tn3zmZWp0YUFUuQRmwRqLF7vQ0orx19AZJAeW/tpxmatkJzLpO8enT2B8gJvjW
3m78WVN2DTGsj7YE0TSwifB1CzOJwh7Au4syreBbI8IgYWC4EGsgmMjmN5y/+b2x
QKQHikNTGEzKsZeAArO6PXdlcguudeALTyLFemw/ppXY9I2+WKsjG4c8Qxq8YhAN
Yq4LkD5Ef0jVryLYtWxO0r5u3iv40bTmi/1H1geVGY3mK3dS3C4y2SNNnpz5J+T5
z9gaRyicE6y3kaAvLQFs
=tS5m
-----END PGP SIGNATURE-----

--t0UkRYy7tHLRMCai--
