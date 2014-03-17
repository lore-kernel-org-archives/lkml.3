Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996AbaCQLzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:55:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51543 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932672AbaCQLzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:55:41 -0400
Date: Mon, 17 Mar 2014 11:55:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Bo Shen <voice.shen@atmel.com>
Cc: nicolas.ferre@atmel.com, Boris BREZILLON <b.brezillon@overkiz.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140317115518.GD11706@sirena.org.uk>
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com>
 <1395049541-28128-8-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="11Y7aswkeuHtSBEs"
Content-Disposition: inline
In-Reply-To: <1395049541-28128-8-git-send-email-voice.shen@atmel.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 7/8] ASoC: atmel: document clock properties of the wm8904
 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--11Y7aswkeuHtSBEs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 17, 2014 at 05:45:40PM +0800, Bo Shen wrote:

>    - compatible: "atmel,asoc-wm8904"
>    - atmel,model: The user-visible name of this sound complex.
> +  - clocks: A list of clocks needed by the wm8904 chip.
> +  - clock-output-names: Driver related clock names. Shall contain "pck0".

If this is a clock for the CODEC it should be documented as part of the
binding for the CODEC and connected to the CODEC in the device tree
rather than being part of a machine driver binding.

--11Y7aswkeuHtSBEs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTJuKjAAoJELSic+t+oim9ZiAP/jR39IUYtk7IKqBgV0K7XNpD
q0M0ebzD5GOn60zrRepSVThsOK+tslzW/hIEQiRtJ/YDHyP5kNxXcBrhQd16xhT7
2JlgF15o2oO5sc3lwbF7wzytulSMGn+qhRCybqJliZUBROGI48HaQH6ANX1yTlrq
DZt+K6YWUJNeJBCU2XFYCOrGmi29PbBjl+Li8PX3zcoBG0LO/gKAxIi7xS+suMEj
C3CxSEkv2E210CJ4Ienx1amOmNTwiOOM3cjy5d66bQIGvYxfAzaMwB9ptLZjm8S0
wjTIQWz3ICo3vncsnl8Vur8b0WJmv2KXFM773JwDloCLwNUZGotEaT4JCExTVZ0d
4gMbjUcnHKxaUZYgq5RryilS9GWoSoM0PB5z0vDJ5yur4JZq9k0zzPf5nh2/yzrt
BNYjgxfdx3oWkqZBpekVkGZ2IagFiOoC+94mfjuxKwE0Llw4C4y82zcVmtzRzgh1
nh36QnYWbwzMz/uADbn36pC3ww70c4lxXOujP1MPdFqs1zOQtpS+wOuhN+9IcGR8
05W8KEbkDGteg4JcSq0GX0L+6H7uDPtI3VCFXEsw6es4OKMp5RsWVLblsm5hntja
GYNg891vXRGj8idTz6iWLL5kjCRWi84RnFvV4ZMn8PXYpvW+IrComI9QHhrM4L/B
IBesqsKPO9XX9opHtYDH
=W3NA
-----END PGP SIGNATURE-----

--11Y7aswkeuHtSBEs--
