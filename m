Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaFRP7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:59:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:55516 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaFRP7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:59:23 -0400
Date: Wed, 18 Jun 2014 17:59:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kleen, Andi" <andi.kleen@intel.com>
Subject: Re: [PATCH 1/2] perf: ignore LBR and offcore_rsp.
Message-ID: <20140618155916.GZ6758@twins.programming.kicks-ass.net>
References: <37D7C6CF3E00A74B8858931C1DB2F0770148F513@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y4JO1JP6mbYWtFW3"
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F0770148F513@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y4JO1JP6mbYWtFW3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2014 at 03:52:55PM +0000, Liang, Kan wrote:
>     perf ignore LBR and offcore_rsp.
>=20
>     x86, perf: Protect LBR and offcore rsp against KVM lying
>=20
>     With -cpu host, KVM reports LBR and offcore support, if the host has =
support.
>     When the guest perf driver tries to access LBR or offcore_rsp MSR,
>     it #GPs all MSR accesses,since KVM doesn't handle LBR and offcore sup=
port.
>     So LBR and offcore rsp MSRs are needed to be protected by _safe().
>=20
>     For reproducing the issue, please build the kernel with CONFIG_KVM_IN=
TEL =3D y.
>     And CONFIG_PARAVIRT =3D n and CONFIG_KVM_GUEST =3D n.
>     Start the guest with -cpu host.
>     Run perf record with --branch-any or --branch-filter in guest to trig=
ger LBR #GP.
>     Run perf stat offcore events (E.g. LLC-loads/LLC-load-misses ...) in =
guest to trigger offcore_rsp #GP
>=20
>     Signed-off-by: Andi Kleen <ak@linux.intel.com>

This order indicates Andi is the author; but there's no corresponding
=46rom.

>     Signed-off-by: Kan Liang <kan.liang@intel.com>

And here I thought that Andi was of the opinion that if you set CPUID to
indicate a particular CPU you had better also handle all its MSRs.



--Y4JO1JP6mbYWtFW3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTobdPAAoJEHZH4aRLwOS6phAP/3AEV7zJrda70yAW9QU8F832
iKbhNbUncITXlwgYi9vONp3kIBB+NeBu443IhtYL6fRbww23Nr7Byavzpb8y8xSs
TLXf+//gLFJarBKo9vdIQUHpIPIaZyu2AU/3Cq9UNW7CjG73ZTX8kyx7zuumJioq
tUEJwjp0IbvOg3wiEJKJksL4xTTK3lP5n07ppk2eaiSU32yo7ShFiweZkMHHkY4h
F9n5qppPurUIfvjmg+HY0HrosRx+IPo7rVKwRGZbsEXmYo+3oLFAyp76H7tcK30S
bj+YaatBe2JJXgCveqGoKpzfv7SMSCVZNMOlV9ttwed6LXFNKG77cPOz1epdVkKI
B6N0vjD23YF8wDMkQQLpH2cFPK+cD/89vuSUL3GUAJv3sCaR6wWM1VFz/FmsT92B
XDWMN4fs5yEUx6Mdy0P7ShvMZI8Lm2eIM0levATnA/J2FnyA3HT5DIzo+VIppGyZ
pnaFebjCXt4UsyFAILlhphLRWzgdcRhIHrr1xKAIGqb9uZ3KIZ9lE9Y8dXmpTcCP
5sSOC/b0Wnk1TqiUq0mMvD8q98G84Z2yQEi3izHTqzD5rMaoiDRZCic8v3wlUKjL
muEBUkcIjgN6Z8+6OFOoC5i35ksgJxln6flM7OHldstZEX4RX0EdvafRsiZUx4bd
eeyWq4Za2uZa2VHOrjHO
=xWux
-----END PGP SIGNATURE-----

--Y4JO1JP6mbYWtFW3--
