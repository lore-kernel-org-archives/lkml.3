Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab3HLLcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 07:32:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54121 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab3HLLcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 07:32:39 -0400
Date: Mon, 12 Aug 2013 12:32:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Olof Johansson <olof@lixom.net>, Alan Stern <stern@rowland.harvard.edu>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@kernel.org" <devicetree@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130812113226.GV6427@sirena.org.uk>
References: <20130811190826.GH6427@sirena.org.uk>
 <Pine.LNX.4.44L0.1308112146410.29546-100000@netrider.rowland.org>
 <20130812095136.GJ6427@sirena.org.uk>
 <20130812110714.GA6616@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x8Ec79u/ZTqSPCUg"
Content-Disposition: inline
In-Reply-To: <20130812110714.GA6616@e106331-lin.cambridge.arm.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x8Ec79u/ZTqSPCUg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 12, 2013 at 12:07:14PM +0100, Mark Rutland wrote:

> As I understand it, the wifi chip on the Snow Chromebook has a similar
> issue -- it hangs off of a probeable SDIO bus, but needs a regulator
> poked for it to turn on and become probeable (see
> exynos_wifi_bt_set_power in [1]).

Yes, that's another example - this stuff is really common in practical
systems, especially the power control for radios since that's how rfkill
tends to end up being implemented.

--x8Ec79u/ZTqSPCUg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCMfHAAoJELSic+t+oim9tz0P/2byd0ZIAm14u74I0rn4dKa0
MfFGaSRNxl70i5G3VZ7PhOkzEvOYRF+PkrxRoIgdINBmaWmkO3n2h1jxaLiEmFQr
BytjPOpgNUfvVTo3AWvmznn9AobWWiTGAH3b86mGO4gFe/NifuifmqIEhC+uBHNu
OKhpM17a/NvSkhNV5qaO2pZMEDvEqz+OS8PX/QqdFvuceYmGvJeVtU/m7PEeuDm4
ebgiq0p73ayOvSV0sNwrz9A2KCCeTQz85JrBuFBHnwHaUFdAK00oybtlBIwHTb+S
viu1jaKOFPotATFY+BPpc9EN4p+wGoBHTiBPUy/4m6/BaAQgJkYqN2KWaj0PNK9v
a0nJ8wxyTJEvCgO1OOjV8RdPnh2Vh9RXpMq8EjtRbmGpNMOulVdAr3hyTCA6aOE1
Hpzlo9PTXwdH/h4ZKG7EWg8uiG2QTSxFjcOGnuXYG8BBH0zaQ4aOKQTx++VUj1B1
GzevNjZShd0gVuE8d/qK82G59s0nPgj/M01GrqHmTY0/A87baQh0QR5L/5bq4K0O
8sUc+BTTyMB829w+w9PcA41MavH/BHR9Rz7jgbgPLBNxGHpUWVAm1TRGM8S9Z4N9
AKDpgdLlTwbOcd/M2EVneAgq18W55k2fBty91ZRH1xzu9trwhSec30bnPDtpws3L
ruumBV8KlL1K4JlJUx9R
=SobK
-----END PGP SIGNATURE-----

--x8Ec79u/ZTqSPCUg--
