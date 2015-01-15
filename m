Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbbAOLpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:45:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:32891 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbbAOLpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:45:43 -0500
Date: Thu, 15 Jan 2015 11:44:37 +0000
From: Mark Brown <broonie@kernel.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        atull <atull@opensource.altera.com>, Pavel Machek <pavel@denx.de>,
        gregkh@linuxfoundation.org, hpa@zytor.com, monstr@monstr.eu,
        michal.simek@xilinx.com, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        pantelis.antoniou@konsulko.com, robh+dt@kernel.org,
        grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, philip@balister.org, rubini@gnudd.com,
        s.trumtrar@pengutronix.de, jason@lakedaemon.net, kyle.teske@ni.com,
        nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devel@driverdev.osuosl.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Message-ID: <20150115114437.GV3043@sirena.org.uk>
References: <20150109205643.GA5761@amd>
 <20150112210134.687176ed@lxorguk.ukuu.org.uk>
 <20150112214314.GA18610@obsidianresearch.com>
 <20150113162847.2778b5a5@lxorguk.ukuu.org.uk>
 <20150113200032.GA16205@obsidianresearch.com>
 <alpine.DEB.2.02.1501131455130.30192@linuxheads99>
 <20150113222450.GA17475@obsidianresearch.com>
 <20150114160617.02fb9135@lxorguk.ukuu.org.uk>
 <20150114181258.GB16392@obsidianresearch.com>
 <20150115113617.537965b3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="v7CWsE/Dy737oYst"
Content-Disposition: inline
In-Reply-To: <20150115113617.537965b3@lxorguk.ukuu.org.uk>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v8 2/4] fpga manager: add sysfs interface document
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v7CWsE/Dy737oYst
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 15, 2015 at 11:36:17AM +0000, One Thousand Gnomes wrote:

> yes - there is a model for this in Linux already. Some of the audio
> subsystems have "firmware" files distributed which are actually a
> structured file that userspace parses to get a real set of firmware for
> the controller and a set of descriptions for things like mixer controls.

We didn't actually merge that yet (but we do want to).  It's likely that
the parsing of the files will end up in the kernel rather than userspace,
or that anything userspace is doing is mostly about translating vendor
formats into a standard Linux one anyway.

--v7CWsE/Dy737oYst
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUt6gkAAoJECTWi3JdVIfQ4yEH/AmhkGaqplZacrO2SqUdLw9v
Tgg940NRMGB3vZLtdA9kCGJ8xSuoO299yukTDb9Jrg3IkNSxbOISiooh31pkzqS0
we7p09DC3gKPiV2EvG4gFqz+Qbiy+S19Q6bnO2V2DTuviJvMNeCcW/GqNxGCt5Cs
py0NM0YEFUvfXnlgpK93/HL368a0cGey4/pfHUKRF++DcioPlKCCDTBxk1mDBzXX
EcTqCrYphmYfi9RkDeAkorvZFuMIoz5XHfLCiQ/DH4X3S7i1W326La0jMoP5LU8s
JvizzG9DtFawLqnRDiWbiAJUBF6Rz72J9ggep/SBvFSZexw/9T99SfyhHhrW0BE=
=rb+2
-----END PGP SIGNATURE-----

--v7CWsE/Dy737oYst--
