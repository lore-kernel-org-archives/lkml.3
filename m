Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaBLLJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:09:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45491 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaBLLJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:09:48 -0500
Message-ID: <52FB5669.7090506@canonical.com>
Date: Wed, 12 Feb 2014 12:09:29 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue?
References: <52FA6D4B.7020709@canonical.com> <20140211194553.GZ9987@twins.programming.kicks-ass.net> <52FB2EC8.4080602@canonical.com> <20140212103713.GE3545@laptop.programming.kicks-ass.net> <20140212104017.GA5121@pd.tnic>
In-Reply-To: <20140212104017.GA5121@pd.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Nd88WwcH8QdC3vsQgfCHI1Nc4vRtrunmO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Nd88WwcH8QdC3vsQgfCHI1Nc4vRtrunmO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12.02.2014 11:40, Borislav Petkov wrote:
> On Wed, Feb 12, 2014 at 11:37:13AM +0100, Peter Zijlstra wrote:
>>> Another reporter also saw this on an AMD and said it could not be rep=
roduced on
>>> the same hardware and the same software versions when using 64bit ins=
tead of 32.
>>>
>>> In my case on a 32bit installation I will see this on every invocatio=
n of
>>
>> Curious.. so its both AMD and Intel.
>>
>> That makes funny hardware less likely... but how can the vmexit loose =
an
>> interrupt like this.
>=20
> Also what I'm wondering about and what's not clear from Stefan's reply
> is whether this is purely a 32-bit issue, i.e. a 32-bit host running a
> 64-bit qemu running a 32-bit iso or what is it?
>=20
> Or do we have reports for both 32-bit and 64-bit hosts?

Only for 32bit hosts. I have not tested a 64bit kernel plus 32bit userspa=
ce,
though. But 64bit kernel and 64bit user-space seemed ok. And one detail I=
 should
add is that while the reproduction is possible in all attempts, the timin=
g can
vary. In some of the cases this was even before running a Linux kernel in=
 the guest.

Something else here I run a kernel with CONFIG_PREEMPT not set and NR_CPU=
S
limited to 8 (for the 32bit kernel). So the default apic driver is used. =
Since
default_send_IPI_mask_logical is only used from there, I assume the trace=
 you
got does the same. Maybe something there is wrong which would explain why=
 we
only see it on 32bit hosts.

>=20
> Thanks.
>=20



--Nd88WwcH8QdC3vsQgfCHI1Nc4vRtrunmO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJS+1ZpAAoJEOhnXe7L7s6jXRkP/20KwL982Gr7iICGkEQOMt3L
wfxjpeQmn7hUTE3HAtcESbFxNeyrSlv5D3vY0gQniItRYeP5z7xKLCkE68SYMSv3
z6QUha4PaOApOTzjr+j/YcmxdqVex/qVQNOYhsn/F1WCFLY+XfBWigJWOs7+LZ3I
x3tfim2G+uYoAwLNl1rdTnW1DuJkAmqq22M5GnPvEA3xHC96KuKyAilcigP+/LPZ
kA+wVjpKkFeFic2fX2NWotZhqwU4CoP6+Ae4HyTj7rnibPl5g3BQsdYzwsADdgIF
MMdCOh/nSDmJRaor6bbvVbxbBHw0Qx+ZGCxhPRtEgv440pbRuEIN0oYJrMe/N32Z
9SMZTzGpQcSUd6bGmYA/rf7VR2pgdjqitTLUTKhbHNsAoxnTWc8SIeiDlHjzLqvJ
KoogE4vV79rnu5gwzIEqXIYmiIpYFMX+1zFZkmjRD3ZCO1gKfLrSSLW89LjrULvD
r7ewfC4n5wcZS7P3vOdcJOpxxeznBiUwxPtkmYSCNIZqKTyF9RTDwDWgCI1RDzwB
7S+MEu8Y7Gjtv5HXAijxzO6lKLGMqk4Z0dzrnzdu8ZvZq8MsLPaMXH1f5nPI+XZu
zBls8GNaC0bQ0xHjXzVxtdLxxIZyH4RKho1oXXEeP+QIxh0Q/sSa2TIKZP8/1qDj
JK14tT+EdCDQutJT5oud
=ZnxX
-----END PGP SIGNATURE-----

--Nd88WwcH8QdC3vsQgfCHI1Nc4vRtrunmO--
