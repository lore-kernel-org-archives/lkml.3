Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbaGCP42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:56:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45086 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaGCP40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:56:26 -0400
Date: Thu, 3 Jul 2014 16:55:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Wenyou Yang <wenyou.yang@atmel.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Heiko Stuebner <heiko@sntech.de>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20140703155538.GG410@sirena.org.uk>
References: <1403451105-31929-1-git-send-email-b.galvani@gmail.com>
 <1403451105-31929-3-git-send-email-b.galvani@gmail.com>
 <20140627160725.GQ23300@sirena.org.uk>
 <20140629094642.GA13485@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n7zTieg8iIQ1Wja9"
Content-Disposition: inline
In-Reply-To: <20140629094642.GA13485@gmail.com>
X-Cookie: Semper Fi, dude.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/5] regulator: act8865: set correct number of regulators
 in pdata
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n7zTieg8iIQ1Wja9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 29, 2014 at 11:46:43AM +0200, Beniamino Galvani wrote:
> On Fri, Jun 27, 2014 at 05:07:25PM +0100, Mark Brown wrote:
> > On Sun, Jun 22, 2014 at 05:31:42PM +0200, Beniamino Galvani wrote:
> > > When platform data is populated from DT all the regulators are
> > > instantiated and the value of num_regulators should be the number of
> > > all available regulators rather than the number of matched ones.

> > Could you go into more detail on your logic on this one please?  The
> > platform data (and DT configuration) for regulators should be completely
> > optional.

> pdata contains an array of struct act8865_regulator_data and a
> num_regulators field which should hold the number of elements in the
> array, if I understand correctly.

> So in the current code, when populating platform data from DT, there
> is a mismatch between the number of elements that are put in the array
> (ARRAY_SIZE(act8865_matches)) and the value of num_regulators, which
> is set to the number of regulators found in the DT.

> In case of missing regulator nodes in DT, pdata->regulators will be
> populated with all the regulators but their init_data will be NULL.

OK, so that was slightly unclear but I see what you're saying now - the
issue isn't that there will be fewer valid elements in the array, it's
that the array is sparsely populated.

--n7zTieg8iIQ1Wja9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtXz3AAoJELSic+t+oim9GSMP/0YVM1ksW7ciQVv2nQDM2ZGS
I2gN5MOR9Vnb2/xYbXSre3vw2OIoY8JhCjJSgBePN7+GBh9Xp7o+yme7F0z9LDJZ
TvxghxkI4aLADUXb+8RVBRwUbyhjmHEdox6dPyRxU+GpNPOld9g1K5vtPxAya4uv
TWZWqt1/DUX9sLWz72Imqz91Iq4A5upeQN4g+KpITve/5S8WK7aP90xktvUTmMQa
QTgxgMr7qlSKWWuc5t6WOQWQR1B+OKVBNUhR80nIn2+rbDzY9CfWHP3MjYiJgVM/
GovzlFATVzrFvtoTiAxsJmvEsARaRh7mxmdJr/DhntCRHj58j7aaNPhV+Yk/Nx5+
7dEaWo4TrzYH+3E/XP+ZjogxW9oTTrDPfsdEEUMtM0FISgJ3d6dI7Nh2d2XlR9tz
PnOEaBoCxHm9AmjJltCE85DF7MwwAXEWngEooh+lA7cofRw+PDJZd3MHutvBOpth
YzJZnQqLhjbCGycUwAadGxB++Zi6fvBhP1R1D8FpyT3ykPdGz79jGwQuxdNYeBzj
p/cZVu/c4puSz5deWeIEHaf/C8pddMQFZorbaZguwz3s841eqfEyWXOCJH41TDTZ
iLexVr6JnbmujsXXAlpD8xY4VFqo4Nl5Of3gHRj26IERNQeY8M4Sc3gSURCGSvwX
9Zmuz7xsz9SDDWInDZ6s
=QD+m
-----END PGP SIGNATURE-----

--n7zTieg8iIQ1Wja9--
