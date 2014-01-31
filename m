Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbaAaNvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 08:51:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33432 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaAaNvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 08:51:33 -0500
Message-ID: <52EBAA57.1030006@pengutronix.de>
Date: Fri, 31 Jan 2014 14:51:19 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.2.0
MIME-Version: 1.0
To: Andreas Larsson <andreas@gaisler.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Wolfgang Grandegger <wg@grandegger.com>
CC: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/5] can: sja1000: cleanups and new OF property
References: <1391175277-19833-1-git-send-email-florian.vaussard@epfl.ch> <52EBA7E2.6090007@pengutronix.de> <52EBAA28.1070307@gaisler.com>
In-Reply-To: <52EBAA28.1070307@gaisler.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Q66oVvLNa2SSR9OQ93aLclqkqo1uSPIxk"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Q66oVvLNa2SSR9OQ93aLclqkqo1uSPIxk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/31/2014 02:50 PM, Andreas Larsson wrote:
> On 2014-01-31 14:40, Marc Kleine-Budde wrote:
>> On 01/31/2014 02:34 PM, Florian Vaussard wrote:
>>> Hello,
>>>
>>> (could someone with a SJA1000 on SPARC perform a functional test
>>> to see if interrupts are working? it would be great :-)
>>>
>>> Changes since v2:
>>> - Dropped patch 1 "can: sja1000: remove unused defines"
>>> - Addressed Marc's comments on patch 4 and 6 (now 3 and 5)
>>>
>>> Changes since v1:
>>> - Merge sja1000_of_platform.c into sja1000_platform.c (patch 4)
>>>
>>> The first part of this series performs serveral small cleanups
>>> (patches 1 and 2).
>>>
>>> Patch 3 merges sja1000_of_platform.c into sja1000_platform.c.
>>> Changes are pretty conservatives (mostly copy/paste/move). IRQ
>>> is treated differently in the OF and non-OF versions, thus this
>>> is where the fused version differs the most.
>>>
>>> The final part introduces the 'reg-io-width' binding (already used
>>> by some other drivers) to perform a similar job as what was done
>>> with IORESOURCE_MEM_XXBIT. This is needed on my system to correctly
>>> take into account the aliasing of the address bus.
>>>
>>> All patches were tested using OF boot on my OMAP3 system with a
>>> memory-mapped SJA1000. Thus, the non-OF path is not tested, as
>>> I do not have a platform data at hand.
>>
>> Nice, looks good now. I'll give Andreas some time to test on sparc and=

>> then apply the patches.
>=20
>=20
> I am on it. I will dig up some hardware for this on Monday to test it.

\o/

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--Q66oVvLNa2SSR9OQ93aLclqkqo1uSPIxk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlLrqlcACgkQjTAFq1RaXHMLlwCggtdKRGfRQMoiORcWHmFgy7tp
OJ0An3YK5gt+UVu+53rkdrFhYsoeUbDQ
=eKLA
-----END PGP SIGNATURE-----

--Q66oVvLNa2SSR9OQ93aLclqkqo1uSPIxk--
