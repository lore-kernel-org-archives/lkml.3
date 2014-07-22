Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbaGVJqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:46:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49121 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaGVJqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:46:14 -0400
Date: Tue, 22 Jul 2014 10:45:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Message-ID: <20140722094548.GP17528@sirena.org.uk>
References: <1404303560-32209-1-git-send-email-acourbot@nvidia.com>
 <1404303560-32209-5-git-send-email-acourbot@nvidia.com>
 <53B42B60.1000600@wwwdotorg.org>
 <53B4C9C0.4000605@nvidia.com>
 <53CD333F.2070805@wwwdotorg.org>
 <20140721211630.GA12076@mithrandir>
 <20140721225153.GJ17528@sirena.org.uk>
 <CAAVeFuKtVYNP5LFXGCEpkUtCCrK6AP+9WEVPDPs45RwAPvKKRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aRuUY7KzmetiZjaI"
Content-Disposition: inline
In-Reply-To: <CAAVeFuKtVYNP5LFXGCEpkUtCCrK6AP+9WEVPDPs45RwAPvKKRg@mail.gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] ARM: tegra: roth: add display DT node
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aRuUY7KzmetiZjaI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 22, 2014 at 01:39:51PM +0900, Alexandre Courbot wrote:

> I also don't think that would do it - for many displays the power-on
> sequence is not as simple as "switch all the regulators on".

> Maybe what we would want is to have panel-simple allow panels to
> provide a "probe" callback so they can request and manage any extra
> resource they need. This would of course imply that custom
> enable/disable and suspend/resume callbacks. Then the driver might not
> be "simple" anymore, but IMHO it would not be that bad.

This is starting to mirror the discussion about MMC/SDIO devices where
the talk was of having a property on the device saying which power up
scheme to use - added Ulf for that.

--aRuUY7KzmetiZjaI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzjLJAAoJELSic+t+oim9rIgP/3htcCCFA2hpukO16XqiGrqC
huwFO2DCA5zohaX3MsZxwIcdz65tzq+bjdjVUdyJgQNQIFmGwklrv/pU37lyeo31
NhHtj7gNXrF21RUkLQsEmlZy0hkDLL5AhPRGN5ISJzyhFCx8sEm3gNR8NonB/mDX
swqh+9HxBTET0QFSO/qtTO/H29zeBExwvA6fF9anJUJlCmjXuWdE3f7oTbg+GOvP
4Pj8i8F/gA+e4evSidtdtsWgBjQS4ECDaxAN1+X/uNi51MFcvZSQRus7Hnh6Qc/Y
vOfB/GGZdYXRON7ha2zzpGzsB7urCN4QgHyaPWEmqhpjrw54RDUZRc/CRx1h/tcZ
JfhVGfpriPJlS2mRqDsVvMD8suPGfo8kOsfgEajMSK4zuHZ49Eatkf8SwZG/Ow8b
BaKLy1XGSU0NaZO+P7qvfu7Dp5HwvMKNIRjwJsMZGOzBEkyVK4Ms1EjfKO+Or2/3
jKPEG54V822ahzvQe7+TlNZXoCyOey+SKQSsF+iYurXdkKyMG/PlwaedUTIO/Zgo
+fUOSngmeTd7BQAfqw1TVsRr/oDrEBckdIS8ZJdtVLvJLjQMCMhlUHmYI9VePrP1
rxMN75rcVSwgzQcLGNPfBZe2QxZ3ZDziMn3ntXwhruFUeKILDRJ8vx6X+DVGF0X/
3C/nbZq29Uhx8O1WIwoR
=lpi1
-----END PGP SIGNATURE-----

--aRuUY7KzmetiZjaI--
