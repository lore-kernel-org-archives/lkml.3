Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaABLLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 06:11:02 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60047 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaABLLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 06:11:00 -0500
Date: Thu, 2 Jan 2014 11:10:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20140102111056.GT31886@sirena.org.uk>
References: <20131231113138.102044cf@armhf>
 <52C466E1.3030302@metafoo.de>
 <20140101210814.31e3f3a9@armhf>
 <52C4766B.8080000@metafoo.de>
 <20140102102647.6efec89d@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="80TIu+lzzbJOSSak"
Content-Disposition: inline
In-Reply-To: <20140102102647.6efec89d@armhf>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: generic: add generic compound card
 with DT support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--80TIu+lzzbJOSSak
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 02, 2014 at 10:26:47AM +0100, Jean-Francois Moine wrote:

> 		/* audio */
> 		port@1 {
> 			hdmi_i2s_audio: endpoint@0 {
> 				reg = <0x03>;
> 				remote-endpoint = <&audio_hdmi_i2s>;
> 			};

I think we want an explicit object in the card representing the DAIs.
This will both be useful for making it easy to find the configuration
for the link and will be more extensible for the cases where multiple
devices are connected, you can't just assume there's just two.

--80TIu+lzzbJOSSak
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSxUk9AAoJELSic+t+oim9ZoQP/32WdN9fvE4C0EOXvdX2OpIt
yk7u8N6LPu9kRMHnCTtPkhLSFNLEHdV39TIABCnVXCPIwi/o+l2pJkkn/n5dvWqE
XgLXaX7mhjuMZv46u/PDAonHu5uWLHk415WJ3pQHMHVQ/ppfO/wisLhVQuiIWRZg
Ec6E59MuUmqiys81QsYvB1qaq/+FCdUjt0b7KcAPUa7Y2r+CL3wNeY4Vq6gSersi
QitXbOCIl/53r6AN7bRSBIgKr0VcYXWXZfoXpaW8k2ivs+J6ELXJN3+qbSFEol48
ybj1+WBRhMjFmQSrIysvJLgqOISCqasbiotWd5iYzc4FJUNvcYOHDXHJZcdHX2xO
/DVmXXnG6KgBGPV6q2i8IY+IUXXyctC4MsxE07l0btSlfhgaAquZwxtNYUITWXXs
0CW2XQ2X3JIYshTw1PPAjgIFbP29AplWlqmnkbHr9tfRzdrvJW8E7bjO3y0QzYnn
KWSeofC1k7sZxDtZSQMZUm3RT+1ET28C4xRz5ZmA2gjwAFcbw5RQUYbbjz8UDkA+
oDngL1z3Iw9hQjVaXC7ZSYBZXPDHb373xRT0tCheE5c0BNbiQVW4WQlOmLYRj5Og
ippuvWmcWBKidQ7+Mha8/3R/Tiw96xTEWcr6YtdqnSNuKoZXLw9P8nE/VezrdpsP
z0F6KWUMn4ITLNFYf2pQ
=x2//
-----END PGP SIGNATURE-----

--80TIu+lzzbJOSSak--
