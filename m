Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaEUJXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:23:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57688 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaEUJXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:23:22 -0400
Date: Wed, 21 May 2014 11:23:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Fwd: [V6 00/11] perf: New conditional branch filter
Message-ID: <20140521092313.GF30445@twins.programming.kicks-ass.net>
References: <1399280953-31442-1-git-send-email-khandual@linux.vnet.ibm.com>
 <537C6DDE.9000204@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T3QN4r+OPYJYSwpd"
Content-Disposition: inline
In-Reply-To: <537C6DDE.9000204@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T3QN4r+OPYJYSwpd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2014 at 02:41:58PM +0530, Anshuman Khandual wrote:
> Hello Peter/Ingo,
>=20
> Would you please consider reviewing the first four patches in this patch =
series
> which changes the generic perf kernel and perf tools code. Andi Kleen and=
 Stephane
> Eranian have already reviewed these changes. The rest of the patch series=
 is related
> to powerpc and being reviewed by Michael Ellerman/Ben.
>=20

If they land in my inbox I might have a look.

--T3QN4r+OPYJYSwpd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfHCBAAoJEHZH4aRLwOS6SY8P/1eNOV0SFb3t/L+ZSC8Qheov
sfhNvRmiEMd7Kwa5VeHqsUkloahpX1mb4JO/dzbE09uhYy971O/B2z2IERQbsHFy
aztZrrqJvMf4PhUE+lM+DAuj1q6OY+SVae9oF2gLAQot0UGK9BRxHXt1516BwBCg
WlPgtaNfpyQsko9pdRxQeLA0PWKnzopWmDrsGWRy0Y5TSwIAQ5AN1UMaWz5Za78G
GkNOsERw1vu/VOYTCIiDh9KcNsmyXQ15pJhetR9iBR88c4/7Dv9Lxj2xny5S7sEd
SylmTw0+sTETbempebo33nIb+s1SYNtGAPamyxSL20ccQqgrGpbbioENp9d6ekEK
zCEgb6L2lVnvVSPf0nimvf7bbFKOV7/6Ogzy56vUO9yAIquvBoCppXErbvaCt+Zo
K0ziMC+8ihnKGwgM3QE82/xByec21vGf3PwDPZL9H95wZBpxiJY4c7IE9R0JBKtr
ctAeIQNwpqUUVz5poa2UVUC99xNPPbOi3OpC8oIHL806hqra19EDsnKyKmr+X1cI
hbrv1gtscXVIi13mL1Tes2B06bJxBPI3Ad/5VmXrnC913ennuJGB321KXSATx+0C
G4IK70rDcotzZbGa1+0UN1ElFbEn0xUhiJXOt60NqjDiqzZcOW6aKWa05Rp/vRY/
1SFnkStoCxNlRJh90P8w
=HlRa
-----END PGP SIGNATURE-----

--T3QN4r+OPYJYSwpd--
