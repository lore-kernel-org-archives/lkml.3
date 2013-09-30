Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab3I3XZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 19:25:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57201 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab3I3XZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 19:25:53 -0400
Date: Tue, 1 Oct 2013 00:25:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Message-ID: <20130930232548.GH19304@sirena.org.uk>
References: <1380378897-7164-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <5248B9BA.9020003@samsung.com>
 <20130930095202.GY3635@opensource.wolfsonmicro.com>
 <524A0369.1080101@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K5rlT6r/WqkiQKGB"
Content-Disposition: inline
In-Reply-To: <524A0369.1080101@samsung.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] extcon: arizona: Get pdata from arizona structure not
 device
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K5rlT6r/WqkiQKGB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 01, 2013 at 08:04:09AM +0900, Chanwoo Choi wrote:
> On 09/30/2013 06:52 PM, Charles Keepax wrote:

> > I would also be happy to implement this as a NULL check on the
> > pdata when we use it if that is preferable? But since we have the
> > cached pdata seems we might as well use it.

> I find below pdata list for extcon-arizona driver.
> But, drivers/mfd/arizona-core.c don't parse dt data for below pdata list
> of extcon-arizona. Did you test this patch for extcon-arizona operation?

Charles had some patches out for review but there were issues with the
DT binding that meant it needs a respin - it will need to support extcon
at some point.

--K5rlT6r/WqkiQKGB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSgh4AAoJELSic+t+oim9VZQP/2yTD3vmy3/qp0scmPECduXc
OM8rB1JOFoVgIG24i40B4PJq3duBmfPrqy2FLSclYCA3HpEmBdV6rNXjdgiZyDc7
q62y/vcYiVjF2987sDdFRuHDhTGAUl4sw1JUy7aLfEsky/qD7pEPHXIQ5zr0DB6r
joKQM88dBLKULUDCetqBKBX2/Wlc8Xbja51AvS42SD3y9n6HzUC7usNKgcizPI+Y
nQSK2L/TkSa4MYOF6U4YPu4Kl/YDYD54/02DxqEB1WwOPFubf/c13sM03bZbqCvb
flov4o5xAsSdV7h7MjZZVTiWEdtZ9c+TLKxa8bj4xcWQimeTKB3TIjgIdxx+UuKj
ouyYUOEF4ROcn/nexYg6T01AwuyYFe7By3wsi+5LDoHzAP9LVBKCg8YQoe3VWV5/
0xEXRQo2HOXebiFa3/oau4uVEkfiIXAdtZChSdMflNKVrqRzzJcu2KjFFFKGP2Zx
sQI4gZhn6xlWeF3kqAEKrY2rhOS5i3rE1TtESIqIixc12VxpXrzNYX8AmpzQULHr
rw8h2BRsSIfyz7O81k4cbzZHzeOCtGLDjiBmw+C19PXSzLrcCuh6NK850Xcblo9X
5c0kVzgnI3HfmorfThkWAWrSPvoAZ55E8PUo18gYDU7qieyfOwf7XkRzrtEtPOfQ
ZoO8kQJh7TtpPGWCbKMe
=uUn5
-----END PGP SIGNATURE-----

--K5rlT6r/WqkiQKGB--
