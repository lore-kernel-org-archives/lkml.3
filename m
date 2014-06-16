Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaFPOho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:37:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44009 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaFPOhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:37:41 -0400
Date: Mon, 16 Jun 2014 15:37:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Andreas Schwab <schwab@suse.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Jambor <mjambor@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        linux-kernel@vger.kernel.org, gcc@gcc.gnu.org,
        linux-sparse@vger.kernel.org
Message-ID: <20140616143703.GF5099@sirena.org.uk>
References: <alpine.LNX.2.00.1406101517300.9378@pobox.suse.cz>
 <20140616102927.GA2994@mwanda>
 <mvmsin51605.fsf@hawking.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j5J5lYLHcSGsXTNV"
Content-Disposition: inline
In-Reply-To: <mvmsin51605.fsf@hawking.suse.de>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] tell gcc optimizer to never introduce new data races
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j5J5lYLHcSGsXTNV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 16, 2014 at 12:52:10PM +0200, Andreas Schwab wrote:
> Dan Carpenter <dan.carpenter@oracle.com> writes:

> > Adding "--param allow-store-data-races=0" to the GCC options for the
> > kernel breaks C=1 because Sparse isn't expecting a GCC option with that
> > format.

> Please try --param=allow-store-data-races=0 instead.

That appears to work for me.

--j5J5lYLHcSGsXTNV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTnwEMAAoJELSic+t+oim9V18P/jBvkywh+YQMj8yAbpOmvBiv
nzkFZxdSSKgqrjSz8kxt2D19jx8HzNVXIPY3Kb8jqwcOT/YWRYkey+AkMFyhDOpt
fT7i1zv5TOV2wDgspXRJwLLYCfMc/y0BpEGm8J7Td8NbxSpn8UNdqK2nCdE7j+fI
Hx4t3Pdfthb0od6Os9gVZLyIbJfcU+3BugTxkQ3lxXoJQDKbc5jT1dLw02GORJ0y
Y7mQNZZyHYvQmucBm4k54mqc3X/rJSyf73EV5jgpQx0DZu0OI4XMC5eIODbmhFl9
Xo0N5E3s+xbjv4mUAvWYcjZGDap7/Gugz5TMSeDQjRLLBUvMwmerj8wNx4zLwnay
jqF63GXYhLi7mFrk5sI5KdKlxAKj3l9MhPZBnbo8EjcZrTkmI7aBcFbd9VUZBJo3
Gucx6LSBKAnfm/IZdsVyOZ90ngUSowoBq4mqodDC01oLdd45Ek1uaYqNeh77JUPJ
oiOUGgG3bpIz86v18/CpcliZ9fS94aFv0YdIkA3MpqqN41pwBdBKCV/AnKYuDSIq
qzqDmiCc/DtlWZzORcr9OLfSvqMpijDcPRecH1f1mwl+upMgILvjTLsbfOkKAKPH
tJCcU2fzTRLZAkq01HmdU9pa1nYC4kera5NvUOloGIi03TC7uVqZmieRF91+kyns
MTjYAnN+WCq+AIk3ctpU
=FSo7
-----END PGP SIGNATURE-----

--j5J5lYLHcSGsXTNV--
