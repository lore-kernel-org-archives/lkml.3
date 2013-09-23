Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab3IWUu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:50:57 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:33230 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab3IWUuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:50:52 -0400
Date: Mon, 23 Sep 2013 22:49:28 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 4/9] of/irq: Introduce of_irq_get()
Message-ID: <20130923204928.GC5216@ulmo>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
 <1379320326-13241-5-git-send-email-treding@nvidia.com>
 <5237771F.1060908@gmail.com>
 <20130917132834.GC6757@ulmo>
 <CACRpkdYQxD_GAeym7D=npBfrmn88MRYOFh9i2V0xeByiEiWKGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3RTKUHj+75w1tg5"
Content-Disposition: inline
In-Reply-To: <CACRpkdYQxD_GAeym7D=npBfrmn88MRYOFh9i2V0xeByiEiWKGQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O3RTKUHj+75w1tg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2013 at 09:18:52PM +0200, Linus Walleij wrote:
> On Tue, Sep 17, 2013 at 3:28 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Mon, Sep 16, 2013 at 04:24:47PM -0500, Rob Herring wrote:
>=20
> >> *_get typically also implies some reference counting which I don't
> >> believe this does. I don't think having 2 functions with completely
> >> different names doing the same thing with only a different calling
> >> convention is good either. So I would keep the old name and the names
> >> aligned.
> >
> > Okay, I'll make the new function __irq_of_parse_and_map().
>=20
> I don't know why i detest __prefixing so much but I think it's
> really nasty.
>=20
> Usually this is reserved for compiler- and linker related things,
> like __packed;  or __init.
>=20
> I would prefer irq_of_parse_and_map_strict() or something
> like that.

Following from the discussion on one of the other patches, perhaps this
could also be converted to return int (instead of unsigned int), convert
all callers to cope with negative or 0 (instead of only 0) as errors and
then modify it to actually start returning negative error codes once all
users have been updated. Eventually I think we should get rid of using 0
as an error indicator altogether, but as I already mentioned it might be
difficult to do because new users can always come along and use the then
deprecated 0 return on error.

I'm somewhat worried about the amount of work that this is turning into.

Thierry

--O3RTKUHj+75w1tg5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQKlYAAoJEN0jrNd/PrOhfigP/A9vkmaGmnFbDaEUHcQeQMgD
bYPSjvnwttsW3G077yqa1V7L80idYd0rzB/1TuG2mD3pREv28DKQFzHmQpY7wdSY
EiHorEkSLxZI1o0hkRnJLfFLDP4XUFT3qY7OyDU6o/c5TkPep1+CinDpSWSF0kpD
+pqMCbvJHDGtbxvQpxhB3RXWsH1u1ljHARSjg9mog0d44D0LAzcOp9v0ssGsHAMZ
q9or1XBRe5FplDA/kW5X2Gax1j44DVIYshENgNbW1g/r3KA1974bUBokSYT2qXOx
wFAFiAeQ4pJbt3CnKFUuYwmrBmdRyZ67KSD5XncaXloQdpOsT+g7E9JY4cCB19h4
CWHIuQj7FIrdgccXeUURF35wsSd62gZ0dYVJ+5DvjJMcuDxGmePKnjaEuVWi97U1
HdfBOwEoK79vwtQ5wJDnKmRlrdF7HP/8D6348zvkwlf8K2EQl1tiLvqGfxCUHn+Z
cIE3NAmWIGIa9WPZSRPSIKghJNOO0xKd85SnjdWAkJhrC39kkzU/m6/Q7WZ1uVb8
j1Og8wA7Drv0Z2P2LhG15ArIfVGuwkxXD2QdV13zJ74oEomeBfKo5rAeCWqJZELr
JnkynFIRH9WGn4Zw3oDsLQcaBbaB76tnhxdQ4MAjQ54tHSAU/vCxbt6C0Aoule/L
+Pw6sRgcgozufQxOoy4X
=GVED
-----END PGP SIGNATURE-----

--O3RTKUHj+75w1tg5--
