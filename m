Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3HKOmM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 10:42:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45457 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab3HKOmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 10:42:10 -0400
Date: Sun, 11 Aug 2013 15:42:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Steve Twiss <stwiss.opensource@diasemi.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130811144206.GC6427@sirena.org.uk>
References: <1376065558.7023.1.camel@phoenix>
 <20130809164100.GL6427@sirena.org.uk>
 <CAFRkauABN3JihU5jynbXqh6VRvM7-P8HFWAqFPOYMDL=xa0hcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sjH5kukjteSWPjDM"
Content-Disposition: inline
In-Reply-To: <CAFRkauABN3JihU5jynbXqh6VRvM7-P8HFWAqFPOYMDL=xa0hcg@mail.gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: da9210: Remove redundant MODULE_ALIAS
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sjH5kukjteSWPjDM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 10, 2013 at 10:13:23AM +0800, Axel Lin wrote:
> 2013/8/10 Mark Brown <broonie@kernel.org>:
> > On Sat, Aug 10, 2013 at 12:25:58AM +0800, Axel Lin wrote:

> >> -MODULE_AUTHOR("S Twiss <stwiss.opensource@diasemi.com>");
> >> +MODULE_AUTHOR("Steve Twiss <stwiss.opensource@diasemi.com>");

> > It's perfectly reasonable for someone to want to be referred to by their
> > initial, or their full spelled out name, or a nickname, or...

> Oh, I didn't realize that naming could be intentional....
> If Steve does not confirm this fix is good, I'll send a v2.

Think JK Rowling or CS Lewis :)

--sjH5kukjteSWPjDM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSB6K7AAoJELSic+t+oim9bTEQAJynIOE3hsVef1sTSoTCWGD8
nQHmlOL4DHOE0WZ5U1DYlc5i8xlIT6OEOqGYiIazHxgp0P9XqODqsLXKhOJe8V0i
lVHQCwK2xVFJEfuiAm7VpEmX7YSmghlH03azxdK8J0yYCupP+9MqcV5YmaiVHWdL
mKbN/C25HwNyPrrsI0aZG0JmP9umE+YRTndTQbcHwEIVw3uxyuz4jcS+fbzJSL0c
NTWdTiEPe4s0Z9aBAklf6C7QXD61lbJuyzNyLaIMJx8Z0KVYwInqVdPSr8xSAyUE
Y+AZ5sUh9LSw1KbjppakCUKaQ5/ibctQh+7jk09QDuVseVBS9b0n3esevGIIcCoy
pPhRpK3XBqRlLWBmXhmKRoK8f/J5WssY2F6dPP4kS5hgQFMxg0z4E+Y0N5jmbZKS
RapFBRP0YyhBB1DvYv42R/Ivo/Aj/Vi24YLgiJ+nkffgf4KU2ET04mehD6bXOO9Y
cv14Hci2c3urv1oPXrcCJzmmL+wsV39sdfgEYE0hpyw0W6eOfxYN0FXiEAyQJRbl
fquiDcXLRm8VgKp/4jQfWZEDfjxZ6xOQTZqpzcR92yFOi94RNqW980/wUQEQZFzB
pEBIbvkGHfYS9LluZRiyuOjc4Z01WJO6JRaOQcjbhj2UeWn5kWsdmOv3hkOpgYSE
RvYafPk0MaldN8dir+gi
=5JKT
-----END PGP SIGNATURE-----

--sjH5kukjteSWPjDM--
