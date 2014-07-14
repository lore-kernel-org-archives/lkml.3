Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbaGNSID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:08:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37262 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaGNSHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:07:53 -0400
Date: Mon, 14 Jul 2014 19:07:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Harini Katakam <harini.katakam@xilinx.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek =?utf-8?B?VmHFoXV0?= <marex@denx.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jingoo Han <jg1.han@samsung.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Michal Simek <michals@xilinx.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>,
        "harinikatakamlinux@gmail.com" <harinikatakamlinux@gmail.com>,
        Harini Katakam <harinik@xilinx.com>
Message-ID: <20140714180718.GL6800@sirena.org.uk>
References: <1404982207-4707-2-git-send-email-harinik@xilinx.com>
 <CAMuHMdXO-PkQ+07F=aZEjvH1Kh7uhWK8i3V9w+1aHvvtg7wDoQ@mail.gmail.com>
 <CAFcVECJ93Lw1MRVU-=zLRbB6To--zmAxz8OLObu=mhV84-FTNA@mail.gmail.com>
 <CAMuHMdU2HyCwXBJTAyswyj7XqhzhHQ24MamGLLVgMwU4xi0kxQ@mail.gmail.com>
 <CAFcVEC+-bM91WmfwweDdTvJ7KwH+dxKDLkzsT82snWKhukLeYQ@mail.gmail.com>
 <20140710120120.GD30458@sirena.org.uk>
 <CAFcVECJvvch9Li0WihqoWcGNMMDVXfrujLUq6wvca46FztYpzA@mail.gmail.com>
 <20140710150713.GJ30458@sirena.org.uk>
 <03CA77BA8AF6F1469AEDFBDA1322A7B748213306@XAP-PVEXMBX01.xlnx.xilinx.com>
 <10e00662-1e08-4552-aae7-1e2029e56238@BY2FFO11FD051.protection.gbl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9JSHP372f+2dzJ8X"
Content-Disposition: inline
In-Reply-To: <10e00662-1e08-4552-aae7-1e2029e56238@BY2FFO11FD051.protection.gbl>
X-Cookie: Above all else -- sky.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 1/2] spi: Add support for Zynq QSPI controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9JSHP372f+2dzJ8X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 14, 2014 at 07:22:24AM +0000, Harini Katakam wrote:

> As per your suggestions, I could send this driver in multiple stages -
> Initially, qspi driver without flash specifics (this will work straight-away for a single flash)
> In the next set, flash specifics changes for dual flash configurations (parallel/stacked)
> Is that acceptable?

Yes, that should be fine.

--9JSHP372f+2dzJ8X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxBxSAAoJELSic+t+oim9OBEP+wUY1itsZhpeEcXkgSsPvTwD
mb3NuQyDYfI1Yr+VzifJF4Wrf2WembQr2zhFqNceC9NHB98uSFih+cK88NYHU/p4
iGK/leChsv3LxX3muVPdohhdI+dKFTdlJyytY7NauFr+hPQjQ8zdo2m+/upxbHjE
KebnKSdHH4D1ihuhBfVn7bByIvHfHPQfdhxSliC5RUtqlygyVBmyOeIzeNKB4irB
1qOTuXgtBWq+7JzWS429Kn8f+H42CpXtdMMhJZwQEfO1NoRtHU/afxGHKUjW8XoS
3GQujHyRLBapCRdJETjQpo737dHGQMNVcoEQe+pn+eYhgJHKkWm1Dq2P0cxs/S9J
FhjajJWFYQirMpfUAFWeKQQ899l5o8iwWWTqAvmuAl1IkE9N9CVofqyhDbY5sPT6
rtpk/z9Pxa/5WUvIU25fRXyLbXs2iKy23xbOk1Rwa6VhC+lUKnP+ApLRIEpa+1LV
0PqBJmb4f+eFgpfhrY7jEaB/XSHJ3+nzQ2zHKSwZc7utWhrEdTFAk+5w91IskI+N
R0+2afsNnM0HmKmsnm/jMSgi7aeQXwVoXazNgO+cjTj4XRFKB/2cvjf8QfUvrUHD
lqFNCvSN1Av36ZYUoy4OQxDty/wKjKX2G8lRKQhzhUodVn5K5A5k6sXi+SIkLTOA
K+ZJpy8AUhfCBBCAoMDt
=iIgl
-----END PGP SIGNATURE-----

--9JSHP372f+2dzJ8X--
