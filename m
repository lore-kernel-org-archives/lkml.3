Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaJPKZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:25:46 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58373 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbaJPKZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:25:43 -0400
Date: Thu, 16 Oct 2014 12:25:06 +0200
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Barry Song <baohua@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-rpi-kernel@lists.infradead.org, alsa-devel@alsa-project.org
Message-ID: <20141016102506.GD2200@sirena.org.uk>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
 <1413454672-27400-2-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oj4kGyHlBMXGt3Le"
Content-Disposition: inline
In-Reply-To: <1413454672-27400-2-git-send-email-maxime.ripard@free-electrons.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 01/53] dmaengine: Make the destination abbreviation
 coherent
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oj4kGyHlBMXGt3Le
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 16, 2014 at 12:17:00PM +0200, Maxime Ripard wrote:
> The dmaengine header abbreviates destination as at least two different strings.
> Make a coherent use of a single one.

Acked-by: Mark Brown <broonie@kernel.org>

--oj4kGyHlBMXGt3Le
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUP50CAAoJECTWi3JdVIfQSKIH/j5l0pOe5VX0cjBewvNTRRQz
fF7c54oUYZpPtt6x7sIb9B0tTTVH1cxK10eGgnO61YfFp1bzFZrSgjzG+gblTsrS
vIO56QnpZ/9Btyoa69w7FX4fapQBuZTE/NcY7ewezdr6BMvk0kxw01HDg1FUngTE
emvi/Tk+8A4h9eIFyEl9O57ZB9ChuFzapxTf2Y6Mzqo+46s/WLU0ZhjELlLMCne1
fTJdhqw/+yfkJT/vuA4NYmGunfVQjTmwiIbsTqP0zlUN8fjIkBehMkaibtD/uM/v
C2HnRJNNXFp9Ws/1BqvVeatDJuKKE6fA6LH65yVyxZ1pTi51SZ57wBlks/zwqes=
=oBiz
-----END PGP SIGNATURE-----

--oj4kGyHlBMXGt3Le--
