Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbaCSLHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 07:07:40 -0400
Received: from [217.156.133.130] ([217.156.133.130]:65254 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759275AbaCSLHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 07:07:38 -0400
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Wed, 19 Mar 2014 11:07:15 +0000
Message-ID: <53297A61.4010605@imgtec.com>
Date: Wed, 19 Mar 2014 11:07:13 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: <peterz@infradead.org>, <mingo@kernel.org>, <linux-kernel@vger.kernel.org>,
        <dietmar.eggemann@arm.com>, <preeti@linux.vnet.ibm.com>,
        <tony.luck@intel.com>, <fenghua.yu@intel.com>,
        <schwidefsky@de.ibm.com>, <cmetcalf@tilera.com>,
        <benh@kernel.crashing.org>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        <linaro-kernel@lists.linaro.org>,
        linux-metag <linux-metag@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] sched: remove unused SCHED_INIT_NODE
References: <1395165409-18055-1-git-send-email-vincent.guittot@linaro.org> <1395165409-18055-2-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1395165409-18055-2-git-send-email-vincent.guittot@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="VfWJngtG8TltsDOvruVo8c8PrASAVCMJS"
X-Originating-IP: [192.168.154.65]
X-ESG-ENCRYPT-TAG: 542c405f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VfWJngtG8TltsDOvruVo8c8PrASAVCMJS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 18/03/14 17:56, Vincent Guittot wrote:
> not used since new numa scheduler init sequence
>=20
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

Applied to metag tree for v3.15,

Thanks for spotting it.

Cheers
James

> ---
>  arch/metag/include/asm/topology.h | 27 ---------------------------
>  1 file changed, 27 deletions(-)
>=20
> diff --git a/arch/metag/include/asm/topology.h b/arch/metag/include/asm=
/topology.h
> index 8e9c0b3..e95f874 100644
> --- a/arch/metag/include/asm/topology.h
> +++ b/arch/metag/include/asm/topology.h
> @@ -3,33 +3,6 @@
> =20
>  #ifdef CONFIG_NUMA
> =20
> -/* sched_domains SD_NODE_INIT for Meta machines */
> -#define SD_NODE_INIT (struct sched_domain) {		\
> -	.parent			=3D NULL,			\
> -	.child			=3D NULL,			\
> -	.groups			=3D NULL,			\
> -	.min_interval		=3D 8,			\
> -	.max_interval		=3D 32,			\
> -	.busy_factor		=3D 32,			\
> -	.imbalance_pct		=3D 125,			\
> -	.cache_nice_tries	=3D 2,			\
> -	.busy_idx		=3D 3,			\
> -	.idle_idx		=3D 2,			\
> -	.newidle_idx		=3D 0,			\
> -	.wake_idx		=3D 0,			\
> -	.forkexec_idx		=3D 0,			\
> -	.flags			=3D SD_LOAD_BALANCE	\
> -				| SD_BALANCE_FORK	\
> -				| SD_BALANCE_EXEC	\
> -				| SD_BALANCE_NEWIDLE	\
> -				| SD_SERIALIZE,		\
> -	.last_balance		=3D jiffies,		\
> -	.balance_interval	=3D 1,			\
> -	.nr_balance_failed	=3D 0,			\
> -	.max_newidle_lb_cost	=3D 0,			\
> -	.next_decay_max_lb_cost	=3D jiffies,		\
> -}
> -
>  #define cpu_to_node(cpu)	((void)(cpu), 0)
>  #define parent_node(node)	((void)(node), 0)
> =20
>=20


--VfWJngtG8TltsDOvruVo8c8PrASAVCMJS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJTKXpiAAoJEGwLaZPeOHZ6mnYQAJJjKaN7zHxKPyu60gZ0RTg9
IDvHHzAeh5GSu2zb6BaBHWO2FIxIAPnIzyjp8T082c/X6qCSU4fbE38O1Q7jshbF
RMR42MP4gOMNBJG8SmQSUYtvvsKjSZU90JAeinn4GmC9Ww4lA2G0vBKq5vJrL2aw
iHOg3xJhfftapvfgH5K6RkToE/Uy+IGLYbzR3WatSg63iMhWfJ+Z8JjOnoj/oAAr
Rj4944OaWBxJv4ilZ3W1MQ+eAWM/5yqwLVYsr3Mupirz3ZNB5c1vCuNpWkQXAzp7
K/xBzQOkr4WNlaYKbWXbaGrCLKsUcuJwMWNf2k9xqyxK2P5WZOTBcFStgcw6A1Xk
OZFj4lMOXFHdQC/amyY56PsKPCq+i88F08hYAzAcvPX/YkRh6Y4s0fYOKgZc+xAe
xpfkakPFOjnjTI5jNtJMWyHCPUOIqTcchs8brNI1bZE5olW2BpQMeL3OeijUqxdy
c4MUH2GpMopBZOrSHbcvjYZ64cfyKBNv9Hv36EiZlq/FF3NX04jPoOrAY54pUnho
zGcsbKoGYd5qUWY4qKo+Lp1V36LCCSS+ikqiciyHSZYrbsTOV2xK7XH9T+jahO3u
MfKuVUJUzp10/C2a6vxeqWI73bGJsZsqYSHa5WlTVYUpMTuWyVbmADkm4wthW/Kn
GxvLEJ1k0/i/DYL/Mm5X
=f5An
-----END PGP SIGNATURE-----

--VfWJngtG8TltsDOvruVo8c8PrASAVCMJS--
