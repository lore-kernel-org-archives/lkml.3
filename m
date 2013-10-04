Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab3JDKud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:50:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50359 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3JDKuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:50:32 -0400
Date: Fri, 4 Oct 2013 11:50:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Message-ID: <20131004105026.GM27287@sirena.org.uk>
References: <1380880098-25188-1-git-send-email-sachin.kamat@linaro.org>
 <1380880098-25188-2-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsSkVHHhotaZRe1D"
Content-Disposition: inline
In-Reply-To: <1380880098-25188-2-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: gpio: Remove redundant break
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsSkVHHhotaZRe1D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 04, 2013 at 03:18:18PM +0530, Sachin Kamat wrote:
> 'break' after goto has no effect. Remove it.

Applied, thanks.

--KsSkVHHhotaZRe1D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTp1vAAoJELSic+t+oim9/I8P/095xwANgF5e/aX5bfTcgmQ0
4njjr5Tb9KWyjSFFqT/VWW+kZNcDy+wVVTXx8/TXC4R3DYMdzD6Zi1WUiuyuJRJh
tqeNK+Jy0EIjDRS8M0OMGxjrweb7RNL2XMn9i+4VGg6lHd9lx8wR5lOdg+2ROnNp
HogHnzj0G3+6FUv8kNLzQTmrXeqlJjqWnC84Aq+l5l5R5twiYY66ElDbQ9+jTyVB
wmVUhmej9A0ghpXIaQuqX47yNIAQsOug9IibAMkm/IIa1LoVuHwG7+HbaqpIrMii
NYVbO5ybDl5q/S4rrqRGj+CwTNjmlvoEg2ijJ7kQTngn7qnK6ALsqwrqYU7keLjG
pe8RZoCo71T5jx/4KnGhDfgCXcPqtC+KV2grOkdwpncRju4qxSM2zPdaAcqhg4oV
HCrG/qhhPVM5/GzBESg1n9qaEyDmQMmiDK+0jbSKyKoKF1QPdWSfcrrS9tCRG6g2
uuHQYHBdltWTNKEzJtw0lH7WOlcCuSIS1bE2POe3C26tuD9FgXPfD8jLZbdX4oUZ
uDYPprx1w55m+gfSpxR801fm6PmD/sroWFW5RRdJFQ5krauEvA2MeanQBhBH/l50
t56jMTqOpPnWvv7GhhWALXfvZcmNh/cQoeapiorZF9lrtno1tTNf/LdBkVh0BU3a
pNRMkeriJE7UYXAI1a6c
=mvj/
-----END PGP SIGNATURE-----

--KsSkVHHhotaZRe1D--
