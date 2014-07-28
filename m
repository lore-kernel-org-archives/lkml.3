Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaG1VUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:20:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55686 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbaG1VUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:20:35 -0400
Date: Mon, 28 Jul 2014 16:19:34 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <bcousson@baylibre.com>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>, <tglx@linutronix.de>,
        <jason@lakedaemon.net>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/35] arm: omap: move intc to drivers/irqchip/
Message-ID: <20140728211934.GK7667@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BFVE2HhgxTpCzM8t"
Content-Disposition: inline
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BFVE2HhgxTpCzM8t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Mon, Jul 28, 2014 at 04:15:48PM -0500, Felipe Balbi wrote:
> Hi folks,
>=20
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

meant v3.16-rc7

> the only plataform I have which still uses INTC.
>=20
> Tony, if you can run your PM test cases on your side, I'd
> be really glad.

for convenience, a branch with all these patches on top of v3.16-rc7 is
available at [1]:

git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git omap-fix-intc

--=20
balbi

--BFVE2HhgxTpCzM8t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT1r5mAAoJEIaOsuA1yqREoa8P/3yFDVndFOB2BFsMZAdgPvtm
+4JZSk94bhyD+LI9ztStBgwHJwRN3YJE6DJjXEx0RUrcdtxa7nUKBTN/bH0OqRp/
MZmHT3ixsMaIOFuwICW+UocQdrNCBCewlsuoqa8S72WedfAu6SWuHEi4GML4+sb0
Py6+8Cd/74FWaB5bXmKQvnhNbHaIwsfM7Do4N8SwIKumH/FTdnzrMZmyzTU+tMKw
nuYoR+uzaMS1408DXsOStfg+z9vWXYEJvdfKblyQ90YIkjLFtpnWgvw5S3xmAlXu
zEE6Xo13vXvY0ki5Fae1ipaVz2qrxIECOanj184sq7EGyxTX7gA0BFA2xtvjuJL3
/JXLDChRPYUm18aomba4p/6mgB0qal66if2yxICiSDgqzeL64NkJStxlXfRUh8qb
AaFeZEjiI25rgVW3XPow8ixfT0Ae06TpBIT3unJMxHPmATHyApLwFqdJ/Hzp9HPu
2l15XjsW1uiAnbMJAoka2VUX9x/IZRKFDm4LqyFgASy6eD5xC62uR5BuadwdJu8j
W4BIHKIYrZbgRRVPVwyKBmzqOk/H5tQN57R/Wjt0ep+4sQ3uQeh0RC/m0LvDtAdo
2aMKP02mNuR5k+i+XD9DKT6yOnncoLJrz1xcqXGSZzl512fSlhaVrVq6xhIx3Pdz
l0opTxUaA3AY27npsCRz
=Gfk1
-----END PGP SIGNATURE-----

--BFVE2HhgxTpCzM8t--
