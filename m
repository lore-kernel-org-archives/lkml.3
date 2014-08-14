Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaHNHBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 03:01:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60410 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaHNHBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 03:01:42 -0400
Date: Thu, 14 Aug 2014 09:01:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/5] perf, x86: Document all Haswell models
Message-ID: <20140814070122.GC16043@twins.programming.kicks-ass.net>
References: <1407979069-7121-1-git-send-email-andi@firstfloor.org>
 <1407979069-7121-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Izn7cH1Com+I3R9J"
Content-Disposition: inline
In-Reply-To: <1407979069-7121-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Izn7cH1Com+I3R9J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 06:17:46PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>=20
> Add names for each Haswell model as requested by Peter.
>=20
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu=
/perf_event_intel.c
> index ef6c8b7..03befdd 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -2540,9 +2540,9 @@ __init int intel_pmu_init(void)
> =20
> =20
>  	case 60: /* Haswell Client */
> +	case 70: /* Crystall Well */
> +	case 63: /* Haswell Server */
> +	case 69: /* Haswell ULT */

So I googled Crystalwell, and I'm not sure I understand; is that
Haswell-H + GT3e or it that Haswell + GT3e, the distinction being that
there are also Desktop parts with Iris Pro 5200, such like the
Haswell-R.

Haswell Server, is that the single socket one, or is it like IVB both
the EP and EX parts?

And is 69 only the ULT or also the ULX parts?

Would something like this be accurate:?

	case 60: /* 22nm Haswell                        */
	case 70: /* 22nm Haswell + GT3e (Iris Pro 5200) */
	case 69: /* 22nm Haswell ULT                    */
	case 63: /* 22nm Haswell-EP/EX                  */



--Izn7cH1Com+I3R9J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7F68AAoJEHZH4aRLwOS6jgoP/ia/nerZAuix/n6nYM45pSKM
Pv/tO4P5Y/aEj6vYLuZjlTNi/7pysHJZLQP+T1rl9kv6K2bMxtY+Gg1BB8U0o4oR
i+8ZCnxdpayxOP0hlrGOiDzZH2PCMQKFCmOlzItZFBiErxGhKhnjbESB41sm/dCH
/3taguMfIHWClNPZtzuElx3t2V2/kEML881PiVRS2dQkb4D1IIHfuvtBf64urY35
tIZmjGqK7Oh+PwW7+LB8UScmRkq0tHRP+rQeif2rf6dmcL3RlCbN1GyQD6KB2Cab
opDQ49Y6yxZ4ng5ZDM7inm4VLJD5WbemROmM7OGCB/3PMK4zmTWHY1ehxNF0cnZt
KvUCcdX07alENu95gPI48JohvIMhFncWUkqfm8fW2nmlvmhp3DRMtvx/Md84p7Ie
NL5MBfSZ/Wz5HyO5HLzp8wrFslKIEXxAw9G0ABg0hhIcqwOKBjijumWX8xzsGiWL
jOZtOHGM1keB0P8BFx1KGLXbPZX7BMksHavpfz34HSlHr35wWzOMHB0JqkYUCXFb
MCKc7gp5mOC8PojvBI6477wLu1QrWurD2OtGJN+zgcmLmB5Xf+mzYSs2adaRbCr9
WVKSvSO9J9eNyoIzPUUV9uLvk06ZiJayOUkaZKJEIboxMb7BBVdxnL1DbTEmd4h5
VQaj/alI7UdVIyPyyl8T
=3jEI
-----END PGP SIGNATURE-----

--Izn7cH1Com+I3R9J--
