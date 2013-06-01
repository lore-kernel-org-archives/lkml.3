Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab3FASmZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 14:42:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39470 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab3FASmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 14:42:19 -0400
Date: Sat, 1 Jun 2013 19:42:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: lgirdwood@gmail.com, ldewangan@nvidia.com, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, ian@slimlogic.co.uk,
        balbi@ti.com
Message-ID: <20130601184209.GB16790@sirena.org.uk>
References: <1369911393-25747-1-git-send-email-kishon@ti.com>
 <20130530113247.GI5180@sirena.org.uk>
 <51A74C0D.6030205@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Content-Disposition: inline
In-Reply-To: <51A74C0D.6030205@ti.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 30, 2013 at 06:24:37PM +0530, Kishon Vijay Abraham I wrote:
> On Thursday 30 May 2013 05:02 PM, Mark Brown wrote:
> >On Thu, May 30, 2013 at 04:26:33PM +0530, Kishon Vijay Abraham I wrote:

> >>Only compile tested. Just sent a patch to get some comments
> >>/ideas on how to handle such one off regulators.
> >>to handle

> >What's unclear or confusing?  This all looks really basic...

> For instance mapping of regulator modes to smps10 modes is unclear.

If you need clarification on that you need to ask a question about it.
There is no question in your code.

> >>+	palmas_smps_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
> >>+	reg &= ~PALMAS_SMPS10_CTRL_MODE_ACTIVE_MODE_MASK;
> >>+
> >>+	if (mode == REGULATOR_MODE_NORMAL)
> >>+		reg |= SMPS10_BOOST_EN;

> >This looks like a switch statement and isn't there an update bits
> >operation?

> There can be multiple modes set at the same time. Having switch

No they can't and if you check your code you'll see that it's correctly
doing that - you're checking if the supplied mode is equal to a given
value...

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRqkB+AAoJELSic+t+oim9cZ4P/iVh2e0nY0HTv9ICpFu1YyYp
mZpqIBf/Ph3onB5bk1Bjcmo9ko4p67BNebcZVNmmj2iJkRBuAX0YFlOwiZwFrEzx
+lu9Znaa+WBFB+LxWA2rPq8j2Uh2eGwyzbtWE6rTuM8GUtPonCxmDRqQWIiw4CDM
OyWYDEwoDp6Rj/jh/sryiFmzGVWi90ZJbSz04KuhEji115s8U3Bp8ZS7MqdO1EHA
T0umsiYDCENG1BYeXa3Wi77R26JK/lv1buV65LxN7866iImgR/K2MZMhz+eXXHHa
OXoUpEcfyrHzGrM1lnQQJd7jqxCnYoCR+g2B+UzjwYBU+0NHPdzuOysf2SKxonHW
nkGTrr3y0Vtb5twEqUvyWqXjIdh1IZaWeyplWixZKNd2+oFtJb9hus+2tKAhxHda
EuEZ1NpRZ91ynBRn7YqizDKXNtIXybiHWyIhStdSr+kxeeUmthzcUjfEXUeH6kSs
VoCCwInH2n4RB+j3W66wkVqTm9kFsWfspJKoRFKVnnqpG+Ck4CGOkWmQqjEt0tsx
lybF15oeL2zRw3UvucVV54QbNIQXTcUNaFW68dYotjmq9xxeV80vCxMrpsfw+cEG
EO4qfOz2yf54p3Yr8MeWdCBcRyv0oZk7B6vPmCABwpvwAyF6vt5+gPCGu5ke3EbK
KjygZZy62RxQzmMupV53
=Z7+6
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
