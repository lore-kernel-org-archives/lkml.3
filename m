Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965598Ab3CZP6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:58:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37363 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965414Ab3CZP6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:58:16 -0400
Date: Tue, 26 Mar 2013 15:58:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [GIT PULL] extcon/ASoC: arizona: Fix interactions around HPDET
Message-ID: <20130326155812.GF18316@opensource.wolfsonmicro.com>
References: <20130326154014.GD18316@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s5wWjIzCVkCTLRpN"
Content-Disposition: inline
In-Reply-To: <20130326154014.GD18316@opensource.wolfsonmicro.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s5wWjIzCVkCTLRpN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 26, 2013 at 03:40:14PM +0000, Mark Brown wrote:

> I've taken the liberty of pulling into ASoC already, if there's a
> problem with that I can drop the changes easily enough.

While adding the ASoC stuff on top I realised that one of the
overlapping changes should just be squashed down into the ASoC change
here so I've gone ahead and done that and redone the tag, sorry about
the noise.

=46rom 04f2108cbde151329b7222d5399df71376a76358 Mon Sep 17 00:00:00 2001
=46rom: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 25 Mar 2013 10:10:35 +0000
Subject: [PATCH] ASoC: arizona: Ensure generic output event is run for
 headphones

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/arizona.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/arizona.c b/sound/soc/codecs/arizona.c
index 05f36bc..1e6b1c0 100644
--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -631,7 +631,7 @@ int arizona_hp_ev(struct snd_soc_dapm_widget *w,
=20
 	snd_soc_update_bits(w->codec, ARIZONA_OUTPUT_ENABLES_1, mask, val);
=20
-	return 0;
+	return arizona_out_ev(w, kcontrol, event);
 }
 EXPORT_SYMBOL_GPL(arizona_hp_ev);
=20
--=20
1.7.10.4


--s5wWjIzCVkCTLRpN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUcSzAAoJELSic+t+oim9dacP/2cUMwhDzQdZ8ZTfAoce0AYg
VW8ko5bWIUtqHXEyyv7ugp3uH2YyWoA3NaYqe8m2PE26oFe+gJXHhs98JQMC+Feo
gMiMTaW4/vc/vw2LjvXiGB0hhGQBG9rYkUS4PWjme203sgSp9QJECv01IGSnX/tC
cN8fDVBeSWWF+VOnDhIs5F6VdXTVn8uAVSWuiaLy1liiDPuC6pWMJTUIIBqa5uF7
9OmnHkxw2mN2cZoRlkaFshbrap+LiqFVMgc9qt5o4oKJdC6lanDrxuxmW0aua6Wg
grJCzm2wpyBGSh2j8lQjkA2/XqroscoNVwgZhqDTPYe8duJ2dOAzSrWbbgVkGAAH
LZ9B3CuWI2EW/ZXVq2PFvKbuKOuIw/jFZzb8HcAmqmftmpyfctnFBrthGtJ5w2sm
8g5or1lI1NAK2QEg/IEaDg2HXXgXxjdIt51JsGGHi5c2JO3usnqHVWip47/3xOzx
+Y1YzTh0gt5MmB5phNKbRFcsqTGctP+0VZ+I3Ic0w7XT7Sa0A3H6QklWD0BYI0G5
8Eo76BcG3EJhOKQ+uCTTwFGyvHiWPikVj7gwfDp9CTSKiIu4LzAnMIWWpjhwUDI+
5EmkcXRkwkWsQBPqJuwHfo6p5Ju6yW5G9d7fR0ra/Bi3TyL9lKDGPYMczhQwWs09
et+CJca1FtN6CNp9Mtld
=aTe/
-----END PGP SIGNATURE-----

--s5wWjIzCVkCTLRpN--
