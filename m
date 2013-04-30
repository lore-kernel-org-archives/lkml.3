Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab3D3Snf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:43:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59152 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab3D3Snc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:43:32 -0400
Date: Tue, 30 Apr 2013 19:43:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        perex@perex.cz, tiwai@suse.de, zonque@gmail.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Marek Belisko <marek.belisko@streamunlimited.com>
Message-ID: <20130430184327.GH26160@sirena.org.uk>
References: <1366895594-19596-1-git-send-email-marek.belisko@streamunlimited.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tcC6YSqBgqqkz7Sb"
Content-Disposition: inline
In-Reply-To: <1366895594-19596-1-git-send-email-marek.belisko@streamunlimited.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 0/3] ASoC: Add devicetree support for spdif dummy
 codecs.
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tcC6YSqBgqqkz7Sb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 25, 2013 at 03:13:11PM +0200, Marek Belisko wrote:
> changes from v1 (for patch 2 and 3):
> - add prefix linux for compatible property (for both tx and rx)
> - rename spdif_transceiver.c to spdif_transmitter.c
> - add bindings documentation

Applied all, thanks.

--tcC6YSqBgqqkz7Sb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRgBDMAAoJELSic+t+oim9LT8P/0gu46HYkMNAlAY1ydtPd4nr
N6ihpptezgcXh9AVJXIMOwP4N9mofeeE7Fv8iCLbSc2nsTVRKbQV4oZNW+pAw+89
72a19Yzw8gnddaz33RqSUYo9uPKJGYIKHdj1H8imUq9Xab9j7gv0kW16jv3kRoU9
sr2Zj1/U8YuYbfxwKTLK/qlF2F4+0xl+0hyPQoijUQ+vlK6lxJHsKCrZMM7NEXDf
O0UtbGN/6uwgUTRfHZMV36pNRt5tAhWpT+NskNImOCbEDK3U5XWTxfDFCRuhGUNr
2h3fH3DRftEuvSw65EFELROKdfB+3drB0R0+wnFbBLscs7XPA7ncG6ZeYIF0whTe
gqKS9hp17yt9xHAGbaziJAp/me3pFtdVtFJwr1WoeYkUimdFAuJcxjOn2yYLeSSy
p+rroe7db0TAYjPb023/TTmA1zlYpv4Et/2d2dFjmz8+kBEs9NhJgSf7fuqfeOHW
ekzDXyHUPpoaubhCGN48UVPVYXDoPT6CaUI3Hd/qt+H9zOlljVUrFe0P1r5H0iq5
ylcx9f16rsppcaf/TpuZq2cWtNqKLUm8pGqMaS4brqPUykI54jnaZjt3gBYsjrfg
PJYWoxaI894+8M8i+lTPBLBVwSA396fOG7jlkbmng7AJjOD+LuwMWwNrzwTl1n67
BbAHMV7VS82dTQPkv+q7
=amvf
-----END PGP SIGNATURE-----

--tcC6YSqBgqqkz7Sb--
