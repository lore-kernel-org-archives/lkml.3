Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbbAVFMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:12:21 -0500
Received: from mail.kernel.org ([198.145.29.136]:54923 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbbAVFMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:12:18 -0500
Date: Thu, 22 Jan 2015 06:12:06 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Beomho Seo <beomho.seo@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, lee.jone@linaro.org,
        broonie@kernel.org, dbaryshkov@gmail.com, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com
Subject: Re: [PATCH v4 0/2] power: rt5033: Add Richtek RT533 drivers
Message-ID: <20150122051205.GC19172@earth.universe>
References: <1421899601-19327-1-git-send-email-beomho.seo@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
Content-Disposition: inline
In-Reply-To: <1421899601-19327-1-git-send-email-beomho.seo@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Thu, Jan 22, 2015 at 01:06:38PM +0900, Beomho Seo wrote:
> This patchset adds driver for Richtek rt5033 chip The chip contains
> switching charge mode Li-Ion/Li-Polymer battery charger, fuelgauge.
> Additionally, This includes document for device tree of RT5033 device.

Thanks, applied.

-- Sebastian

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUwIaiAAoJENju1/PIO/qa3bYQAJ9Ir4TKmRq6V+aicywjGOVi
jaOxLf4edYqORMSujuRYyE/CJAC3dbOgAhvId8oDEO74RrqqWhDTIWpJySCPjbsl
vWpuP0uPSXwIRfICLnUpigk4kmG6ZWQ2OwoCMCgq4BmRX1notPCxq3LK2wyrEA6g
H0apy57x/G8z24BWUB5ym1ojM+zpRTMacN9Wfw3wq1HtAOQ/8pzH5n1pepKW5hvL
IblAAFRDuGuBv89rXQ02x52MbqNdeqYOCF1jNSmyQoZzI8XQx6pBES1TpZGyKQHi
dp5jtYA5Q4eE5tbyJKJRcrrsPZUz5ZCPeRJyfdYmyhdvTNZV6d3BZYPc7U100s9D
NSev7hiLGdqH7pUhpB9+sgZ4Vsapo8WuLPjr2mVoutdh45Kv4QFYn1E7R+VLqKAb
vTsceKgIVdezKuCcK82MDJgsMRAM2ZEzo/Q1+qh6FgJsIWdHR6D03sQfRxf6oY1g
OLznqA42utioupn0y6QGs2RGV9WpQ09Ydm5P7qZGBL5n8xCWEXBPLD1vFBHk87xP
D51j7mlD0p0mzet7vdPGfWB5Uac6grVG3DiC45o5UnKJwvRCurdrHXmb03yiEyF+
mGArZ0kAjuXCQRnAVE0Q4bwez+845OcwRbjEiNHbuEMu6izxybxsQU1v9h0pEpz5
ntC4TdPlr9l3Mgsg573Q
=kqS0
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--
