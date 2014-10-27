Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaJ0SoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:44:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:57250 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbaJ0SoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:44:01 -0400
Date: Mon, 27 Oct 2014 19:43:55 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 0/2] power: charger-manager: Fixes for unbinding other psy
Message-ID: <20141027184354.GA18965@earth.universe>
References: <1413207271-23836-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <1413207271-23836-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 13, 2014 at 03:34:29PM +0200, Krzysztof Kozlowski wrote:
> These are two fixes for accessing old power supply by charger manager
> after unbinding the driver implementing given power supply.
>=20
> Actually the source of these two bugs and the solution for them is the
> same in both patches. However I decided to split this because fixing
> this was quite intrusive and squashed patch would be rather big.

pulled into next branch of battery-2.6.git. I will include this in
the 3.18-rc pull request.

-- Sebastian

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUTpJqAAoJENju1/PIO/qa6TEP/1Ag0oG2xXugNceva/iTnROi
gjXecTXCQI29Mo0+eDYjGkcZGAemnjYpNyXHJIdro/7M97esXOzhOFjWGsYAWttE
YU2Gf0zeGu22uDpFUKSWODdR99UIOzHuXc6Pxq+z56iUiK+Ij3egPh2pxTRYg1mD
pxJBv4ynHUH8ufH6cGqZdGpyrHgF9vPmtB+b107P2ndMuqCA3rmqVP6jA8eVnniX
V3e5zBWiJ+DipaMFkjbYsjCZnyvTF0xrXnZCqFi2UD2KiPrbpBRuValsoj7nsXmd
nS1pboLshj187TY3SAP1NfGdpd46U2yAIyBMe1V2Rt6iQD7HV3Jp0GzW4fmRFmH9
KYYZnu+XnmHYAFDWAR2N4+2DhyfgATt+xEqBLz+6xscSpAdxj/KKWcdSDpSWjCUI
/9zAYV7cjKD6GMH5UlC2UHiOi+Xf2ZZlin3DKOgbOqm6NlMit3KZI29klKEsdozQ
uOoI9aSAgkZQ98MLe8uIq47OX+c9lSb+aI6nKiqN9OSOZZaw62UN0ansjmDQEwoe
9UIrCAj39xzSLxsndjvfoWis5MNqt5Ukl03ZeSBFJlIawxa0igWRJX5QxTvOL2+A
G0fMcpLB9F/o9QMS2PQfh7YeoiVDMfA88WtbTnnS7VCxfPpdvDv/VkenaT2JJXX1
ymLEVYiHfhJn7/kvHztr
=+NNJ
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
