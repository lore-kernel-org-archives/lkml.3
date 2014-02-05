Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaBEJIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:08:41 -0500
Received: from sauhun.de ([89.238.76.85]:45706 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbaBEJIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:08:38 -0500
Date: Wed, 5 Feb 2014 10:08:18 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Matt Porter <mporter@linaro.org>
Cc: Tim Kryger <tim.kryger@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] i2c: bcm-kona: register with subsys_initcall
Message-ID: <20140205090818.GA2614@katana>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
 <1391516352-32359-2-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <1391516352-32359-2-git-send-email-mporter@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 07:19:07AM -0500, Matt Porter wrote:

> Voltage regulators are needed very early due to deferred probe
> being incompatible with built-in USB gadget drivers.

What does it need to fix those instead?


--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS8f+CAAoJEBQN5MwUoCm2jrMP/iAt/1pOvXO6wzRAhEAkgd7+
9CYqnCEJNQputd/wgGOcpXOrOEZBu4eNApKmBu7FErq6Ilrlj5bn/Ughu6/qRS20
+LwvjYd0GGNpos4JOQ9aJCefMPinj6M3Yghw9rfD67a8f0qTdVjamwehk8mjDwkK
KOiz2f0ipcL3emm32JBZDkrIG/mFj8FId0VHNS51HJP5bWyf9VITwJygy3mlH8jP
QKQMfRtr19bVpzyKgcpxm6cT1G8skjSJY+ZJBA/FNK+LSMeQIrrwJD5JI8tviB9R
lI+w0H9RDel15yv+uDcAcNY8AJ36rAbKTPw9VObB6CRbz3qLhPg99SA3YF2h2+3F
/FESjXlmaZHBdTQ9iIdaIk65a0qrLIJ2HHje3hvNoKp54yjcDVugdBHfuRq/a8pU
cH9qRauX5mHOon4oTI7q/8e4TR8LgxTeHZ2hoDfFyy8EqvHpBdlTgnR1Qt8kJku8
7LqDbAIJrMEYmgbZmJKHopNUOEu7oUxt4XYnTxyIarxbIkGzt1fMwg+/dJSnF1uw
CLSfwdF7Zxrh9Ms/AyBR/og3uggVKARAMIxEpj2qMTJqotaRIqIxR/WFwoA8WR9+
+4TJC5moZH6dZFNR62Cv8b7oV3QoSzFDgkv007btur25MFMZ7oh56689KHUMXrq+
SPVMSgHQnnB8hx8bkAxY
=uyoI
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
