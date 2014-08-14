Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaHNDWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 23:22:25 -0400
Received: from ozlabs.org ([103.22.144.67]:55405 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbaHNDWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 23:22:24 -0400
Date: Thu, 14 Aug 2014 13:22:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benoit Taine <benoit.taine@lip6.fr>
Subject: Re: linux-next: manual merge of the tip tree with the pci-current
 tree
Message-ID: <20140814132216.0e797236@canb.auug.org.au>
In-Reply-To: <20140814131031.4ecce959@canb.auug.org.au>
References: <20140814131031.4ecce959@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/JnkUsX86y2N8rDnLNrSsVbf"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/JnkUsX86y2N8rDnLNrSsVbf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 14 Aug 2014 13:10:31 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> I fixed it up (I used the latter version of this file and applied the
> following merge fix patch) and can carry the fix as necessary (no
> action is required).

Apart from making sure Linus is informed when these things hit his tree ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/JnkUsX86y2N8rDnLNrSsVbf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT7CtuAAoJEMDTa8Ir7ZwV/dEP+wUmsv4yimd10IvJSY/hSHn2
Vdyf8qV6TeH9Xl1j47JhiHJxhovKo0loVQMAMUwulCNP4pEjsfGWI2Kg6fDd6AAI
i7idJxqn9bRzkrlN+0sSwYJhU7EOdZ6YAJhFnaduH2sPzi4BqYUdO9aUdHGL9niA
PAIZOGfCrtpucd2WwBmM6i0JKNub27fSuFI7pT4x/R46VH4ZDnalA4sZzNqxCalp
h1x7evwQIjAzBQ18gq9hUg0LPVEx3kdyqY2SiRGKEwXeoaPXYa/Asl3qOpovAwbb
N9FqP5QmBFvFDNKdNHHBm8RTZCj0z4ToF3SZI17XHobcjfu5WrsMlFkeLJ+inivQ
OMjads0FuPDHoglS+X0VxzSo633JurLazxY8gW/Lh9CBFbSEzJ0YM+ETBlfq9lE+
UjyzN5kyFR1P9xv9FM98ufKKFn7c6vRdFKoBVNcBXjn/AmQkZMKzynRn8Jja0d08
fnhQ8zJi40lRghhbBMVistZfFyhFOael6gWGHKIx4phv6V2LOc4/UYWX9Hmx3Ct0
UII9WzhIev0yuxR+QCO/goP8pLKRruK3y0KtkT2aTQ7jytA09Ou8/fnL47fiO2GN
FitJ1DLXCI2MR3QIIubc2dSQfPB0yv3pEuLG7XVbMmjvmFP4byMtuHl371JspTub
cza/+H7ANFg9WJvoDgw5
=sn4Y
-----END PGP SIGNATURE-----

--Sig_/JnkUsX86y2N8rDnLNrSsVbf--
