Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaKJKDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:03:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55437 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaKJKDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:03:50 -0500
Date: Mon, 10 Nov 2014 10:02:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
Message-ID: <20141110100224.GG3815@sirena.org.uk>
References: <20141110153132.259d49d9@canb.auug.org.au>
 <20141110043853.GA25797@kroah.com>
 <20141110155142.6c76de7b@canb.auug.org.au>
 <20141110050719.GA16980@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P5xTlxNLdns8vXW+"
Content-Disposition: inline
In-Reply-To: <20141110050719.GA16980@kroah.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: manual merge of the driver-core tree with the
 sound-asoc tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P5xTlxNLdns8vXW+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 10, 2014 at 02:07:19PM +0900, Greg KH wrote:
> On Mon, Nov 10, 2014 at 03:51:42PM +1100, Stephen Rothwell wrote:

> > I assume that there was a good reason not to farm these patches out to
> > their respective maintainers?

> Yes, It was easier to hit everything in one tree, at one time, so that
> is what Wolfram did.  Sorry for the merge conflicts, I didn't think
> anyone would be adding .driver attributes to files after they had been
> added to the tree.

People are rather more likely to do that if they know that not adding
driver attributes is a thing, and that's more likely to happen if you
tell people that this change is happening, for example by sending the
patches to them.  This merge conflict was the first I'd heard of this
being something we wanted to do.

--P5xTlxNLdns8vXW+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUYI0vAAoJECTWi3JdVIfQ6bMH/R+In8J+XvqgARfGFcdrVJV0
GznxqoqrMFolgcAMvTAtcF2s0ZHYVUkHYD619AB/6WodhS+GFikyBlGqV98TIwKv
ps3qjtJQbe8Z1hx+CO6TyF0aEHjmu3utFzME5HjUCHlduQdoJoTaPNYCCLHO2OvW
5C9gfkzSF1aj3mj5bXlSRDXA1g8SMsrN0Dqj2Q4bk2+sUs9P7KDXRAhJdAKios/q
mWklA7ATaDD2pQpYKXHBzshaIdBYuHhaPEbQVTxhLygERg+/RczZggVyBo5D2htk
2CsWAJ/PTlZsyKrCZ1Cdnv+QYof4DoAtf+0jjbDoFPvfFkfp0Tea6VScLJ22zHA=
=SNfm
-----END PGP SIGNATURE-----

--P5xTlxNLdns8vXW+--
