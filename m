Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbaJ2KR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:17:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54942 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091AbaJ2KRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:17:55 -0400
Date: Wed, 29 Oct 2014 10:16:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: atull <atull@opensource.altera.com>, jgunthorpe@obsidianresearch.com,
        hpa@zytor.com, monstr@monstr.eu, michal.simek@xilinx.com,
        rdunlap@infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        pantelis.antoniou@konsulko.com, robh+dt@kernel.org,
        grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, pavel@denx.de, philip@balister.org,
        rubini@gnudd.com, jason@lakedaemon.net, kyle.teske@ni.com,
        nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, mgerlach@opensource.altera.com,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Message-ID: <20141029101632.GU18557@sirena.org.uk>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com>
 <1414108267-22058-3-git-send-email-atull@opensource.altera.com>
 <20141024070042.GL10262@pengutronix.de>
 <alpine.DEB.2.02.1410281601570.11910@atx-linux-37>
 <20141029075701.GA10262@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+y7rRxfO4bOZsSs1"
Content-Disposition: inline
In-Reply-To: <20141029075701.GA10262@pengutronix.de>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/3] ARM: dts: socfpga: fpga bridges bindings docs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+y7rRxfO4bOZsSs1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 29, 2014 at 08:57:01AM +0100, Steffen Trumtrar wrote:

> So, that shouldn't be a problem though, as I already cooked up a driver for
> the L3 with all the ranges specified. The only thing I need to figure out
> before I will post it, is how to nicely handle the WO remap register.
> I think regmap might be able to handle this itself, but am not sure yet.

It's supposed to be able to, not sure if anyone really tests that or not
though so it's possible bugs crept in.  Most write only registers can
physically be read so actually come out as volatile rather than write
only even if functionally there is no reason to read.

--+y7rRxfO4bOZsSs1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUUL5/AAoJECTWi3JdVIfQ3PsH/0Jx5AuCk0Cw/z2CSfIPgeHC
Y/J0/C6fpIHtXjYlwGJFiM1rM5WsemQRW+E77GPgMp9anCR0F50n7sSEzMGO/mLk
5sNBb/9PtIajfS1RVmq5rkiefUaU2bk1D4kAWm/NlcKZsdUEgN/iMA39aem0/JOh
eT/ZUzr3eEtegrGk18e4Ud548J/rYaVoqYzw7nfdaX3veaYd31RScXRituQwVhYF
VAnqUZicHAsg9PVx6dMu5Vb/Ld4FCJILAozs3wNe6dgZ6bJ8nJyhsk4FEg+g/uLj
L6KbequYmCSaHitFyz9aqimj7dHScowQ3sI/G+zEf6tDUWkE6Q0EBPZrZjNgoiI=
=AoZr
-----END PGP SIGNATURE-----

--+y7rRxfO4bOZsSs1--
