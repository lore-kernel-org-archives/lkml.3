Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab3BFNCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 08:02:11 -0500
Received: from multi.imgtec.com ([194.200.65.239]:20362 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab3BFNCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 08:02:06 -0500
Message-ID: <51125431.2090300@imgtec.com>
Date: Wed, 6 Feb 2013 13:01:37 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: Re: linux-next: manual merge of the metag tree with the arc tree
References: <20130206110346.edff1db373e5badee7df04c4@canb.auug.org.au>
In-Reply-To: <20130206110346.edff1db373e5badee7df04c4@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig6B81146F0C8EC5CA914ACBA3"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_06_13_01_51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig6B81146F0C8EC5CA914ACBA3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/02/13 00:03, Stephen Rothwell wrote:
> Hi James,
>=20
> Today's linux-next merge of the metag tree got a conflict in
> tools/perf/perf.h between commit 12bf48ef6194 ("perf, ARC: Enable
> building perf tools for ARC") from the arc tree and commit 6c4a2bebec36=

> ("perf: Enable building perf tools for Meta") from the metag tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action=

> is required).
>=20

Thanks, looks good to me

Cheers
James


--------------enig6B81146F0C8EC5CA914ACBA3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRElQ9AAoJEKHZs+irPybfYUsP+wXQPHJeNIw9riM2ZEYUs2gL
GK1eWMUTMVbJrhtMTfgeYiuw1gM6HjAP6Vby2bSRCtrusqLsR4VoQV2YFhCDVYLl
u+G1vEjM17ukiOpF3kPqKCIysGuf58p85tNbvrKkZT0NoaGZeZDr0T7Wi8a7Q8Da
zV7RqW45jthrTxayky7vyB3M/aG//DRP1NiJsp0v+1dxckCnNT6Wk/HHhwS34mDu
37NKGisCPeE/An39BjlLuRcC+nPnc/5a+Z8dJOBo4qWmJQkwS/hXqNhJCQbPYl/q
BWfY+BSjEffRN0/BVfdVUDRzbpRAX5Irq3tl/cIvUydsxL4ig55iUC7hF6lrNRUy
eX32wpMZInXxIVJgqsdkB0q1NwBEX2Bti35QneoGP0U/LMrk3I7ONlbRDUAjPGDn
bwujW+Af6+d2hNbsNh2k6xM4/DFTBUwCqIz13Kd6TW3fbRtLSrLdzjvMIG8s4YTl
4xrxyLMbmHDrAv2UoD1QZK2OgJzRfo5AlsDkQp/44UXttif6IBtCaEyvxdyc3aoG
9LuLHuLrGw+ZrVC9ffyvqFK2ueJMcA5r6A4lbeJnSjGU3G00aqmtlTdvJOIsx+UZ
hcMoEzD+rs1IWiU8jfj75ASRs76F/gNzSnUBgkIn1VOfUzzUxBILN4aLeKiYTqVC
pr0UMhdLSIWF2ROr3c5i
=fWCw
-----END PGP SIGNATURE-----

--------------enig6B81146F0C8EC5CA914ACBA3--

