Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbaIZVHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 17:07:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:41231 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142AbaIZVHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 17:07:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,606,1406617200"; 
   d="asc'?scan'208";a="609314291"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: "josh@joshtriplett.org" <josh@joshtriplett.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Thread-Topic: [PATCH 0/7] Silence even more W=2 warnings
Thread-Index: AQHP1B6ZqT8VjyQkzkipcFe03W/rTpwNwlkAgAAZ2ACAABpfgIAABS8AgAAGSQCAAAZEgIAAA7mAgAADVoCAAAa4AIAADXwAgAPS5oCAAlk2AIAABc2AgAATX4A=
Date: Fri, 26 Sep 2014 21:07:25 +0000
Message-ID: <04133DCF-C237-45D2-8AEB-199A42EBCCDE@intel.com>
References: <20140922184049.GB4709@pd.tnic>
 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
 <20140922192152.GD4709@pd.tnic>
 <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
 <20140922195737.GE4709@pd.tnic>
 <1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
 <20140922203336.GF4709@pd.tnic>
 <1411420912.2513.32.camel@jtkirshe-mobl.jf.intel.com>
 <CAMuHMdU7VO01_qRGc0TV2K+nJJCu4sm0zbH773_zBWdaxSR1aQ@mail.gmail.com>
 <4C887554-FB5F-4634-ABE6-20F41583ABA2@intel.com>
 <20140926195803.GB19952@cloud>
In-Reply-To: <20140926195803.GB19952@cloud>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.66]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_4F337770-DF1B-4B20-888D-04A9682FB207";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_4F337770-DF1B-4B20-888D-04A9682FB207
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 26, 2014, at 12:58 PM, <josh@joshtriplett.org> =
<josh@joshtriplett.org> wrote:

> On Fri, Sep 26, 2014 at 07:37:19PM +0000, Rustad, Mark D wrote:
>> Most of the others come from null-entry table initializations, i.e. {
>> 0 }, which give missing field initializer warnings.
>=20
> I'd suggest that such initializers should just be {}, not { 0 }, and =
we
> should teach compilers to specifically *not* complain about empty
> initializers even when otherwise complaining about missing fields.
> Initializing a structure to 0 is completely sensible.

I agree completely! But of course that isn't how it is now. I guess I =
have spent too many years stuck on a single version of gcc that I tend =
not to think of changing the compiler readily enough. At least now I can =
upgrade the compiler freely.

Made me go check to be sure. Indeed even { } still throws the =
missing-initializers warning with gcc 4.8.3.

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_4F337770-DF1B-4B20-888D-04A9682FB207
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUJdWMAAoJEDwO/+eO4+5utiMQAL6vhDQzEk2y5w1sPw5P4JZJ
3TeYWasxVUZ/90gWdt9bI/oGtWuCmtNn0ZwCvhMW17C4tbhxge22b+yMFpBomvqX
GE/U8ZzgmMY2I/rraoVWMkWKNc/XLOw5KJ2r1OjzY6x6XszhmnKRkHq5d6igogX8
wD1BkGKcidPTjRvqPUeoj4ZkjPdgmP2uy0/cCB6eXYukorYQ1Nql/3G8QnC4vIeW
09GeHOGPbhaunVohw7+vVGvJZUgPpqaf3B75tSeXxpvKoV2yNYcz0mwDhxzENCH7
lxh7DQyrsGgwTAbyxYPwbS6RZ0C8HGlQzGBEhf+K9hoW4tVZLv36LNCGqXqT4Sd/
xkH8+DXMYZgAyMIHD62JrgalLoAZpwYeJlTxkAnDxjeQhqImAAggjomjcQmEgrTr
WlVfLRGe8VAUDfydmHWX6qaMXpNSLb8zQZWXe/HIEXFvi51hd9jPmKZ9eLv2Ky0I
iFmPl+bmGGobgeA8xtVXcu62LVkPw4tChkXcQwZAbU3dPU0Qf+QjtfPBiOCFv53L
j+Hf0HAAb2OWmwgBJEO5BXaBGUuR3uE3UCouZ+fzOzpptl+UE1jn5wWzWbl7PTk5
OOt4U/VOXJY4xEeceJ3kbHWMjzEwRsQqoLOGFLH/4N6ZQ+tmEu5RyxMg2gIMi5n0
iALiip1eyMYhGapLqdnA
=VzCJ
-----END PGP SIGNATURE-----

--Apple-Mail=_4F337770-DF1B-4B20-888D-04A9682FB207--
