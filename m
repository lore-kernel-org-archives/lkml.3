Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaBNP2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 10:28:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60158 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbaBNP2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 10:28:48 -0500
Message-ID: <52FE3610.8040300@canonical.com>
Date: Fri, 14 Feb 2014 16:28:16 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Peter Zijlstra <peterz@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue? (maybe bisect)
References: <20140212103713.GE3545@laptop.programming.kicks-ass.net> <20140212104017.GA5121@pd.tnic> <52FB5669.7090506@canonical.com> <20140212115412.GW27965@twins.programming.kicks-ass.net> <52FCFA23.4060701@canonical.com> <20140213173852.GH6835@laptop.programming.kicks-ass.net> <52FD090C.7010408@canonical.com> <20140213182605.GC14089@laptop.programming.kicks-ass.net> <20140214133428.GB26356@pd.tnic> <52FE2709.3050505@canonical.com> <20140214152132.GD26356@pd.tnic>
In-Reply-To: <20140214152132.GD26356@pd.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="9VPNUU0RUvi5oVBvxNKFrdvwhJpm6DNnS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9VPNUU0RUvi5oVBvxNKFrdvwhJpm6DNnS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 14.02.2014 16:21, Borislav Petkov wrote:
> Oh, and just in case this is relatively easy to reproduce and in case w=
e
> don't have any other idea, bisection might be another option. I'm not
> saying you should do it right away - I'm just putting it on the table..=
=2E
>=20
> :-)
>=20
> :-)
>=20

Oh yeah, bisection is nearly as entertaining as doing my tax records. Hm,=
 on the
other hand those will have to be done at some point too... :-P


--9VPNUU0RUvi5oVBvxNKFrdvwhJpm6DNnS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJS/jYQAAoJEOhnXe7L7s6jL50QAJT4eK3bAjq+kBLc+ESfuqDA
spDrQpP3P8lY7rsZJWI9BtOxglK0+E6wKy3C9MZFFxUd05GoVJ6vdcmva1jVBQ6A
HsYH+BTD17KWxwk4E1+m9oyxM+ZQ+CjLZBSVyS1LUb4ACJ2AyVxiscIIYteztWV2
CfMsrd+RA7wDU6Y573TkELAnBFOcoqZvIRfBhbEpgWpZqTe0Fs1rs6ihB5HzUdAX
dposKrFxqLdrDEK+TDK/hy4E4c0fgfcefOPBj4FfTVUu+tITEKFiRuF7ugh3Zjuy
hFm2Nlh6lKRvC0c1tIpZPSv2s+LBvGcVA8PffLjTcwu6IpvpItOCOKcLE2LXkkas
g2J9plnI55VxHkANaqsLoOr6aYfc6ryPLcQBE1+GtpHZM+6XDPhPpFym6QOKUltQ
3rzfTbNmzEkifCFMEUujiBrdxcBtQpseJYnR+ecf/Sf0+pJSqEMpkpZxYioMcRKF
jGkdCmpq42SBT/SQmRIVo52Ca+0k4XiRPc/kCyNKflxs9uBexl0qujshCpo1F7c5
sjDyrGsr6ttmE6s+peywTXus4+AIkHagh6Ln9mRf3R6Rwz6TG6BPrazaE/iZHl4q
3N2MVjsyXH3cgyT/qrbZPflSskBLOhe+P7g3KkL/JgLT/u4ppk9ivwcSJrkltW/Y
aJlK2hU0NBm9PD4wOrTX
=vBjs
-----END PGP SIGNATURE-----

--9VPNUU0RUvi5oVBvxNKFrdvwhJpm6DNnS--
