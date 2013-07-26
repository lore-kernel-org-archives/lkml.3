Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab3GZHcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 03:32:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37954 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab3GZHcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 03:32:01 -0400
Message-ID: <51F225E1.7000609@ti.com>
Date: Fri, 26 Jul 2013 10:31:45 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] driver/vga16fb.c: remove the unused variable "dev"
 of function vga16fb_destroy()
References: <51F0F88D.8060903@cn.fujitsu.com>  <CAMuHMdXWpdTD4sHat9sm5pvXVeGNNKMF6eEN=bUK4qU0H6i1Aw@mail.gmail.com> <1374747739.29835.45.camel@x61.thuisdomein>
In-Reply-To: <1374747739.29835.45.camel@x61.thuisdomein>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="cUJWpdp6IKEUDvcG3skWF4tuOl7HGRkUp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cUJWpdp6IKEUDvcG3skWF4tuOl7HGRkUp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 25/07/13 13:22, Paul Bolle wrote:
> On Thu, 2013-07-25 at 12:11 +0200, Geert Uytterhoeven wrote:
>> Please send a v3, which has the version info under the above "---",
>> instead of making it a part of the patch description to be committed.
>=20
> Grepping through my mail tells me this is the fourth time a patch has
> been submitted to fix this trivial issue. Perhaps (one of) the
> maintainers can indicate which patch, if any, the maintainers have take=
n
> or will be taking.

I took the the oldest patch for this in my mailbox, from Luis.

 Tomi



--cUJWpdp6IKEUDvcG3skWF4tuOl7HGRkUp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR8iXhAAoJEPo9qoy8lh71rw8QAJ45cIM8PEW350rx/OT1+ZR4
J4RhHIyW1lF3ZMMlHB3rbCch5zpxRsX+VE7qiRpn0j9T+ygcloM2huYmgn5bTucB
5Y+r0de/V0f6mPR6XWgt+J5RuxzbjZxjQoUomuycYe8/ciUlAq845NP1IUTUP+JY
YZL99viMOEzLY0s4lVWqpnFpAs+WYBvFA4P0bETkSQgXhyzosOw2JzbvxmVMNvKq
CVfKIvhzsTmniJThIqeN9VBIb07W/cLXFd9uo4/qhQBo54rn2ds6y51pIk/nL6t9
d+0KPSR42Qmj9vOWbcPzWyMaJ8cvp56/lBNu0sNc9f9miBCr0nwMNa+yYKLPOxjq
nDnmascjg2PUYrCu7yWDAS85UWF+xTfq5gPId55br1YRxL7NWeeERilZvdjBg4sy
HJ55oPlDmXVUiRgnU25L2r4xtc95GadIwQunY7ChCfU83QrwGcWtgzFx8qJnHwpG
Yp+USq/yXZPvzkdLPpG2RZmIBeHEvpZe5EAu/E5OzyfrR6VfSIMd56lIt8HUdE6n
tKbdBi4ctzN6h5dJ9QMzVWWonijmdH4/sVaxONcjvaY8hmoRAyPj7hqr8TnVEIKj
B25ExsYGFsJOq1UBFv/2H6V3ubKbP9NLQpe3stFTgrdS4tr0EawStxDJQtIeVLyQ
fBoyDYrTWa273yG0+kJw
=J39+
-----END PGP SIGNATURE-----

--cUJWpdp6IKEUDvcG3skWF4tuOl7HGRkUp--
