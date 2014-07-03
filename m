Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaGCA0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 20:26:21 -0400
Received: from ozlabs.org ([103.22.144.67]:57723 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbaGCA0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 20:26:18 -0400
Date: Thu, 3 Jul 2014 10:26:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: kGraft to -next [was: 00/21 kGraft]
Message-ID: <20140703102610.3014bf88@canb.auug.org.au>
In-Reply-To: <53B3F556.7050002@suse.cz>
References: <1403694329-3064-1-git-send-email-jslaby@suse.cz>
	<53B3F556.7050002@suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/amV7uQR5piTwZ8DP._DY11B"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/amV7uQR5piTwZ8DP._DY11B
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

On Wed, 02 Jul 2014 14:04:38 +0200 Jiri Slaby <jslaby@suse.cz> wrote:
>
> may I ask you to add the kGraft tree to -next?
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/jirislaby/kgraft.git#kgraft

Given the ongoing discussion, I think this needs to wait ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/amV7uQR5piTwZ8DP._DY11B
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTtKMnAAoJEMDTa8Ir7ZwV1VMP/3mpnTWVBv+SDMFC3aiWY9Bd
o2JE+lSyi0f4OERnySfUHB9aXGlUZlFgjivsvCHbsj1BSH/nCYfqFzhzS21Ie8el
5ByuCmtabm1XhhOLu963O62NaVPBO0nzfeV3t8/hM8qdhcalJR7Q18zgNYWEs/+j
PpIZuWlHmu7njHXMgB24LxtYyaGrYKeSewCd1JlRkjJHh1I3yYvHYBS2HWAjE2pZ
LSKtj9JzTzif5ZIrxy8DSnFhbdWsklO9cgAA9knEJNQsoaWH189VJvXchvU5ZQfN
HiyL8Fv45sNgik1+BeDra7V1jKZmhznV2m33XhFk3VSybUW3WkQXKu8TqAKYrBnJ
XFx/0rhKeRJdrFR0yJ3aipJ6+XGtsfdm8wzWYwDxSfLS+wUrBIsiqsfbLus5mkIv
2bkiwqZQ6ro85ddkizzgPnv+FHrGV/nVO1FPMCF30PQu6RKcvlFOr52CKGn1nkjP
jcQDvoFQfMfIkcIE+EGuqoSN1qiO9XOv40+OqpwwLGVDo7mY4SK6MDAiAud2wyT0
E9FsxvjjKjatYQodDyiXtsXXaK6J8HCs+inEYrgswZkfBy2AHdmvIuMDtuK2skGd
c7NU3L0igOEoqVKGYcuTOv8U4obSSaGyfbXIgNtlqp7l/M2Sal3e3zGJhuE2lxjh
3slsVA90Yd0cIVSWhGHI
=K2kI
-----END PGP SIGNATURE-----

--Sig_/amV7uQR5piTwZ8DP._DY11B--
