Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbbAMQU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:20:27 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55099 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbbAMQUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:20:25 -0500
Date: Tue, 13 Jan 2015 16:20:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Qais Yousef <qais.yousef@imgtec.com>
Cc: Vinod Koul <vinod.koul@intel.com>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Message-ID: <20150113162004.GR4160@sirena.org.uk>
References: <1421147933-21802-1-git-send-email-qais.yousef@imgtec.com>
 <20150113145931.GD3085@intel.com>
 <54B536BA.3070001@imgtec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="p2u4WfPhYOuYlOsk"
Content-Disposition: inline
In-Reply-To: <54B536BA.3070001@imgtec.com>
X-Cookie: Keep out of reach of children.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ALSA: ASoC: soc-compress.c: fix NULL dereference
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p2u4WfPhYOuYlOsk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 13, 2015 at 03:16:10PM +0000, Qais Yousef wrote:
> On 01/13/2015 02:59 PM, Vinod Koul wrote:

> >>being NULL, hence when trying to set rtd a few lines below we get an oops.
> >It is a good practice to add the oops here

> Will this really be helpful? I think it'll be more clutter (the backtrace on
> metag arch is not great):

It's better in general to leave it out unless it's adding something (for
example sometimes the particular call path is important) and even there
edit it down to relevant details - the splat from the full oops normally
overwhelms the commit message.

--p2u4WfPhYOuYlOsk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUtUWzAAoJECTWi3JdVIfQ5GcH/0mYUD70RS730eNe6bSO63UK
G2TAe8SOrgMsGmCr6kq0+q/5Gts1qltlC2ce2NDnp8u8HJS/5CaQ1FlgSAvNTiCT
XGOOKfWOiQfebmnJ+QjEcTs6DWnBKugmNxjPOQ5XAjZ+dwTSoK4LO0Lg4dS41KyV
LBre6iHEcl26fStLU5BXjwPthF4Z9lV3OLTntdcPKG7qMxECTE4xNoJ1rc3jIZxr
/h2o19IJPZPeB+p6g5Py2hKjlKSixJld3acv7WxXGw9ml+mmOtSEdWHz/tkNoyUD
7EVef+D2jAxADw3H10nF5FC8ytfoPW5Ahmrog3Pqqne/mLH6m/R0UTQUbOiegw0=
=a/fz
-----END PGP SIGNATURE-----

--p2u4WfPhYOuYlOsk--
