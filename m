Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022AbaLPLwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 06:52:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33197 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaLPLwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 06:52:41 -0500
Date: Tue, 16 Dec 2014 11:52:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Kevin Strasser <kevin.strasser@linux.intel.com>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mengdong Lin <mengdong.lin@intel.com>,
        Yang Fang <yang.a.fang@intel.com>, linux-kernel@vger.kernel.org,
        Kevin Strasser <kevin.strasser@intel.com>
Message-ID: <20141216115228.GQ11764@sirena.org.uk>
References: <1418282517-851-1-git-send-email-kevin.strasser@intel.com>
 <1418688904-26959-1-git-send-email-kevin.strasser@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sihESFlf63f/fzF3"
Content-Disposition: inline
In-Reply-To: <1418688904-26959-1-git-send-email-kevin.strasser@linux.intel.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: Intel: fix possible acpi enumeration panic
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sihESFlf63f/fzF3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 15, 2014 at 04:15:04PM -0800, Kevin Strasser wrote:
> A crash can occur on some platforms where adsp is enumerated but codec is not
> matched. Define codec_id as a pointer intead of an array so that it gets
> initialized to NULL for the terminating element of sst_acpi_bytcr[] and
> sst_acpi_chv[].

Applied, thanks.

--sihESFlf63f/fzF3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUkBz7AAoJECTWi3JdVIfQ4rkH+wenNgiZubjVpz+styGfMhR6
CkhWB9EKg0Dp/OKp1127JvYWcPriHY7v4j9x9tj9T+1Didmd/F8mTl/GHvG3o9CL
OVFUe6T9eenr0nwEVtnCI+t4Tew7MXGIxd8br51InkegMwDftNn4mrnW0vmPRG6Z
uCmN6Blh8XLwnbiGNAqA0jIFuM4ZK8alqlDTt7gPwnOcnvWqOhTLWtiOJMR7D2T4
1vwlD4YU7T1Md5GspGpiqGSzuOV8gsLYBBtL1A43auqFKEJLVw5siZ7gy6oW5uTs
qnb+beyvxP/SCj0u0mDY1ydFvFJiaILHI8b2ZDu7TZ+tQ6wOpaE9uq8U0+zSh/c=
=1Fu5
-----END PGP SIGNATURE-----

--sihESFlf63f/fzF3--
