Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966610Ab3HIKSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:18:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43634 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966223Ab3HIKSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:18:47 -0400
Date: Fri, 9 Aug 2013 11:18:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20130809101842.GR6427@sirena.org.uk>
References: <20130808132201.2610aef3@armhf>
 <5204A716.6070507@gmail.com>
 <20130809091953.GO6427@sirena.org.uk>
 <5204B7A6.9050907@gmail.com>
 <5204BF06.3060806@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kjn60822oUuI93ff"
Content-Disposition: inline
In-Reply-To: <5204BF06.3060806@metafoo.de>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v4 1/1] ASoc: kirkwood: add DT support to
 the mvebu audio subsystem
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kjn60822oUuI93ff
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 09, 2013 at 12:05:58PM +0200, Lars-Peter Clausen wrote:
> On 08/09/2013 11:34 AM, Sebastian Hesselbarth wrote:

> > I do understand there may be SoCs requiring sophisticated extra audio
> > nodes, but Marvell SoCs don't. I prefer having a single node for the
> > i2s controller *and* exploit the audio subsystem properties from that.

> It's not about SoCs, it's about the board. The audio fabric on a board can
> easily get complex enough to require its own driver. Speakers, mics, jacks
> and jack detection, external amplifiers, bluetooth, baseband, multiple
> CODECs. That's what the audio node describes.

Exactly - as I said earlier on this week the issue is that in many cases
there is enough going on in audio system design to make the PCB an
interesting bit of hardware that's worth describing in the device tree.

To repeat what I said before *please* go back and check the list
archives, we've been through this several times.

--Kjn60822oUuI93ff
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSBMH/AAoJELSic+t+oim9I4YP/3nTSMMtwspEqNLHc0KhkFVP
cx12Dc15XVjPHIXSC1XOd1Vf1AwODXqzIqSGRpRGeR/KfZKrpmuYQpCNGe10gx4X
5Jb5zh+bt6rxa9l0viSYQfKPJ8k0QF1gw7HG25s1rusXM7fRoGVDA8ZVaJ9ZaG+I
b3GMLbNK8Fa1kucpmT29F38wegwQQs4Fd/HNBm8L8Kr/yaJPr70zlKLegcU3U9vd
adfLjXJLOkJ+TTLXTmXxujuUpe/Yqs21fPFRIFRPDsXkKEulC1eVWSGo6y/4GrTE
uZafui2KOh9EFm49Pjd0s36JV0Vfm9IhMhmOvxNNOgbAOtqzVBZJFCJTVQ8C3+Ji
egJsJ8GFCdEYKeEHErmLxZJ/xViLnkcqKAB1oCWj5brWNxpePTZeP1s8D4RiGKtO
i9KuEYcswtfzkHgXBbuXs+8Qko0CsJNKksZIpG0HP6E+KxtW4OVtRbu7SJ5O0tyf
Ru5nU50HGBM7o7Wd3tVCFXZwitKQ5CX7NAiucAkN5SeGWRwo3FV9u+xqEDITfmdX
HAut9JqPfXGBJt939kSxRC7/h6uGZI/3MbQ8LJyoRbaqVH2PH1tNiv4eFJjESBH8
lvKPCWQ65P0h8DDTyLAXekwIB6pRYEjgxRKSIOg06tvy7CJf2XG+JP0cSL3QDNLm
PYRUVLgFTP1YHpGD1Ct3
=gUzZ
-----END PGP SIGNATURE-----

--Kjn60822oUuI93ff--
