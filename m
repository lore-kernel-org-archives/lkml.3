Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbaHBSfH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 14:35:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48139 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754675AbaHBSfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 14:35:05 -0400
Date: Sat, 2 Aug 2014 17:17:08 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog
 driver
Message-ID: <20140802151708.GM3952@lukather>
References: <1399430664-29091-2-git-send-email-maxime.ripard@free-electrons.com>
 <20140507213318.GA2105@roeck-us.net>
 <20140515091123.GQ29258@lukather>
 <20140519150422.GA27329@lukather>
 <20140522203444.GE27329@lukather>
 <20140522211207.GA28704@roeck-us.net>
 <20140623103142.GB19730@lukather>
 <20140623211323.GA28120@spo001.leaseweb.com>
 <20140624144954.GP19730@lukather>
 <20140802080208.GA22804@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ngshnjhd05HsCES+"
Content-Disposition: inline
In-Reply-To: <20140802080208.GA22804@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ngshnjhd05HsCES+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 02, 2014 at 10:02:08AM +0200, Wim Van Sebroeck wrote:
> Maxime, All,
>=20
> > > 1) For me the discussion was not ended and needs further
> > > thinking. (And I just read some good ideas about it).
> >=20
> > It would have been great for you to mention it then.
> >=20
> > > 2) You never mentioned you needed this in for 3.16 and that things
> > > would break because of it.
> >=20
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/257690.h=
tml
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/259109.h=
tml
> >=20
> > I thought it was pretty clear.
> >=20
>=20
> I will put it in now as step in between before going over to the new rest=
art system.
> Anyone objections?

Yeah, go ahead, I'll send a patch to remove the reset code from
mach-sunxi in a later -rc.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ngshnjhd05HsCES+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT3QD0AAoJEBx+YmzsjxAgtUIP/j7iCO2gnzMwu4nsHACpRjxv
0crg+F7QH79V+RcDnnGIbTfI7fa/jCYMO/PS50viTpynE6Z8vkCX9xLBNYlyZxOP
r4ZnYZ3aXzjqX+8a52GEQF+SkemEkCbIC24FeLmviaNB0XD/SoOfBIcfyd/c9819
+W85kQ3cVxFA9+cGbfmCSr880BM2K0wlXZmuCQL8nXO+WflroE2QuH07R6b5Oq5n
Un8n14PrKky0ZFyEoedAshzJLtArzhZo1uyj2miUI9diSnEL6bHFujpr6v8JUGY5
5T5Uk1CxL6Dtxat/U9kZnCAPLg+4ae5bpPNvTo612jlox34wfUm8QLpBGLXg2WV5
8LdARdTpSupSJc1ap805nvl5y9bXnxMk63aW34I4vPBDOiZ08qUsTSegjfBgUrTo
w27umtaQEvqKvPw+D7cfn5OMA9wyJ4WtoFY5lgLPkUnCAPuCWAMoli3XP/daOD5+
6P1jQ0Nmuu5+vBDZTySLkII0F+euvTXGPW4a1+4QBXsvVTli3Z/S6P3HQOt096FZ
C7SOa3kQ1YhanwtS+JxGIpTC1G/exi69Xr+iETENmRrFbLAM6uiY7ptTR3F1C1iL
/TCrnhIvomyWcvjslIMA4e3E7/xevaRh6qPOm317g8UqJdDQux33uMLgI1xKBkIE
STzoRb0gYVG4dBWNjpgr
=OMrJ
-----END PGP SIGNATURE-----

--ngshnjhd05HsCES+--
