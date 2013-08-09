Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967048Ab3HIKpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:45:46 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48887 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab3HIKpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:45:45 -0400
Date: Fri, 9 Aug 2013 11:45:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130809104522.GU6427@sirena.org.uk>
References: <1376033367.29104.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3T4dLCyS4EPlIT+v"
Content-Disposition: inline
In-Reply-To: <1376033367.29104.2.camel@phoenix>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Move
 list_voltage_{linear,linear_range,table} to helpers.c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3T4dLCyS4EPlIT+v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 09, 2013 at 03:29:27PM +0800, Axel Lin wrote:
> Move regulator_list_voltage_{linear,linear_range,table} helper functions to
> helpers.c.

Applied, thanks.

--3T4dLCyS4EPlIT+v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSBMg+AAoJELSic+t+oim96NAQAJoyhI1jxgNMlRm4BFTTgJte
JLX0UbX8C4BBX3iO9vZOwXN264gz9ZWo6mFOcJTVsVyNxJyWBsAEiXw9G89+Wclo
H9BGE1pFwSU+8zn7ifAFoFLRLwUUdd42Wl5J6kCws5jLrICh9LQ+inIPhU15K5WY
/fOh5MpWD6rHiW9wIyFgx6bk2qChu5Wcluzi/Ee/c6CjuN59FBsSX1kKbQ5BmrEd
D1suMNSpsAGqGPpBcTmRuFgLHLP3HLdbVqkNJYYNgtT5Uv7S5cE8vFwyty5FmFLS
dZ7xSCYHxIWJrFvZx4ktiVkFjk5e9IEr/pwwwm+fST+SjKxP2RXVTRiiS++OIzUD
IBLdjh8z3Y0gjk599ix9d+fYA1ro4W0ok6bm4qABVObMyJC40L6c/oUPQPZNG1PE
KQ2JWem/IafQJ+HXBFPxwjzzydMfo2sBt0ALQdVpASCAch6DyFfEICrJhj+T3Pym
x8ii+n7IHG/JqRQ+0vnFYuZfrCf48jf476UJe9A76r5PYccrIOAOEoDLM7MM0UPr
8bt4qpEsG5z8Ic2qdjOjHEYelaoCHoIG4LOlAatvkkrDdWLhTrsUU/8FewL/j5Tr
QJ76qvfN787QcG5lIzh96o4fwnUhOSpCwqh6UnJm4xg7JKG4v/G3FwkRISt/3JwQ
tCo9AfMoBATrBQnzHj45
=aVOR
-----END PGP SIGNATURE-----

--3T4dLCyS4EPlIT+v--
