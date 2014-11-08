Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaKHJ0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 04:26:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51325 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbaKHJ0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 04:26:43 -0500
Date: Sat, 8 Nov 2014 09:26:22 +0000
From: Mark Brown <broonie@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        GTA04 owners <gta04-owner@goldelico.com>, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20141108092622.GC2722@sirena.org.uk>
References: <20141108002637.6561.19002.stgit@notabene.brown>
 <20141108003803.6561.57464.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NKoe5XOeduwbEQHU"
Content-Disposition: inline
In-Reply-To: <20141108003803.6561.57464.stgit@notabene.brown>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.249
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] ASoC: twl4030: allow voice port to be connected
 externally.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NKoe5XOeduwbEQHU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 08, 2014 at 11:38:03AM +1100, NeilBrown wrote:

> If voice port on twl4030 is not connected to a McBSP (or similar)
> then we cannot configure the format the way we normally do for a DAI.

Yes we can, you need to represent the DAI link to whatever else the
device is connected to in the driver like we do anything else - and in
any case this isn't a device specific issue so we shouldn't be doing
something driver specific to solve it.  Look at something like speyside.

--NKoe5XOeduwbEQHU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXeG9AAoJECTWi3JdVIfQc4QH/1l0g9IioGYeCiZI3hZeipn2
QJUO3LMztZZuximUm03fKQggDZ1mw/TahdVKVOFhMgD++poaljjboOlyy9akat14
1TFyjLa3Q6f7S93kcuDi0kuxhQoY6mgVFN2zOYC1z9q1bAqfElOkaJjbk/rdTKtn
2ubSjrX1vQ7ZGGrGNvTpQTcOKiQBEzdL9HW6Z/ZtoKy1OF2+pqZh0B17GFnB+U2d
YeHRMeEz4XUZGDk7RofQ4HbeVg+dqNesp683wFaWu1zMn9Xmmxc5ANaMM5ASJEsW
TVyg5Sri69ALJHaIAqVVJzQV8oq4rd0KstLBVdWpDSR4RX0VybIC9KxaFVl1bpE=
=Y39v
-----END PGP SIGNATURE-----

--NKoe5XOeduwbEQHU--
