Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaIJLAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 07:00:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60816 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbaIJLAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 07:00:47 -0400
Date: Wed, 10 Sep 2014 12:00:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linaro-kernel@lists.linaro.org
Message-ID: <20140910110035.GC7960@sirena.org.uk>
References: <1410003731-32276-1-git-send-email-broonie@kernel.org>
 <CA+gwMceBMs2hpiPhjJoj6N+BFgDN_26YeB6CXqFeY6OMQ4jmoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
Content-Disposition: inline
In-Reply-To: <CA+gwMceBMs2hpiPhjJoj6N+BFgDN_26YeB6CXqFeY6OMQ4jmoQ@mail.gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 81.132.226.177
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: isl9305: Add Intersil ISL9305/H driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 10, 2014 at 12:56:12AM +0200, Philipp Zabel wrote:
> On Sat, Sep 6, 2014 at 1:42 PM, Mark Brown <broonie@kernel.org> wrote:

> > +Required properties:

> > +- compatible: "isl,isl9305" or "isl,isl9305h"

> I have suggested to change the Intersil vendor prefix to 'isil':
> http://www.mail-archive.com/devicetree@vger.kernel.org/msg40842.html

I'm really not sure it's worth the bother but whatever...  please send a
patch if that goes through.

--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUEC9SAAoJECTWi3JdVIfQx0wH/jgv8nVkIHFSsaOgdwJ8DBXA
Oj1i7pnzlFP5r8B9B3NcKJknqAH7DRRGMpppuEux/xMCP2hUSA7aK5eAQv1RijBi
3AOOjpccUHJml9OPy3lWvprgvgmXngLWMp/PtTttSXoe9OBqQnXAsDqbw4vKKz8h
eyUnD1Oz16MxJSP0FTfcSf9ew1tx1LsrEhoMn8Y83uvYqmlTQvjskgAYB7uqhEbp
NnAvvMLnn3O2Z2Dk3F7hN4/n4SwoQxIX7FQFZHaELWk6GEoYpypVNcxUl6iWt3iq
eUd+ci/sbo4ouF6RT40MwbJXlNaqDQAcx3OjxUlDF0odDqa16sMwtDK5E4lPbps=
=NpWg
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--
