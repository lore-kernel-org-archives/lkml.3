Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaLDKQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:16:31 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:55520 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753524AbaLDKQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:16:26 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Thu, 04 Dec 2014 10:16:24 +0000
Date: Thu, 4 Dec 2014 10:16:22 +0000
From: Paul Burton <paul.burton@imgtec.com>
To: David Daney <ddaney@caviumnetworks.com>,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
CC: David Daney <ddaney.cavm@gmail.com>, <linux-mips@linux-mips.org>,
        <ralf@linux-mips.org>, <Zubair.Kakakhel@imgtec.com>,
        <geert+renesas@glider.be>, <peterz@infradead.org>,
        <paul.gortmaker@windriver.com>, <macro@linux-mips.org>,
        <chenhc@lemote.com>, <cl@linux.com>, <mingo@kernel.org>,
        <richard@nod.at>, <zajec5@gmail.com>, <james.hogan@imgtec.com>,
        <keescook@chromium.org>, <tj@kernel.org>, <alex@alex-smith.me.uk>,
        <pbonzini@redhat.com>, <blogic@openwrt.org>, <qais.yousef@imgtec.com>,
        <linux-kernel@vger.kernel.org>, <markos.chandras@imgtec.com>,
        <dengcheng.zhu@imgtec.com>, <manuel.lauss@gmail.com>,
        <lars.persson@axis.com>, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 2/3] MIPS: Add full ISA emulator.
Message-ID: <20141204101229.GC5482@NP-P-BURTON>
References: <1417650258-2811-1-git-send-email-ddaney.cavm@gmail.com>
 <1417650258-2811-3-git-send-email-ddaney.cavm@gmail.com>
 <547FA2E5.1040105@imgtec.com>
 <547FA8D2.2030703@caviumnetworks.com>
 <547FB032.2000000@imgtec.com>
 <547FB8FB.7040803@caviumnetworks.com>
 <547FBF63.70802@imgtec.com>
 <547FC530.1060109@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
Content-Disposition: inline
In-Reply-To: <547FC530.1060109@caviumnetworks.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.168.159.131]
X-ESG-ENCRYPT-TAG: f2c42831
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Nice work David, I like this approach. It's so much simpler than hacking
atop the current dsemul code. I also imagine this could be reused for
emulation of instructions removed in r6, when running pre-r6 userland
binaries on r6 systems.

On Wed, Dec 03, 2014 at 06:21:36PM -0800, David Daney wrote:
> On 12/03/2014 05:56 PM, Leonid Yegoshin wrote:
> >I see only two technical issues here which differs:
> >
> >1.  You believe your GCC experts, I trust HW Architecture manual and
> >don't trust toolchain people too much =3D=3D> we see a different value in
> >fact that your approach has a subset of emulated ISAs (and it can't, of
> >course, emulate anything because some custom opcodes are reused).
>=20
> Yes, I agree that the emulation approach cannot handle some of the cases =
you
> mention (most would have to be the result of hand coded assembly
> specifically trying to break it).

I'm not sure I'd agree even with that - ASEs & vendor-specific
instructions could easily be added if necessary.

On Thu, Dec 04, 2014 at 05:56:51PM -0800, Leonid Yehoshin wrote:
> >2.  My approach is ready to use and is used right now, you still have a
> >framework which passed an initial boot.

Subjective.

Thanks,
    Paul

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUgDR2AAoJENzvn0paErs5WycP/RcMXEbYDfFVuqfMx/WJVgd5
xbpn5TcXqBWjRckUMqIYInzwVOskzrUVZ9OKT7AQ50mP9DtGhxX6Cy+zPGkSY9Ud
8p8HAq7KQJ2OFhFfk7vpeuquVj3KkMvuz7F8iFw090SfTEBmttiohieMY3nZ7l9w
QfLlq+U2uUZMBD0OiUnhxwi1d1EW2Lv5HefdMy+gbH2/C5Eg6dhWwqSSkCCgMed8
9ewfwVZAOKrj6lHFx4nqQ3qO+YnsAoSglb5QC/48SCmqWLDpivGr2VS21DXds2Gk
Pl6xqJgVaRK6nHQjzUyiR+CTSkO8EyhoU5bLCiQ5GzhNlmuvlV871QjcBEbRAJR/
ZF1darPvA7B4rtPgd020E6SQYlIZ1S6TINzQkJNzJ/EX4mG/dSErNQmORnmaCQou
sZaOozUh0w8O0+GfaeqqCChIYKM3PzYKvgDkd5/WlZXlG7QkoU+kdKwhmOHC/Y/y
+NS1RFH8eV4Y7Q9O2iZfq998YDTJTMR549oybDcff2wS3eSk5Az0GO8pzhamRmB/
ZymTwZLUHqOyX+CMgGwY/Np0L7nQRJcIE6dV9DomhgR/QHI4VmoH7Oppn7259rNj
jpzCVpvZyAhaky5gOhqdGWE2J91IENdiDtKYGK1WEkYzVtaPBjh3RLAb9xqvt4Io
wsQiy/uINrPi4BJ6Pga3
=Ed87
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--
