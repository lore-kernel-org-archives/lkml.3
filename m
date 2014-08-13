Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaHMH6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 03:58:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:43040 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbaHMH6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 03:58:50 -0400
Date: Wed, 13 Aug 2014 09:58:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] perf, x86: Remove incorrect model number from
 Haswell perf
Message-ID: <20140813075834.GY9918@twins.programming.kicks-ass.net>
References: <1407894315-15928-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iyYSdTgI6uqGGfDx"
Content-Disposition: inline
In-Reply-To: <1407894315-15928-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iyYSdTgI6uqGGfDx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2014 at 06:45:13PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>=20
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu=
/perf_event_intel.c
> index 2502d0d..ef6c8b7 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -2541,7 +2541,6 @@ __init int intel_pmu_init(void)
> =20
>  	case 60: /* Haswell Client */
>  	case 70:
> -	case 71:
>  	case 63:
>  	case 69:
>  		x86_pmu.late_ack =3D true;

Can you properly describe the remaining model numbers? Surely there's a
significant difference between these chips otherwise why give them
difference model numbers.

Looking at the wikipedia page for Haswell I suspect its things like:
Haswell-{DT,MB,H,ULT}. If so can you but the right name with the right
number?

--iyYSdTgI6uqGGfDx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6xqlAAoJEHZH4aRLwOS6LfoP/RZiULvhH2XeKJYF2t9QL+Vj
XNHyA9pO/2mgNjSvPRoP2e5WXKlyuIgRnMGjABXABPBYyLwVS1MFAteIg7kA5pv/
zogtZJkxdKs8ZIeUBCXML9T+eTRoqpKFRMdUH1817DQtBP9gwRBXUOw/SpbnDtsb
Yh3DQdQhEqLCwA7si3swtLA/D65ULZ2ya6gP7FVTTaNb2XfdwGuLJODtnfo4492f
T3XdeJQw1BOR7tXZ3oK+vkLOXLPwSoAUliBhhzrX0eaj9pOxQvB1N4lR3r+jt8D5
JwB0fkTYH+6GBJ0WzGKaZFCGOUmHeW4NaMZS1aB1lu4Xl/5LGUjtoqWwPwLGZZ3b
J6IFYXOCdmzy4eMC6V3n0MXwvG5+bud9fX/N7u/4UPmnptLHbjWJJR+mt5wr6gP4
5y/7MfYLjLsxdmTu77xu2WMwI1LDkTYVM+il2h3W9rxAKX+PNCEW7km1upjWg0y0
ra9BRiPwz7oMyekFwUH2akSHQ/FSDtVftCObmVLZ9JJpOwGAIcIoix6oBFZZXEU5
NpJ6TXvVHcBqEFuMlfmMhXCe2sfQOcejjwWakSKMW9RIf77ATWhSYuUfoqDZJuZ1
X0iKqSEMlU/2M8TEIskRuLz9f0efr3+tIWEq+ICOSA36VFkZhR/dNgGRGnY7R++g
mO5IvL2DlmfPZLz6d48P
=FS8u
-----END PGP SIGNATURE-----

--iyYSdTgI6uqGGfDx--
