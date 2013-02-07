Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422660Ab3BGVkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:40:46 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42665 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759333Ab3BGVko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:40:44 -0500
Date: Fri, 8 Feb 2013 08:40:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
Message-Id: <20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au>
In-Reply-To: <20130206214646.GA28135@gmail.com>
References: <1356564746.7010.56.camel@shinybook.infradead.org>
	<50DB9FA5.6070704@infradead.org>
	<alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com>
	<20130204184436.GA13256@gmail.com>
	<alpine.DEB.2.02.1302041053330.6063@chino.kir.corp.google.com>
	<20130204191408.GA32081@kroah.com>
	<20130204191334.GB14837@gmail.com>
	<CAOJsxLFy7K0cY-8SH4dXs=agYqCN8wW0eC2tQxFxfV8cf7uWqg@mail.gmail.com>
	<alpine.DEB.2.02.1302061209450.18172@chino.kir.corp.google.com>
	<20130207080236.ae38366537cf3f13b9668606@canb.auug.org.au>
	<20130206214646.GA28135@gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Feb_2013_08_40_29_+1100_7z/ikHc8ISwBOGGA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Feb_2013_08_40_29_+1100_7z/ikHc8ISwBOGGA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Wed, 6 Feb 2013 22:46:46 +0100 Ingo Molnar <mingo@kernel.org> wrote:
>
> Pekka still intends to send it in the next merge window AFAIK,=20

That has been true since v3.2 :-(

> and I use it for testing rather frequently so I'm not going to=20
> remove it from my tree for the time being.

I didn't ask you to remove it from your tree, I just would like it
removed from that branch that is included in linux-next
(tip/auto-latest).  I know others who also use it for testing.

> Note that I never actually had any maintenance problems due to=20
> it: it's orthogonal, and as long as you don't use it explicitly=20
> (such as its 'make kvmconfig' feature - which is rather handy)=20
> it never actually broke anything.

I don't doubt any of that, it is just that Linus has explicitly said that
he will not pull it into his tree.  Thus, it should not be in linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__8_Feb_2013_08_40_29_+1100_7z/ikHc8ISwBOGGA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRFB9NAAoJEECxmPOUX5FEE5wP/0Ock4tokSlQ+1wd1o5jphDQ
OYbQeWgblT63F51MumjFIdTXQ5HnAA55JhhjpMAbjonaiQokqrZLkTrwDeiA1J7U
pwI+IoumutYCbq9ik84iq5nHTUCim8KN2gu1lpRWTBRvVNR6j31uZvJRrvVg96Is
Gj8CzYXfVQDoAOmVvbDHpudkqQfT0zP9ewPueKoe1VqrRgarlTh+fhAMMw+zFgqh
NKlTHkzskmvfQggyd/D48FvqJpRP2FzbFoZ6QadCWxOZacLl2gLJTb1+XqELU2iH
FqghPKOmVgUW5fymuTU3USYpXk8dhynh+ewVu6Tt3BXDXMhEFvKgwzyI8JinkmZT
jbcoeduWh2VZ0iD9K8FjbzMzUZ0ZGm90DmvyDHAvlaw2bL5cCCPA+Uo8vRr6M6IY
cMHudrv6sfE6C3OWl3g9V6VFa+Wyjj+BrvPf+fdrLb+f3g6jWg1HJf3EMf5NGwH8
yXj1Os3OeV0ggGF9WFdYAgaQbHMbxUKOqkEJMj9GlGQAUTt3tqgYO3m3GPmXDvVa
DkkSX2YfORXtFESKfFDG95wDR7kVaH3Xue9K/j6yOr0UmsS5vuoQlsLymb2V38AO
Jt8bqLvOoUtSmiHxOBaS/f2FmK1w07GxpATvgwe4kVk/Pko1MFTv8nkaxg4FVpzN
jNz7iHvJT69/Oxbrep3C
=H5OD
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Feb_2013_08_40_29_+1100_7z/ikHc8ISwBOGGA--
