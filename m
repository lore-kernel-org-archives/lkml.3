Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaEZQDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:03:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43434 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaEZQDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:03:51 -0400
Date: Mon, 26 May 2014 17:03:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Keerthy <j-keerthy@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140526160322.GI22111@sirena.org.uk>
References: <1400722007.25612.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fir3pvprPx3DK6zj"
Content-Disposition: inline
In-Reply-To: <1400722007.25612.1.camel@phoenix>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.185
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESEND][PATCH] regulator: tps65218: Convert to use
 regulator_set_voltage_time_sel
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fir3pvprPx3DK6zj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 22, 2014 at 09:26:47AM +0800, Axel Lin wrote:
> Use regulator_set_voltage_time_sel() instead of open-coded.

Applied, thanks.

--fir3pvprPx3DK6zj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTg2XGAAoJELSic+t+oim9f3sQAI2lvau9gvyjLqPDcA4FRJgB
2w4/Su1QMHkx1f1RQ7MtKQ9tYXK9P2pJqkAwZjsXGNMXtKg6SfZ6N5T5Jjb5cRxb
JLdGDe5Pcs8C4YWYew++r7OfIwd8CSQ1T3qLsGIjKujXV1qbyo/gnJotlIwtTR6S
gkHs0jTPVjw3kX+Bt2RcSVSEaZUaI6gtYZm5yPEjfWq7OjsN9wRkZVa2xDwNVdXU
iiRNEf3BT64Brwj0bJqsoSKeFwYdjZYo8IFV/pPym2hYYQA/CBsOLIjjep9B+neZ
anMmCooryONgD/Kdh1V7dolJ9aNickZr0ODPO56HDxfeWSTiGvMAhLaRTa1PCBpu
FgJF2OxkrymCgaCJ6prJVUhyuDo5nQaOsL1BocjN0LCYe/pcByEbE1uJ5AFeQ7O6
kXsa7stRVmqMhNAwweZeHNBOgDohC9VRXtjrLapXtS4dw5x4Cy3ox2Cl2dXJ+SZU
8zhPnIu+1blgH3uZHxi7tqAxuUcCq4JOXVsDSI7DjL4BZ9eTCcD0g5f9jKoRG7rm
WCYzRULUy1Tf7j1xv2N9wS0G9X3nfv6TMFnJ0zHiJNIrLzQBSPt/wn5n08SqBkpy
q3TaNPBN6xMiuaM9sGk3TXKt1cDekPAbWcy+VZqUuOYV58jYQwmYkiS0+Dr/lkBR
CiB5Lp8E6fONNURbwu5e
=gkkc
-----END PGP SIGNATURE-----

--fir3pvprPx3DK6zj--
