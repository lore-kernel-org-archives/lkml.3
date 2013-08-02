Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3HBKaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:30:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47015 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab3HBKaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:30:09 -0400
Date: Fri, 2 Aug 2013 11:29:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Robin Gong <b38343@freescale.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130802102945.GM9858@sirena.org.uk>
References: <1375358396.15804.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZrTMdTG7MEja30I6"
Content-Disposition: inline
In-Reply-To: <1375358396.15804.1.camel@phoenix>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: pfuze100: Fix off-by-one for max_register
 setting
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZrTMdTG7MEja30I6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 01, 2013 at 07:59:56PM +0800, Axel Lin wrote:
> max_register should be register count - 1.

Applied, thanks.

--ZrTMdTG7MEja30I6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+4oVAAoJELSic+t+oim9k3MP/34tj/5Q1xcEJqRH31ITNOok
2UZJ75PlMV65SObJdG8u8N+48Nm/45Fm83JxTknbdnYeiLWoPcVNJWvuVtzmco31
4RQtudy7ktrQIC8/+nafM+0aE70fHuYhXwlRAnl3S7yt2yKjQX07T1wF1Jjs3pCH
H/p+nPvxqWFIM1syRZFblL0oR59LRG62NVGD+g/OKrKL+OsAl8Wyp8w/khFe0s7O
twVPAWfwzCuVA86BNqYCQ/mJisJtF7XfkF0LtYo0ljRG96+PsSfGiAReyv27Je/j
jQwhkDDaJw4ie5PrMO9AzcTFAEfXvmmtKHTwG5hq8dAW7FREPqN8kpZToyYOc93+
wn49BGRr+zgjkrWR7+XFUIyy315zanf5+3TFF1d2wX8Rfr1+lPhw5kSYi7ddQMbV
dAjRJXVtAfcKojIgP5MIXaNhy87xMJqL81ICw6DHEVPgG1HSws+/wnHBvvHaaYZq
1/QJ/gBpMfXcYJE2XH2ssL3r7uJjxVtgToyPOrNVzEkW9t/LdGbXKKT4nONMhoBH
s07Wpqdl5gsL5Zol9JmoMpoWrTsY4zmKKEs9ib/plc8+xI2dBdnCS4Qd+ceA4gb+
8fwgSjutU4p4lpv89ngR49CbRpzTHL9stKR4iA/NdWTtPUavYA48H/4Tx5kEZEWb
HORAglyI9eCphPzpNcCn
=Rr0l
-----END PGP SIGNATURE-----

--ZrTMdTG7MEja30I6--
