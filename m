Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513AbaFCI0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:26:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46302 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaFCI0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:26:52 -0400
Date: Tue, 3 Jun 2014 10:26:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] sched: Fix sched_policy < 0 comparison
Message-ID: <20140603082638.GL11096@twins.programming.kicks-ass.net>
References: <1401741514-7045-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fPlFr9CTKi+yOJ4Y"
Content-Disposition: inline
In-Reply-To: <1401741514-7045-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fPlFr9CTKi+yOJ4Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 02, 2014 at 10:38:34PM +0200, Richard Weinberger wrote:
> attr.sched_policy is u32, therefore a comparison against < 0 is never tru=
e.
> Fix this by casting sched_policy to int.
>=20
> This issue was reported by coverity CID 1219934.
>=20
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Thanks!

--fPlFr9CTKi+yOJ4Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjYa+AAoJEHZH4aRLwOS6yXQP/Am63YNsL6uEDmhIYUpwVFak
s6C0urvIcx8J1n679u3uETTlzoxjjvHZ/SCMg9QcTnDEzMaD/hDBaFPMCWDOYJvy
YExbdjcYyr9j6Z3XBn/V+dzAa1SuCUG112J0G9zhktE+FUWKPTXTvzzKdkD+X0JK
UB3YB5PnDq1vMR+eFPq4N+aZ2cGCFA4WwpjBd3/S4CX5uqnxaqb89iBDdXR/mZhK
xxdCIHyZl4heG7j4WBpWK//rqBHWfKn1Lwh7Hjeb34pRAL1sO21pIsG2kGBsJTfV
g/MbEupp2FDRzqRSNaEF0JIzBdFsvVgTQ/yfuvWCKwFWz9Y0qm9WqaZzN7TYi3KX
U77yFieU0H8crWPzv8V0sBiQVozmIY29qf9AD/H+NdPLmCJe9C1EZ0Pdg5rFOIJ1
RmGteJJSXk0jraxmc2sMOjdiMIUhqxoqks0PPnm/+fxQSBHjG12B1nbao7h9xtGu
b++6XWf5XWuG3qs+c0M7ShbeLy1tbUBecWa4Ei1gMTU4kYbHzPNf8MQfg4SOpdQL
3xg+KtpxPzFG7Xg5W4iEFIA+ODsF94lpYoiQ0UfDljrWDd4t4tUDvAvDuorVgw+i
blQ84LVm883OeyfxAfldq5R7XjdW4yaGoP3b6M30z/2vncEtJ6GMGDa2ss64ds/b
PRpyjRR1NLz4ygF1swYz
=eAtj
-----END PGP SIGNATURE-----

--fPlFr9CTKi+yOJ4Y--
