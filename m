Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaF0QIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:08:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33087 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaF0QIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:08:46 -0400
Date: Fri, 27 Jun 2014 17:07:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Wenyou Yang <wenyou.yang@atmel.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Heiko Stuebner <heiko@sntech.de>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20140627160725.GQ23300@sirena.org.uk>
References: <1403451105-31929-1-git-send-email-b.galvani@gmail.com>
 <1403451105-31929-3-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mOiujxrFkW1D5yf7"
Content-Disposition: inline
In-Reply-To: <1403451105-31929-3-git-send-email-b.galvani@gmail.com>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/5] regulator: act8865: set correct number of regulators
 in pdata
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mOiujxrFkW1D5yf7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 22, 2014 at 05:31:42PM +0200, Beniamino Galvani wrote:
> When platform data is populated from DT all the regulators are
> instantiated and the value of num_regulators should be the number of
> all available regulators rather than the number of matched ones.

Could you go into more detail on your logic on this one please?  The
platform data (and DT configuration) for regulators should be completely
optional.

--mOiujxrFkW1D5yf7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrZa6AAoJELSic+t+oim9i8kP/jVroVZJmC/cmNj62Wcocffe
E4fChDT1Km+gZ9Fk39AgU7SSImHxQhntsHc78WkBdyGKqCcwTQcRDbZBu5ull8XC
drDd15JTRDIu/S6aH9u+gZKk9ZghE/No+06nlzDU9u2KW8E3k8Gbs4mYKXh8qQfe
brQ8VCHulIj9bD4MpCW7Zh8oeP0kUtYOlT7G901Qb+RvqHxxVUG5SeSR8WBQld37
tc2wD7Ddt1FsMkZuR2SgtpTZSn3xjSJOIT3rgxGZbwO0NEURTbpBrqfGpT6ExkYq
4F+7uvwF6xM9wDC4eVXWJOvhGlbfuuGpf3W5w9mi5DtjtzLwsEvKDwnlU7asiUDo
m7cDeEo1BwHfBLUZOOHEEUDAOZhEkhWsgtkKaCP2MnKSOuweAb0HaU3R2LaFTQE4
nvt4aSR0ArxXfCaXqcczAzfOTfvEBg2MxYVgw3ITE1adIAuttBLr6JxzZLmgP9Ob
O5jsqkunrqwyZyXfPpEUTueMs2yXdf9QI5wOvLKvhAXlYIk+sxueCSoqBfKQWaRO
KUlLvDfzPRjVm6I1yHH7xnp8y/RwmWbeylVE40H/mXhPOkRkJjBsKovn4K5sGNC0
QyOnJS1EvS5B9ZBV1tm9FFc4FEzlIZRGG9t59m54asEXJuBLwFKPdKySbLf6eQZd
XdKiylvAMQRzG7lyGWZH
=RkoU
-----END PGP SIGNATURE-----

--mOiujxrFkW1D5yf7--
