Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbaIPJaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:30:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:57310 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbaIPJaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:30:08 -0400
Date: Tue, 16 Sep 2014 11:30:00 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pm@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        devicetree@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v6 0/8] charger/mfd: max14577: Add support for MAX77836
Message-ID: <20140916093000.GA31655@earth.universe>
References: <1410504840-23543-1-git-send-email-k.kozlowski@samsung.com>
 <20140915225220.GH25162@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20140915225220.GH25162@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 15, 2014 at 11:52:20PM +0100, Lee Jones wrote:
> On Fri, 12 Sep 2014, Krzysztof Kozlowski wrote:
> > This is a sixth version of patches adding support for
> > MAX77836 device to the max14577 drivers.
> >=20
> > This patchset has been on the lists for quite long time and was already
> > reviewed by all necessary maintainers except power supply.
> > I need acks from power supply subsystem (patches: 3, 5-8).
>=20
> Give this set a few more days for the Power guys to respond.  If they
> don't, ping me and I will just apply the set.

Acked-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUGAMYAAoJENju1/PIO/qac50P/3csfMvdBoikhV+JQWXFVTN9
6P5fFBSQb2OG4GhE44vjRt2vLWOkjyOb4ohHTTgPrYXexsm+l87k1OmTloIXNScr
Mfeiv9RtUYRgpY2TgOXrYbKKtX4QmSYqRB3SNrlH6IeyStQaKeDPRl0MtkuBtMBu
/D8Coq2F5GvmKe53Faiv0ulbcyvuFesajy6zBHhvvZet1RTPDz2ixBG1bm4B84Nj
Xk5FJzhgfGYag6kFr8Zv7uIKTVMz2dAncdnRiS5jH2TanFaZt1p4WA4E8okqp0gN
7xSkbj2T1WxQJt6r4RYPs6bjcQZ+cVj7VvrGFNJaB0IW2jOg+tOh+sm4FIAW106c
U7NYR/mHXTahVlI3ZGpVWKKH0Kfv9ceEGHp54V4nPBfF5D5JPgpPZFpMBqZt/ARQ
mInE6lxR5L99zu8d+NfYWjyRi3vip4ZrTJzuEu6WV4okPpJxI09PgjYT/PruQjX8
llAPuBqpvUoPNOYedmsHYUzj2lRLRNMt8OBPNGhwfKnU+t/X/rb20A7chgatwC6m
VGNJ2V7I4+injByz0ImLnHAyaroJ8+oHVw+ee59LZBcaTBbriom+QUDRf/XXCi4n
33SPeR0FXmoC23GfAHgR2F0nR+GVPax5ZaPMz6dWlnq3joWufbofDpW0RqEeLDwS
B43dc0Gw+jlplFJ8q0aM
=Wz+R
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
