Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbaJ1VZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:25:07 -0400
Received: from down.free-electrons.com ([37.187.137.238]:36862 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751153AbaJ1VZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:25:05 -0400
Date: Tue, 28 Oct 2014 22:20:48 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH v3 0/2] dmaengine: Add driver documentation
Message-ID: <20141028212048.GD9255@lukather>
References: <1414529750-14431-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YToU2i3Vx8H2dn7O"
Content-Disposition: inline
In-Reply-To: <1414529750-14431-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YToU2i3Vx8H2dn7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 09:55:48PM +0100, Maxime Ripard wrote:
> Hi,
>=20
> This is the third attempt at documenting how to write a dmaengine
> driver.
>=20
> Changes from v2:
>   - English corrections from Randy Dunlap
>   - Reworked the burst explanations
>   - Reworked the interleaved transfers explanations

And:
  - Removed the	mention	of chancnt
  - Documented DMA_INTERRUPT
  - Various minor addtions/reworks here	and there

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--YToU2i3Vx8H2dn7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUAiwAAoJEBx+YmzsjxAgzvMQAIV8pAGuLfiOXKeIt5CHkEz+
Zjk+E/ajM1omVZBekDl1AVxfvWJxDY7Ybqob4H7k+jy4NjLBCZX9E3ISPqYJ3FAB
ZEkBeivfcWuqPtF+YZwktRAawHFi5xkuAsKITe8O5lP+bjzegGHietRDRCi75GG5
4Cpw2jXLZfv7c2dZX1hAfTqtcIdFxd429uzZldE1b5gOeTVAsKF+9GNktGWJO1eN
6gv+VvaUfDZdi4ZrehgnvlBHJIRZqRN9Htrtvkym4F257QJKkAVaKIkAtei6flUI
BofkvXG/S0LgcKZ7T7zPCt9OA2LtMtNsk1PvSdi4nfpWlLQpVXPh1UC557oxOU6q
7Ru/avmpRd5RSHl+O7ejjwExIaHAOXZ/0vcVo9YxqoNWA4RE77PfIWThrwBq8mDw
avXlXj/PO2abfoLE0KcQBqRiPQPL64V0bNd8GvByAW9ss00U7gH8WxedeJPND69M
4tL0cUWB7TO5+qzDmmk6+Y/wOp33mMnVEhl1EODmsJUaQUt6PlMhtCYT42z7DGbQ
wpbRqNU/PRFx7qi49KRiKWYVM6q9lgIAcEzvICi4xFo2kuzZtXXM1Vt/1We8yu8T
uZ24DEMRYFbqNxa3HfaC2J8TGw6fhWAUh2MrPoeYW0BR71olMKLQgA/SciUmm0qT
4hYcftUUyQrAQ4w+UJMu
=VzQf
-----END PGP SIGNATURE-----

--YToU2i3Vx8H2dn7O--
