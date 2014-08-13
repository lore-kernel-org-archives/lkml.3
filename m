Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaHMLjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:39:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33254 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaHMLjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:39:04 -0400
Date: Wed, 13 Aug 2014 12:38:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>, lgirdwood@gmail.com,
        tiwai@suse.de, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        perex@perex.cz
Message-ID: <20140813113841.GP17528@sirena.org.uk>
References: <1407926840-8576-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
 <20140813110844.GF15833@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lbODzv4ZEuSk78XQ"
Content-Disposition: inline
In-Reply-To: <20140813110844.GF15833@opensource.wolfsonmicro.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: wm_hubs: Fix DC Servo readback
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lbODzv4ZEuSk78XQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 13, 2014 at 12:08:44PM +0100, Charles Keepax wrote:
> On Wed, Aug 13, 2014 at 11:47:20AM +0100, Nikesh Oswal wrote:

> >  	case 2:
> >  		dcs_reg = WM8994_DC_SERVO_4E;
> >  		break;
> > -	case 1:
> > -		dcs_reg = WM8994_DC_SERVO_READBACK;
> > -		break;
> >  	default:
> >  		dcs_reg = WM8993_DC_SERVO_3;
> >  		break;

> This doesn't look right, firstly if it is the same register for
> all versions then surely we should change the code that sets
> dcs_readback_mode rather than setting that to different values
> but treating them the same. Although obviously if nothing still
> uses this case we could remove it as well.

> Also I think the situation is more complex for example on version
> 4.4 of the datasheet for wm8994 the WR_VAL fields appear to be in
> register 59h. Which is not consistent with this.

There was a change in the DC servo between revisions of the WM8994 (at
revision E from the look of the code).  This isn't documented in the
datasheets as they only document current silicon.

--lbODzv4ZEuSk78XQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT604+AAoJELSic+t+oim9DNwP/0iLzIzR1kXyTxmWGrAvWFgf
PcXk8fpk2UGmTqFKKLXbowvP9LJsOeMPTNx08Bsbr7+EZRf8Iuk/xK9bry7svhyN
2s82ZYwRzSmhQHGhu8IhcldY8xbAXnIkPm0RBc5XsYGyqU97UqR8/RdiFJxSpmMO
hB5XXZkRFiqA7FHDkdkQp/I7EVkeftT8LNzMthXZYi8NstinQPlFCPImp30rKV0t
ica+yl4MwMdDxz9K7hAdaXGsV5wktJatd3nI2iLtD+CVaeEPHKRU8JEW/9HTEJLq
SIz9WMsT4usuO4O9ITSO2x4HLXQ9dL7LPyVvD4pVfuR3oNLffVup7IiQeMp5OVQK
EQU/25Rr2rUG6C5ljLZzw/pbQAkt2odPq6lf3A1k+1T3yMPe4r5qOFWPgWvGda0s
fqC0EF8DIPvIoppzdPnr3rkr9LO+bjdP2/RO5/d16UjA/XEuMbYx12K6cUbwdkpA
7osS1tNrpAkCFXy+jSjFq3L4sKdWrpsiNh6cAjjaHkytnRF99hXH8EanVXveaOZ0
60EqFE2WId6SZoCy9IcMkBR91Lor6v1ovHny3zPKH9WNhcbHA01PdUbw5+RIPOB5
8Khkr/Efvklfy0UcS9IWOXP6k0dwcDbNYN0HqkxP80kl2pf1PxDRoOZrptZ5H6j8
j36yoYjVXXJF5hiQLIA8
=mTBG
-----END PGP SIGNATURE-----

--lbODzv4ZEuSk78XQ--
