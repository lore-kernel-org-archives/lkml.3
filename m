Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaAGRLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:11:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48446 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaAGRLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:11:33 -0500
Date: Tue, 7 Jan 2014 17:11:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140107171124.GB31886@sirena.org.uk>
References: <20140103091918.7387cfb5@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7aBBD6ClYIPKzb+y"
Content-Disposition: inline
In-Reply-To: <20140103091918.7387cfb5@armhf>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: pcm: Fix lack of platform bespoke_trigger() call
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7aBBD6ClYIPKzb+y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 03, 2014 at 09:19:18AM +0100, Jean-Francois Moine wrote:
> When the platform driver has no ops, the platform function
> bespoke_trigger() is no more called.

Applied, thanks.

--7aBBD6ClYIPKzb+y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzDU5AAoJELSic+t+oim9JuoP/iq57Qtxuqy+TJo1IXiHobdb
ETFSN9IRS3aHXfYHgnVYoPyJvJxOuSQMlFeahnSgrg2973HrpJ4T++k7c3SKFRQ1
6IUj4A7PRNk5dArbArihSY32wqLnl1GsP94fRKRQTVMMwGC3VInu5tRW1bydK4Nj
Q/EBKdA/n/uD3OoRaFA3SFaI7j513brdj5YI5esAwqTNcpdWHBiJutoYQ50nLaS0
sfYlfk6sFbEprKScHVL8KeUAvRL8fNMxzgXW6NQqiwofCfV0PbBuGyN04QxTD/M9
0+SvW1B4PcC2g3OwnoDA1oI25Z3s9q4jW9ZMkzviBN328NJzGkY1MObVcJXvRFhC
yijfZSW29/w5C25+YkpbpT+BIWzNqJbsRJi9MmZLy6wrAPDYzO0W88hwH8nS34Ej
/DHkBvQpOG8wt4z3kGNwop6HtmcueV7I9JLEXuynPQsHfK0987q28BlL/KhlAhoo
hST5E2NJRieHziidmnHiIVSgOyR5FKS3U2/TqVou90q9BsB7DLnd/Khm6rH1jkEV
37xBtjXyqHtTdmEhqdw/h162wIrjjVrS1f8ouH1O3pUor2dwk104kzJbM5YSC/3l
f3CmgAysKM8f/HwaIeSlciKLWypPC6osIBoOIqfPyV2xJRHDKCQ6txpbStxG8gP9
ViLGzXfFwYItyyk8VCnC
=MsxE
-----END PGP SIGNATURE-----

--7aBBD6ClYIPKzb+y--
