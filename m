Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbaB0TFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:05:05 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52093 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaB0TFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:05:02 -0500
Date: Thu, 27 Feb 2014 13:02:59 -0600
From: Felipe Balbi <balbi@ti.com>
To: Loc Ho <lho@apm.com>
CC: <kishon@ti.com>, <tj@kernel.org>, <olof@lixom.net>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <ddutile@redhat.com>,
        <jcm@redhat.com>, <patches@apm.com>, Tuan Phan <tphan@apm.com>,
        Suman Tripathi <stripathi@apm.com>
Subject: Re: [PATCH v12 3/4] PHY: add APM X-Gene SoC 15Gbps Multi-purpose PHY
 driver
Message-ID: <20140227190259.GC4862@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393524848-8207-1-git-send-email-lho@apm.com>
 <1393524848-8207-2-git-send-email-lho@apm.com>
 <1393524848-8207-3-git-send-email-lho@apm.com>
 <1393524848-8207-4-git-send-email-lho@apm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LwW0XdcUbUexiWVK"
Content-Disposition: inline
In-Reply-To: <1393524848-8207-4-git-send-email-lho@apm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LwW0XdcUbUexiWVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Feb 27, 2014 at 11:14:07AM -0700, Loc Ho wrote:
> +/*
> + * This function is used to configure the PHY to operation as either SAT=
A Gen1
> + * or Gen2 speed.
> + */
> +static void xgene_phy_sata_force_gen(struct xgene_phy_ctx *ctx,
> +				     int lane, int gen)

why do you need to *force* the generation ? Is this because of some
silicon errata ? It almost seems like this should be done through link
negotiation between both link partners.

--=20
balbi

--LwW0XdcUbUexiWVK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTD4vjAAoJEIaOsuA1yqREcU8P/3ZS9KNms08cXSMj1uAFPNFh
3CPHf7MFJI0kwNaeSIvsvsMf9FelziGBtxsXKTTBKgKv0LmyaNcz6XHj8F/GtAdE
hX6vjyB4ktxBFyU8VbeOkJqqddtVudEC/ZFl6iXxcVL6Jg3N1gEH/j8W4hosqyJU
STMaV0Hj7hp1pOrYeMCjvRgHEkkAY3q9xqnJp1+4/9Js7wXpvt/YSPKjRJ303k0N
dlCLy0vPNZiAaWZogdx+MvrJtpY3aOxKBHqSKTHmClaSrNlJVDUyHE6IT7ViigLM
Nck5qYS3T2OLuZbirGGHmMtk/cLWIDCoGaRRkp8XrNX9/6oJBhjPdqvEbJDRzbko
MqavfzzvhNXElWdxaVaWW0Hj51Fb+5k+kYuYoPOMNufDovpvjaFlzs7TJLcTkHy2
qUHjz6qjQQ7rWKb0ITw4oZU+3vSfFsDKHAe+XXzuG+gF+0Rs+4C0ZxcDiHPgJXgE
qLXt0vyX32Nd3h8ghb3UdstwWH7IYLjMna4vZ6rGy05SyOAPNHjZpPAL3QVHCTOB
sGV0JGBx7cE+uFqr1xmpCVyYAa9RDFOT3n2ZyFUWI5HIcWkehjEzDwcwgaYn+Vl1
xlr4IYmq4SMhSpREsaYalyxUximCSP9k8bUqFT1Oo/DxXqVOihcIX8ji8+0FM/M7
DHMC4kpgLzarods/i/RK
=cHF/
-----END PGP SIGNATURE-----

--LwW0XdcUbUexiWVK--
