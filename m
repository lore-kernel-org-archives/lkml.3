Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab3DDKQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:16:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38443 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758294Ab3DDKQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:16:19 -0400
Message-ID: <515D52E8.4010206@ti.com>
Date: Thu, 4 Apr 2013 13:16:08 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <vt8500-wm8505-linux-kernel@googlegroups.com>,
        <linux-arm-kernel@lists.infradead.org>, <plagnioj@jcrosoft.com>
Subject: Re: [PATCHv3 0/6] fb: vt8500: patches for 3.10
References: <1364926838-6721-1-git-send-email-linux@prisktech.co.nz> <515D0F5E.5010805@prisktech.co.nz>
In-Reply-To: <515D0F5E.5010805@prisktech.co.nz>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig70FA6F1D82F01F891C43FB5B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig70FA6F1D82F01F891C43FB5B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-04-04 08:27, Tony Prisk wrote:

> Tomi,
>=20
> If no one has any further comments, are you still prepared to take this=

> series?
> If so, I will send a pull-request.

Yes, I can take it. No need for pull-request, it was simple enough to
apply. I'll push it to linux-next today or tomorrow.

> With regards to the earlier concern about your current patch series, I
> think its easiest if you do take this series then you could do a fixup
> patch if this one is merged first. From what I remember of your series,=

> it is basically a rename of of_get_display_timings() to
> of_get_display_timing() and some new code which I don't use. Seems a
> rather trivial patch for a fixup later.

Yes, I can fix it. Should be trivial.

 Tomi



--------------enig70FA6F1D82F01F891C43FB5B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRXVLoAAoJEPo9qoy8lh71OSQQAI7d5OZ6hV+edvyK7Kgb+2Q5
OWzzkNA81QP4Jk4sZ7HZhFgjdYZOLwSxmP0CKg6X8AI9/JE+Fw4RTPjz0TnH/R9S
jBdQFqLCP2gg5raI5/UXHQqlMMvTqKClKGB3U3SqmO4TbD1u/lTr01vxZHTKdvDO
/XY8yiwBJGiGxw7f/nMjx8zBNQPmEMZZYm/t90IBQgIPfHtqOJxEVfW8zpyL0ao+
ESii37XFCgV3Di63tFSLd4cqnf8NMiB5yhgeyQNEgVEeWyuQh1cWfbqRuaCED/nw
6S+EHKCr4fEiw9SDuRIUrbwCLaCQ1ddMIvTDohnuC2p5Mr9dey8di2WFDAm7cw9U
dPIs+hs0JSb3aC5e3nVm5sZaALmjXAw9N2rK7pnLPOIq2f3yPeHD6Weh6zVtcq87
PB+GvIYIcB97wJILBVl1BLzMgcIXRM9rsBvC2hNz/Lj3RJksRS+QhJOz5OyDPWKX
tWMePvZX8AcoTlP98tzoM/QyM9YBliwOibieBQNuhIs6qIcxtjYcKdLM0uFWcGTh
lSCCX5ntyHIO8kWRWLIGyZyIHYbiNI01j3bxaxU0NhNizBH9nWDRestRMeifzIE+
vTpsagSzcSlO+FtBDlBt46lLzr8nWvnMQjRop9JZ/L0YH7K+yaeEMbzjxLtgBV5i
2NrKih4C1IxZ2kSfuVZa
=Ccg/
-----END PGP SIGNATURE-----

--------------enig70FA6F1D82F01F891C43FB5B--
