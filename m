Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaAGOgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:36:15 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48316 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaAGOgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:36:11 -0500
Date: Tue, 7 Jan 2014 14:35:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Lee Jones <lee.jones@linaro.org>
Message-ID: <20140107143538.GI31886@sirena.org.uk>
References: <1386329534-14186-1-git-send-email-k.kozlowski@samsung.com>
 <1386329534-14186-4-git-send-email-k.kozlowski@samsung.com>
 <2536498.L12VSLryvi@amdc1227>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrBEqmOBc0oN5XAY"
Content-Disposition: inline
In-Reply-To: <2536498.L12VSLryvi@amdc1227>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v7 3/3] mfd: max14577: Add device tree bindings document
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrBEqmOBc0oN5XAY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 07, 2014 at 03:10:04PM +0100, Tomasz Figa wrote:
> On Friday 06 of December 2013 12:32:14 Krzysztof Kozlowski wrote:

> > +- regulators :
> > +	Required properties:
> > +		- compatible : "maxim,max14577-regulator"

> > +	May contain a sub-node per regulator from the list below. Each

> Is "May" the correct word? Wouldn't it be better to always have
> configuration specified for all regulators of the cell?

It doesn't achieve anything to force people to include unused regulators
in the DT - the node is only needed if the kernel needs to do something
with the regulator.  This means that all the individual regulators end
up being optional.  The set of=20

> Now this patch creates a question whether we should keep the existing
> black-box MFD scheme, where the list of cells is determined by an array
> hardcoded inside the driver or rather we should completely move to DT
> based description where of_mfd_populate() could create all MFD cells
> using description from DT.

This has been discussed before.  The biggest issue is that the Linux
idea of what cells it wants depends very much on whatever the current
set of subsystems Linux has and the way we divide the hardware between
them.  That's not a static thing, we're seeing flux with things like
extcon and clk at the minute for example.

--lrBEqmOBc0oN5XAY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzBC3AAoJELSic+t+oim9s3cP/25C3JqESaVlkDuHWLThM92K
y3hWGf6kCYw8zgZC7afHzuyvIZOjSaaJeBpSEgAMe93QOf1LYkZwdEy9td8/mokm
igJMe6tz1/3663ygfnc9r5aEcEiLQagrNXC2LNnCuBplPTN+ycYitmybUc6fq5Cn
jl7FkqLBB5yTIPfXQmJ5F0RPqxadeTg4islfEois7OhwY18HRB5CwbkqkAm6FleG
Qm4iMrel/T/6i3tavL5+17miOlvRWq1WBt6iKvoWUwxDWFFIGzlx101uqBUGc8/s
VpaHbqMVLLnbAif4n4yJUo5BX1q2gZ1yBTxl7+2LrwH+GD6Of1oGlpMz7nxcKwR8
o2Ul6A0Fa3aEYHLr7DfI16DHckLvzjZ7dtgXD3Kuiu60gPtNvAlD6sFZRUt2WDT8
G+PWGnNL6UmwZnvFm17hbGg4CILhJ8k1A9At/ljMcUKgzlgjjrqTAzUPBzrPUYND
+y216tBfb6Ta9RdGknQTEvXyLaKOpIvo5uPz0iG8x1iPpQjz3QY0u/CSW35J9dpy
SHcnmNENe1kBluggDrjfB30jHyN12fLdAlcRJcUOY0/M7iSSODDIdWYsahTXK6OY
eGuHFIAmyo+2hj/lpg6vA52uKZLwJguRNzzxlUqgw0OIMFrlozORO/6H7cbTn9Kd
EaDFrnq++cMcXze2vDI+
=cpfS
-----END PGP SIGNATURE-----

--lrBEqmOBc0oN5XAY--
