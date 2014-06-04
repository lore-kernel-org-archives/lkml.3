Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaFDN5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:57:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59636 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbaFDN5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:57:14 -0400
Date: Wed, 4 Jun 2014 15:57:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        tkhai@yandex.ru
Subject: Re: [PATCH 0/2] dl_{prio,task} cleanup
Message-ID: <20140604135705.GO30445@twins.programming.kicks-ass.net>
References: <1401886645.22521.39.camel@tkhai>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="42wYT+Mt3aBUaKnv"
Content-Disposition: inline
In-Reply-To: <1401886645.22521.39.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--42wYT+Mt3aBUaKnv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 04:57:25PM +0400, Kirill Tkhai wrote:
>=20
> This cleanup series adds forgotten dl_{prio,task},
> where they have to be symmetric to rt_{prio,task},
> and fixes rt_prio().

Please always Cc Juri when doing dl patches.

--42wYT+Mt3aBUaKnv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjyWxAAoJEHZH4aRLwOS6rwUP/RcLlkSZPg0myOVz3HnIP2OQ
OrimFqpgmiitwPfiO5JWfwtwcBOmO8dZvjBEX/0OjuUwDZlr808EZDVqxkmykJKl
LxUUBzr9DsybXRCVd+9X5BTX7Y89Oe9Xs3VkwP+yQ3d4ja/7fww5IuUcFq4BGnHq
4VgSSp8Di/eFSEJxhzKmoVI6YuRnkT2N4mEt471OfKorqPVxQ0ZOAnZu+PZgO0se
0Lw1QkR213+WbH5fIwt0fkSl2t7MVkAfLzr4W8O/zne6hZubx28ocEn3DoFKR8A5
UgZSj3QxsFDvaXxIip9/yb29KfOoSpBST4SDGk1nRAxoIUQ9ngreVPLxVspHyA31
Pw1JfnVNHEMRVhhr9SwagW6D2fUL/xSR6kpleOoHIbZ+KPUTc7ac8poTQ5r0SkmF
NuFNdDayp8Z7/M47IKI99L+EJsmD23JicG98mOlFTLsbv8PebGsClAS5/mEqMgaN
JCQTWG1BWBNLWb1gnYdrFIajDOAGjCTjiReR1ksOaPeG2O7FcgHf0QC0Eg+u16dE
SluZdzaoUm707/WLrGAoMOhHXj3BvAo7UrYK89qs0l6e7AJZtURZTjPoA5i/UGvG
BiM0BeFC/6DIIOX22YVyTJ0VrhtyR8NTWCsiEqAvgYPRCT5hPS7JeWjvOutd4SsF
lmxQmVmroiqzAl4dB60x
=ZUkS
-----END PGP SIGNATURE-----

--42wYT+Mt3aBUaKnv--
