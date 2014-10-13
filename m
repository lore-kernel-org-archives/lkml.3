Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaJMHp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:45:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49387 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbaJMHpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:45:20 -0400
Date: Mon, 13 Oct 2014 08:44:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, dmaengine@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141013074441.GC27755@sirena.org.uk>
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
 <1413042040-28222-11-git-send-email-vinod.koul@intel.com>
 <5439591B.4020701@metafoo.de>
 <20141011155411.GA1638@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i1dAbsF9+zgeqzLb"
Content-Disposition: inline
In-Reply-To: <20141011155411.GA1638@intel.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 11/12] ASoC: txx9: use dmaengine_terminate_all() API
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i1dAbsF9+zgeqzLb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 11, 2014 at 09:24:11PM +0530, Vinod Koul wrote:
> On Sat, Oct 11, 2014 at 06:21:47PM +0200, Lars-Peter Clausen wrote:

> > I already send a similar patch a while ago. It is on it's way into 3.18.

> I will drop this one then

> I did grep the linux-next when I started on this and found no reductions
> from what I had in dmaengine-next

It's ff495d3a8ea4d (ASoC: txx9: Don't opencode DMAengine API calls) from
August which is in Linus' tree now.

--i1dAbsF9+zgeqzLb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO4LoAAoJECTWi3JdVIfQ+d4H/R7VqgNgx9tyXiG0+v+rFTkH
5zC51jH2U/co/4w/3MavhyNL9W14OpVmTEEHNNqnm0sXHaN1vjKhkij6+xXyYbav
jU+ni+mh+kqYSWcJkUEwFrmQedIC1hZertXcG0GJRV5G6bJgzMRexJUfGBEpzwJX
a/u3oMY9PKtxGxGmokXq4Dz+r1om96hHHredbP9muqpGGPQerg4RgZPkRdN1cJ3e
iIghlTM647LYuzl68tYTzIwpL/r0oxdVZfIm/wTmVldb/5G/zH3pT4JKcrDTfqxo
HfQB4Lrh4GbJY1/FO9TSbX4EBd+3rf+A0BuRtJuA+A8ecQLI2J5xeIiK7QNCG+4=
=7Qj5
-----END PGP SIGNATURE-----

--i1dAbsF9+zgeqzLb--
