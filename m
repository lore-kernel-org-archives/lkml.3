Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaHPVdl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 17:33:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38869 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaHPVdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 17:33:38 -0400
Date: Sat, 16 Aug 2014 14:08:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Message-ID: <20140816130824.GE28623@sirena.org.uk>
References: <1405422173-15050-1-git-send-email-amit.daniel@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xA/XKXTdy9G3iaIz"
Content-Disposition: inline
In-Reply-To: <1405422173-15050-1-git-send-email-amit.daniel@samsung.com>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.70.240
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/3] regulator: s2mpxxx: Move regulator min/step
 voltages in common place
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xA/XKXTdy9G3iaIz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 15, 2014 at 04:32:51PM +0530, Amit Daniel Kachhap wrote:
> This is a cleanup patch and moves min/step voltages in a common samsung
> header file so that they can be used by other s2mpxxx PMIC drivers. Only
> few required macros are added currently and others can be added if needed.

Applied all, thanks.

--xA/XKXTdy9G3iaIz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT71fEAAoJELSic+t+oim9fsMP/13Rf4Xeskh010CqMQoQVCnN
ZXYGjJkBjDs2wJ2pmLZn419tgVdkFKrPD2E14qSJ5crZ+QOomKyjTETWUG9e43Fc
xlrBX20e7OBAxesrjil34A9VboJtHjSKcu4seGLGfNKgP2tPeGDq4Y9L53dKRX5J
2nn3eBKYSrS2qKLENmVh8hmliwrxBC5qIKMxmMd7xXf1BnRRrxH8X+/4hdsB2ske
RDJ2z8XpwPoDm0dXtrLui5oylkJRmlajl9CAfEk/dav4TNN/AEzQ3qROyy12WNAX
JDBw2kKUGRnzPscLLJMMJCyge+lox2XKli7836Je0FdJcFeb5fdH2bWvyb68u1lJ
llWJE7+oD+FCCRKU00qWvU4WG/yuTn4oHXnniMYOcPXu0SBpNKOU5vMfZ7bE0Svr
LwApnxRNFLWsSfSz27uZDtmBAK4wetN61dEGD7SRbqKzpK9Y9yqJXvqXoUSFttWu
o8sPEAxpfQI3cYMo953bpLJKiQSSWU9VIwzAAbrBcqYmJ2N7hvaYD8n0C8FVa7XF
c3oD/qtJj08ZwN/DUF3zHQteYzb9/tNzWibTHxU1zkO/qespgqL11d0ZB1OsuU9U
WrP7hhT9saUjvwEY3UmU0QbTxKZV7bJJnqQ871K55l6gsDLFU+PgbCeIzI1hHkNY
vH+5VdZJ7MZg+fuPhjV9
=kuKi
-----END PGP SIGNATURE-----

--xA/XKXTdy9G3iaIz--
